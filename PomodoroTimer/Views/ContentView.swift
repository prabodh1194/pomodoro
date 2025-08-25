import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Spacer()
                Button(action: { showingSettings = true }) {
                    Image(systemName: "gear")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            
            VStack(spacing: 20) {
                HStack(spacing: 12) {
                    Text("🍅")
                        .font(.system(size: 40))
                    Text(viewModel.timerState.currentPhase.rawValue)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(phaseColor)
                }
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                        .frame(width: 260, height: 260)
                    
                    Circle()
                        .trim(from: 0, to: viewModel.timerState.progress)
                        .stroke(phaseColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 260, height: 260)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.5), value: viewModel.timerState.progress)
                    
                    VStack(spacing: 8) {
                        Text(viewModel.timerState.formattedTime)
                            .font(.system(size: 56, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(phaseColor)
                        
                        if viewModel.timerState.completedSessions > 0 {
                            Text("Sessions: \(viewModel.timerState.completedSessions)")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            HStack(spacing: 16) {
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
        .padding(50)
        .frame(minWidth: 480, minHeight: 520)
        .sheet(isPresented: $showingSettings) {
            SettingsView(isPresented: $showingSettings)
        }
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