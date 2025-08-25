import SwiftUI

struct SettingsView: View {
    @AppStorage("workDuration") private var workDuration: Double = 25 * 60
    @AppStorage("shortBreakDuration") private var shortBreakDuration: Double = 5 * 60
    @AppStorage("longBreakDuration") private var longBreakDuration: Double = 15 * 60
    @AppStorage("sessionsUntilLongBreak") private var sessionsUntilLongBreak: Int = 4
    @AppStorage("developerMode") private var developerMode: Bool = false
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Developer Mode").font(.headline)) {
                    Toggle("Enable Custom Settings", isOn: $developerMode)
                        .toggleStyle(SwitchToggleStyle())
                }
                .padding(.bottom, 8)
                
                if developerMode {
                    Section(header: Text("Time Durations").font(.headline)) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Work Session: \(formatDuration(workDuration))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Slider(value: $workDuration, in: 60...60*60, step: 60)
                        }
                        .padding(.vertical, 4)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Short Break: \(formatDuration(shortBreakDuration))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Slider(value: $shortBreakDuration, in: 60...30*60, step: 60)
                        }
                        .padding(.vertical, 4)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Long Break: \(formatDuration(longBreakDuration))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Slider(value: $longBreakDuration, in: 60...60*60, step: 60)
                        }
                        .padding(.vertical, 4)
                        
                        Stepper("Sessions until long break: \(sessionsUntilLongBreak)", 
                               value: $sessionsUntilLongBreak, in: 1...10)
                    }
                    .padding(.bottom, 8)
                    
                    Section(header: Text("Presets").font(.headline)) {
                        VStack(spacing: 8) {
                            Button("Classic Pomodoro (25/5/15)") {
                                workDuration = 25 * 60
                                shortBreakDuration = 5 * 60
                                longBreakDuration = 15 * 60
                                sessionsUntilLongBreak = 4
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.regular)
                            
                            Button("Focus Mode (50/10/20)") {
                                workDuration = 50 * 60
                                shortBreakDuration = 10 * 60
                                longBreakDuration = 20 * 60
                                sessionsUntilLongBreak = 3
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.regular)
                            
                            Button("Sprint Mode (15/3/10)") {
                                workDuration = 15 * 60
                                shortBreakDuration = 3 * 60
                                longBreakDuration = 10 * 60
                                sessionsUntilLongBreak = 6
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.regular)
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .frame(minWidth: 400, minHeight: 500)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        isPresented = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    private func formatDuration(_ seconds: Double) -> String {
        let minutes = Int(seconds / 60)
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours)h \(remainingMinutes)m"
        }
    }
}

#Preview {
    SettingsView(isPresented: .constant(true))
}