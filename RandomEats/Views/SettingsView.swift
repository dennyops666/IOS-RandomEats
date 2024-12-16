import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("外观")) {
                    Toggle(isOn: $themeManager.isDarkMode) {
                        Label("深色模式", systemImage: "moon.fill")
                    }
                }
                
                Section(header: Text("关于")) {
                    HStack {
                        Label("版本", systemImage: "info.circle")
                        Spacer()
                        Text("v1.1.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("设置")
            .onAppear {
                themeManager.isDarkMode = UIApplication.shared.windows.first?.traitCollection.userInterfaceStyle == .dark
            }
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ThemeManager())
    }
}
