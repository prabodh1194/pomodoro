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
                Section(header: Text("Developer Mode")) {
                    Toggle("Enable Custom Settings", isOn: $developerMode)
                        .toggleStyle(SwitchToggleStyle())
                }
                
                if developerMode {
                    Section(header: Text("Time Durations")) {
                        VStack(alignment: .leading) {
                            Text("Work Session: \(formatDuration(workDuration))")
                            Slider(value: $workDuration, in: 60...60*60, step: 60)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Short Break: \(formatDuration(shortBreakDuration))")
                            Slider(value: $shortBreakDuration, in: 60...30*60, step: 60)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Long Break: \(formatDuration(longBreakDuration))")
                            Slider(value: $longBreakDuration, in: 60...60*60, step: 60)
                        }
                        
                        Stepper("Sessions until long break: \(sessionsUntilLongBreak)", 
                               value: $sessionsUntilLongBreak, in: 1...10)
                    }
                    
                    Section(header: Text("Presets")) {
                        Button("Classic Pomodoro (25/5/15)") {
                            workDuration = 25 * 60
                            shortBreakDuration = 5 * 60
                            longBreakDuration = 15 * 60
                            sessionsUntilLongBreak = 4
                        }
                        
                        Button("Focus Mode (50/10/20)") {
                            workDuration = 50 * 60
                            shortBreakDuration = 10 * 60
                            longBreakDuration = 20 * 60
                            sessionsUntilLongBreak = 3
                        }
                        
                        Button("Sprint Mode (15/3/10)") {
                            workDuration = 15 * 60
                            shortBreakDuration = 3 * 60
                            longBreakDuration = 10 * 60
                            sessionsUntilLongBreak = 6
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        isPresented = false
                    }
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