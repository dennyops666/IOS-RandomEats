import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @EnvironmentObject var favoriteManager: FavoriteManager
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView(recipeViewModel: recipeViewModel, favoriteManager: favoriteManager)
        } else {
            VStack {
                VStack {
                    // 主图标
                    Image("app_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    // APP名称
                    Text("Random Eats")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    // 标语
                    Text("Discover Your Next Meal")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    // 添加动画
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                // 2秒后切换到主界面
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(RecipeViewModel())
        .environmentObject(FavoriteManager())
}
