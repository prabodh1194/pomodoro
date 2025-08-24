# macOS Pomodoro Timer App - Complete Documentation

## Overview
A simple, focused macOS Pomodoro timer application with prominent visual cues and widget integration. The app features a screen overlay for maximum visibility and uses WidgetKit for menu bar/widget area integration.

## Features
- **Visual Screen Overlay**: Prominent timer display that overlays the screen
- **Widget Integration**: Shows timer progress in macOS widget area
- **Simple Interface**: Minimal, distraction-free design
- **Customizable Intervals**: Standard Pomodoro (25/5/15) with customization options
- **Background Operation**: Continues running when app is minimized
- **No Audio**: Purely visual feedback system

## Technical Requirements
- **Platform**: macOS Sequoia 15.6.1+
- **Language**: Swift 5.9+
- **Frameworks**: SwiftUI, WidgetKit, AppKit (for overlay)
- **Architecture**: MVVM pattern
- **Data Persistence**: UserDefaults with App Groups

## Project Structure
```
PomodoroTimer/
├── PomodoroTimer/              # Main App Target
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── OverlayView.swift
│   │   └── SettingsView.swift
│   ├── ViewModels/
│   │   └── TimerViewModel.swift
│   ├── Models/
│   │   └── TimerState.swift
│   ├── Services/
│   │   └── OverlayManager.swift
│   └── App.swift
├── PomodoroWidget/             # Widget Extension
│   ├── PomodoroWidget.swift
│   ├── TimelineProvider.swift
│   └── WidgetView.swift
└── Shared/                     # Shared Code
    ├── TimerData.swift
    └── Extensions.swift
```

## Core Architecture

### App Structure
The application follows MVVM (Model-View-ViewModel) architecture for clean separation of concerns:

- **Model Layer**: TimerState object handles all timer data and state
- **View Layer**: SwiftUI views for main interface and overlay
- **ViewModel Layer**: TimerViewModel manages business logic and coordinates between model and views
- **Service Layer**: OverlayManager handles screen overlay functionality

### Data Flow
1. User interactions trigger ViewModel methods
2. ViewModel updates TimerState model
3. Model changes propagate to Views through @Published properties
4. ViewModel saves state to shared UserDefaults for widget access
5. Widget timeline provider reads shared data and updates widget

### Timer States
- **Work Session**: 25-minute focused work period
- **Short Break**: 5-minute rest period after each work session
- **Long Break**: 15-minute rest period after 4 work sessions
- **Stopped**: Timer is inactive

## Screen Overlay Implementation

### Overlay Window Requirements
- **Window Level**: `.floating` to appear above all other windows
- **Positioning**: Top-right corner of screen with 20px margin
- **Style**: Borderless window with transparent background
- **Behavior**: 
  - Stays visible across all spaces
  - Non-intrusive mouse interaction
  - Auto-updates every second during active timer

### Visual Design
- **Progress Indicator**: Circular progress ring with color coding
  - Red: Work session
  - Green: Short break  
  - Blue: Long break
- **Time Display**: Large, monospaced font showing MM:SS format
- **Phase Label**: Current session type (Work/Break)
- **Session Counter**: Number of completed work sessions
- **Background**: Ultra-thin material with subtle shadow

### Overlay Lifecycle
- **Show**: Automatically displays when timer starts
- **Update**: Refreshes every second with current timer state
- **Hide**: Automatically closes when timer stops or completes

## Widget Integration

### Widget Configuration
- **Supported Families**: Small and Medium system widgets
- **Update Policy**: Timeline-based updates
  - Active timer: Updates every 60 seconds
  - Inactive timer: Updates every 15 minutes
- **Data Source**: Shared UserDefaults via App Groups

### Widget Content
- **Small Widget**: Circular progress with time remaining
- **Medium Widget**: Progress + session info + phase indicator
- **Color Coding**: Matches overlay color scheme
- **Real-time Updates**: Synchronized with main app state

### Timeline Provider Logic
- Loads current timer state from shared storage
- Calculates next update time based on timer activity
- Provides placeholder content for widget gallery
- Handles background refresh scheduling

## Data Persistence

### Shared Data Strategy
Uses App Groups to share timer state between main app and widget extension.

### Stored Data Points
- Current timer phase (work/break/stopped)
- Time remaining in current session
- Total time for current session (for progress calculation)
- Number of completed work sessions
- Timer running state (active/paused/stopped)
- Last update timestamp

### Data Synchronization
- Main app writes to shared UserDefaults on every timer tick
- Widget reads from shared storage during timeline updates
- Both use same data keys for consistency
- Automatic conflict resolution through timestamp comparison

## User Interface Design

### Main App Window
- **Minimal Design**: Focus on essential controls only
- **Large Timer Display**: Prominent time remaining with progress ring
- **Simple Controls**: Start/Stop/Reset buttons
- **Session Info**: Current phase and session counter
- **Settings Access**: Gear icon for customization options

### Settings Panel
- **Timer Durations**: Adjustable work/break intervals
- **Session Goals**: Customizable sessions until long break
- **Overlay Preferences**: Position and opacity settings
- **Visual Themes**: Color scheme options

### Accessibility Features
- **VoiceOver Support**: Full screen reader compatibility
- **Keyboard Navigation**: All functions accessible via keyboard
- **High Contrast**: Supports system accessibility preferences
- **Dynamic Type**: Respects system font size settings

## Implementation Strategy

### Phase 1: Core Timer
1. Set up basic project structure with main app target
2. Implement TimerState model with basic properties
3. Create TimerViewModel with start/stop/reset functionality
4. Build simple SwiftUI interface for main controls
5. Add basic timer countdown logic

### Phase 2: Screen Overlay
1. Create OverlayManager service class
2. Implement NSWindow-based overlay system
3. Design SwiftUI overlay view with progress indicator
4. Add automatic positioning and lifecycle management
5. Integrate overlay with main timer logic

### Phase 3: Widget Extension
1. Add widget extension target to project
2. Set up App Groups for data sharing
3. Implement timeline provider with shared data access
4. Create widget views for different family sizes
5. Add automatic timeline refresh coordination

### Phase 4: Polish & Testing
1. Implement settings and customization options
2. Add proper error handling and edge cases
3. Optimize performance and memory usage
4. Test widget behavior in various scenarios
5. Add accessibility features and documentation

## Security & Privacy

### Permissions Required
- **Screen Recording**: May be needed for overlay functionality
- **App Groups**: Required for widget data sharing
- **Background Processing**: For accurate timer continuation

### Data Privacy
- All timer data stored locally on device
- No network communication or data collection
- Shared data limited to timer state information
- No personal information stored or transmitted

## Testing Strategy

### Unit Testing
- Timer logic accuracy and state transitions
- Data persistence and sharing mechanisms
- ViewModel business logic and edge cases
- Utility functions and calculations

### Integration Testing
- Main app and widget data synchronization
- Overlay display and positioning behavior
- Background timer continuation accuracy
- Widget timeline refresh coordination

### User Testing
- Overlay visibility and positioning across different screen configurations
- Widget appearance in various contexts (light/dark mode, different wallpapers)
- Timer accuracy during system sleep/wake cycles
- Performance under extended usage

## Deployment Considerations

### App Store Guidelines
- Ensure overlay doesn't interfere with system UI
- Proper entitlements for required permissions
- Clear privacy policy for any data usage
- Accessibility compliance verification

### Distribution
- Mac App Store distribution recommended
- Requires proper code signing and notarization
- Widget extension must be bundled with main app
- Consider offering free tier with premium customization options

## Future Enhancement Ideas

### Advanced Features
- Multiple timer presets for different work types
- Statistics tracking and productivity insights
- Integration with calendar apps for automatic scheduling
- Team collaboration features for shared sessions

### Visual Improvements
- Custom themes and color schemes
- Animated transitions and micro-interactions
- Menu bar icon with mini progress indicator
- Full-screen focus mode option

### Productivity Integration
- Task list integration for session planning
- Break activity suggestions
- Distraction blocking during work sessions
- Export/import of timer configurations

This documentation provides a comprehensive foundation for building a simple yet effective macOS Pomodoro timer with prominent visual feedback and seamless widget integration.
