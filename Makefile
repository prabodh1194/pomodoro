# PomodoroTimer Makefile
# Build and deploy macOS Pomodoro timer app using Swift Package Manager

APP_NAME = PomodoroTimer
PROJECT_DIR = .
BUILD_DIR = .build
DESKTOP_PATH = ~/Desktop

.PHONY: all build clean install deploy help debug run

# Default target
all: help

# Build the app
build:
	@echo "Building $(APP_NAME)..."
	swift build -c release

# Run the app for testing
run:
	@echo "Running $(APP_NAME)..."
	swift run

# Clean build artifacts
clean:
	@echo "Cleaning Xcode build artifacts..."
	@echo "Cleaning Xcode derived data..."
	@rm -rf ~/Library/Developer/Xcode/DerivedData/PomodoroTimer-* 2>/dev/null || true
	@echo "Cleaning local build artifacts..."
	@if [ -d "$(BUILD_DIR)" ]; then rm -rf $(BUILD_DIR); fi
	@if [ -d "build/" ]; then rm -rf build/; fi
	@echo "Cleaning temporary icon files..."
	@rm -f dock-icon.svg simple-dock-icon.svg 2>/dev/null || true
	@echo "Clean completed - restart Xcode for best results"

# Install app to desktop
install: build
	@echo "Installing $(APP_NAME) to desktop..."
	@BINARY_PATH=".build/release/$(APP_NAME)"; \
	if [ -f "$$BINARY_PATH" ]; then \
		cp "$$BINARY_PATH" $(DESKTOP_PATH)/ && echo "Successfully installed $(APP_NAME) binary to desktop"; \
	else \
		echo "Error: Built binary not found at $$BINARY_PATH"; \
		echo "Contents of .build/release/:"; \
		ls -la ".build/release/" 2>/dev/null || echo "Directory does not exist"; \
		exit 1; \
	fi

# Build and install in one step
deploy: install
	@echo "$(APP_NAME) built and deployed to desktop successfully!"

# Debug - show resolved paths
debug:
	@echo "Debug information for $(APP_NAME):"
	@echo "PROJECT_DIR: $(PROJECT_DIR)"
	@echo "BUILD_DIR: $(BUILD_DIR)"
	@BINARY_PATH=".build/release/$(APP_NAME)"; \
	echo "BINARY_PATH: $$BINARY_PATH"; \
	if [ -f "$$BINARY_PATH" ]; then \
		echo "Binary exists: YES"; \
		echo "Binary info:"; \
		ls -la "$$BINARY_PATH"; \
		file "$$BINARY_PATH"; \
	else \
		echo "Binary exists: NO"; \
		echo "Contents of .build/release/:"; \
		ls -la ".build/release/" 2>/dev/null || echo "Directory does not exist"; \
	fi

# Show help
help:
	@echo "PomodoroTimer Build Commands:"
	@echo "  make build    - Build the app using Swift Package Manager"
	@echo "  make run      - Run the app for testing"
	@echo "  make install  - Build and copy binary to desktop"
	@echo "  make deploy   - Build and install (alias for install)"
	@echo "  make clean    - Clean build artifacts"
	@echo "  make debug    - Show resolved paths for troubleshooting"
	@echo "  make help     - Show this help message"