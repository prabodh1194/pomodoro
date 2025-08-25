# PomodoroTimer Makefile
# Build and deploy macOS Pomodoro timer app using Xcode

APP_NAME = PomodoroTimer
PROJECT_FILE = PomodoroTimer.xcodeproj
SCHEME = PomodoroTimer
BUILD_DIR = build
CONFIGURATION = Release
APP_PATH = $(BUILD_DIR)/Build/Products/$(CONFIGURATION)/$(APP_NAME).app
APPLICATIONS_PATH = /Applications
DESKTOP_PATH = ~/Desktop

.PHONY: all build clean install deploy help debug run

# Default target
all: help

# Build the app
build:
	@echo "Building $(APP_NAME)..."
	xcodebuild -project $(PROJECT_FILE) -scheme $(SCHEME) -configuration $(CONFIGURATION) -derivedDataPath $(BUILD_DIR) build

# Run the app for testing
run: build
	@echo "Running $(APP_NAME)..."
	@if [ -d "$(APP_PATH)" ]; then \
		open "$(APP_PATH)"; \
	else \
		echo "Error: App bundle not found at $(APP_PATH)"; \
		exit 1; \
	fi

# Clean build artifacts
clean:
	@echo "Cleaning Xcode build artifacts..."
	@echo "Cleaning Xcode derived data..."
	@rm -rf ~/Library/Developer/Xcode/DerivedData/PomodoroTimer-* 2>/dev/null || true
	@echo "Cleaning local build artifacts..."
	@if [ -d "$(BUILD_DIR)" ]; then rm -rf $(BUILD_DIR); fi
	@echo "Cleaning temporary icon files..."
	@rm -f dock-icon.svg simple-dock-icon.svg 2>/dev/null || true
	@echo "Clean completed - restart Xcode for best results"

# Install app to Desktop
install: build
	@echo "Installing $(APP_NAME) to Desktop..."
	@if [ -d "$(APP_PATH)" ]; then \
		cp -R "$(APP_PATH)" $(DESKTOP_PATH)/ && echo "Successfully installed $(APP_NAME).app to Desktop"; \
	else \
		echo "Error: App bundle not found at $(APP_PATH)"; \
		echo "Contents of $(BUILD_DIR)/Build/Products/$(CONFIGURATION)/:"; \
		ls -la "$(BUILD_DIR)/Build/Products/$(CONFIGURATION)/" 2>/dev/null || echo "Directory does not exist"; \
		exit 1; \
	fi

# Install app to Applications folder (alternative)
install-apps: build
	@echo "Installing $(APP_NAME) to Applications folder..."
	@if [ -d "$(APP_PATH)" ]; then \
		sudo cp -R "$(APP_PATH)" $(APPLICATIONS_PATH)/ && echo "Successfully installed $(APP_NAME).app to Applications folder"; \
	else \
		echo "Error: App bundle not found at $(APP_PATH)"; \
		echo "Contents of $(BUILD_DIR)/Build/Products/$(CONFIGURATION)/:"; \
		ls -la "$(BUILD_DIR)/Build/Products/$(CONFIGURATION)/" 2>/dev/null || echo "Directory does not exist"; \
		exit 1; \
	fi

# Build and install in one step
deploy: install
	@echo "$(APP_NAME) built and deployed successfully!"

# Debug - show resolved paths
debug:
	@echo "Debug information for $(APP_NAME):"
	@echo "PROJECT_FILE: $(PROJECT_FILE)"
	@echo "BUILD_DIR: $(BUILD_DIR)"
	@echo "APP_PATH: $(APP_PATH)"
	@if [ -d "$(APP_PATH)" ]; then \
		echo "App bundle exists: YES"; \
		echo "App bundle info:"; \
		ls -la "$(APP_PATH)"; \
	else \
		echo "App bundle exists: NO"; \
		echo "Contents of $(BUILD_DIR)/Build/Products/$(CONFIGURATION)/:"; \
		ls -la "$(BUILD_DIR)/Build/Products/$(CONFIGURATION)/" 2>/dev/null || echo "Directory does not exist"; \
	fi

# Show help
help:
	@echo "PomodoroTimer Build Commands:"
	@echo "  make build           - Build the app using Xcode"
	@echo "  make run             - Build and run the app for testing"
	@echo "  make install         - Build and install app to Desktop"
	@echo "  make install-apps    - Build and install app to Applications folder (requires sudo)"
	@echo "  make deploy          - Build and install to Desktop (alias for install)"
	@echo "  make clean           - Clean build artifacts"
	@echo "  make debug           - Show resolved paths for troubleshooting"
	@echo "  make help            - Show this help message"