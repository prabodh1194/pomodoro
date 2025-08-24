import Foundation

extension TimeInterval {
    var formattedTimer: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension Date {
    func timeIntervalSinceReferenceDate() -> TimeInterval {
        return self.timeIntervalSinceReferenceDate
    }
}