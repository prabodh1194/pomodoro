import Foundation

enum TimerPhase: String, CaseIterable {
    case work = "Work"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"
    case stopped = "Stopped"
    
    var color: String {
        switch self {
        case .work: return "red"
        case .shortBreak: return "green"
        case .longBreak: return "blue"
        case .stopped: return "gray"
        }
    }
    
    var duration: TimeInterval {
        switch self {
        case .work: return 25 * 60
        case .shortBreak: return 5 * 60
        case .longBreak: return 15 * 60
        case .stopped: return 0
        }
    }
}

struct TimerState {
    var currentPhase: TimerPhase = .stopped
    var timeRemaining: TimeInterval = 0
    var totalTime: TimeInterval = 0
    var completedSessions: Int = 0
    var isRunning: Bool = false
    var lastUpdateTime: Date = Date()
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return 1.0 - (timeRemaining / totalTime)
    }
    
    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    mutating func startWorkSession() {
        currentPhase = .work
        timeRemaining = TimerPhase.work.duration
        totalTime = TimerPhase.work.duration
        isRunning = true
        lastUpdateTime = Date()
    }
    
    mutating func startBreak() {
        let shouldTakeLongBreak = completedSessions > 0 && completedSessions % 4 == 0
        currentPhase = shouldTakeLongBreak ? .longBreak : .shortBreak
        timeRemaining = currentPhase.duration
        totalTime = currentPhase.duration
        isRunning = true
        lastUpdateTime = Date()
    }
    
    mutating func completeSession() {
        if currentPhase == .work {
            completedSessions += 1
        }
        isRunning = false
    }
    
    mutating func stop() {
        currentPhase = .stopped
        timeRemaining = 0
        totalTime = 0
        isRunning = false
        lastUpdateTime = Date()
    }
    
    mutating func reset() {
        currentPhase = .stopped
        timeRemaining = 0
        totalTime = 0
        completedSessions = 0
        isRunning = false
        lastUpdateTime = Date()
    }
}