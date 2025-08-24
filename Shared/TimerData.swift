import Foundation

struct SharedTimerData: Codable {
    let currentPhase: String
    let timeRemaining: TimeInterval
    let totalTime: TimeInterval
    let completedSessions: Int
    let isRunning: Bool
    let lastUpdateTime: Date
    
    init(from timerState: TimerState) {
        self.currentPhase = timerState.currentPhase.rawValue
        self.timeRemaining = timerState.timeRemaining
        self.totalTime = timerState.totalTime
        self.completedSessions = timerState.completedSessions
        self.isRunning = timerState.isRunning
        self.lastUpdateTime = timerState.lastUpdateTime
    }
    
    func toTimerState() -> TimerState {
        var state = TimerState()
        state.currentPhase = TimerPhase(rawValue: currentPhase) ?? .stopped
        state.timeRemaining = timeRemaining
        state.totalTime = totalTime
        state.completedSessions = completedSessions
        state.isRunning = isRunning
        state.lastUpdateTime = lastUpdateTime
        return state
    }
}

class SharedDataManager {
    static let shared = SharedDataManager()
    private let userDefaults: UserDefaults
    private let dataKey = "SharedTimerData"
    
    private init() {
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.example.PomodoroTimer") else {
            fatalError("Unable to create shared UserDefaults")
        }
        self.userDefaults = sharedDefaults
    }
    
    func saveTimerData(_ timerState: TimerState) {
        let sharedData = SharedTimerData(from: timerState)
        if let encoded = try? JSONEncoder().encode(sharedData) {
            userDefaults.set(encoded, forKey: dataKey)
            userDefaults.synchronize()
        }
    }
    
    func loadTimerData() -> TimerState? {
        guard let data = userDefaults.data(forKey: dataKey),
              let sharedData = try? JSONDecoder().decode(SharedTimerData.self, from: data) else {
            return nil
        }
        return sharedData.toTimerState()
    }
    
    func clearTimerData() {
        userDefaults.removeObject(forKey: dataKey)
        userDefaults.synchronize()
    }
}