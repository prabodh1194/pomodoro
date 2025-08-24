import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 10) {
                HStack {
                    Text("🍅")
                        .font(.system(size: 32))
                    Text(viewModel.timerState.currentPhase.rawValue)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(phaseColor)
                }
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: viewModel.timerState.progress)
                        .stroke(phaseColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.5), value: viewModel.timerState.progress)
                    
                    VStack {
                        Text(viewModel.timerState.formattedTime)
                            .font(.system(size: 48, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(phaseColor)
                        
                        if viewModel.timerState.completedSessions > 0 {
                            Text("Sessions: \(viewModel.timerState.completedSessions)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            HStack(spacing: 20) {
                if viewModel.timerState.currentPhase == .stopped {
                    Button("Start Work Session") {
                        viewModel.startWorkSession()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                } else {
                    Button(viewModel.timerState.isRunning ? "Pause" : "Resume") {
                        viewModel.pauseResumeTimer()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    
                    Button("Stop") {
                        viewModel.stopTimer()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                
                if viewModel.timerState.completedSessions > 0 {
                    Button("Reset") {
                        viewModel.resetTimer()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
            }
        }
        .padding(40)
        .frame(minWidth: 320, minHeight: 400)
    }
    
    private var phaseColor: Color {
        switch viewModel.timerState.currentPhase {
        case .work:
            return .red
        case .shortBreak:
            return .green
        case .longBreak:
            return .blue
        case .stopped:
            return .gray
        }
    }
}

#Preview {
    ContentView()
}