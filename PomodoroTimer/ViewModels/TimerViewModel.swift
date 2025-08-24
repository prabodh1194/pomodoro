import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var timerState = TimerState()
    
    private var timer: Timer?
    
    init() {
        loadPersistedState()
        startTimerIfNeeded()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func loadPersistedState() {
        if let data = UserDefaults.standard.data(forKey: "TimerState"),
           let state = try? JSONDecoder().decode(TimerState.self, from: data) {
            timerState = state
            
            if timerState.isRunning {
                let elapsed = Date().timeIntervalSince(timerState.lastUpdateTime)
                timerState.timeRemaining = max(0, timerState.timeRemaining - elapsed)
                
                if timerState.timeRemaining <= 0 {
                    handleTimerCompletion()
                }
            }
        }
    }
    
    private func startTimerIfNeeded() {
        guard timerState.isRunning && timerState.timeRemaining > 0 else { return }
        startTimer()
    }
    
    func startWorkSession() {
        timer?.invalidate()
        timerState.startWorkSession()
        saveState()
        startTimer()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerState.stop()
        saveState()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerState.reset()
        saveState()
    }
    
    func pauseResumeTimer() {
        if timerState.isRunning {
            timer?.invalidate()
            timer = nil
            timerState.isRunning = false
        } else if timerState.timeRemaining > 0 {
            timerState.isRunning = true
            startTimer()
        }
        saveState()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func updateTimer() {
        guard timerState.timeRemaining > 0 else {
            handleTimerCompletion()
            return
        }
        
        timerState.timeRemaining -= 1
        timerState.lastUpdateTime = Date()
        saveState()
    }
    
    private func handleTimerCompletion() {
        timer?.invalidate()
        timer = nil
        
        timerState.completeSession()
        
        switch timerState.currentPhase {
        case .work:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.timerState.startBreak()
                self.saveState()
                self.startTimer()
            }
        case .shortBreak, .longBreak:
            timerState.stop()
            saveState()
        case .stopped:
            break
        }
    }
    
    private func saveState() {
        if let encoded = try? JSONEncoder().encode(timerState) {
            UserDefaults.standard.set(encoded, forKey: "TimerState")
        }
    }
}