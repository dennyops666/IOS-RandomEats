import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.6
    @State private var opacity = 0.0
    @State private var rotation: Double = 0
    @State private var diceRotation: Double = 0
    @State private var diceOffset: CGFloat = -80
    @State private var plateScale: CGFloat = 1.0
    @State private var bowlRotation: Double = -30
    
    // 自定义颜色
    let primaryColor = Color(red: 255/255, green: 69/255, blue: 0/255).opacity(0.92) // 暖橙色
    let accentColor = Color(red: 255/255, green: 140/255, blue: 0/255).opacity(0.95) // 明亮橙色
    let secondaryColor = Color(red: 128/255, green: 128/255, blue: 128/255).opacity(0.75) // 中性灰色
    
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @EnvironmentObject var favoriteManager: FavoriteManager
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // 渐变背景
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor.systemBackground),
                        primaryColor.opacity(0.03),
                        accentColor.opacity(0.03),
                        Color(UIColor.systemBackground)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // 动画图标组合
                    ZStack {
                        // 外圈光环
                        Circle()
                            .stroke(primaryColor.opacity(0.12), lineWidth: 4)
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(rotation))
                        
                        // 内圈光环
                        Circle()
                            .stroke(accentColor.opacity(0.15), lineWidth: 3)
                            .frame(width: 170, height: 170)
                            .rotationEffect(.degrees(-rotation))
                        
                        // 碗和筷子图标
                        Image(systemName: "bowl.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                            .foregroundStyle(primaryColor)
                            .rotationEffect(.degrees(bowlRotation))
                            .scaleEffect(plateScale)
                            .offset(y: 5)
                        
                        // 筷子
                        HStack(spacing: 10) {
                            Rectangle()
                                .fill(accentColor)
                                .frame(width: 4, height: 85)
                                .rotationEffect(.degrees(-15))
                            Rectangle()
                                .fill(accentColor)
                                .frame(width: 4, height: 85)
                                .rotationEffect(.degrees(15))
                        }
                        .offset(y: -20)
                        .rotationEffect(.degrees(bowlRotation))
                        
                        // 骰子图标
                        Image(systemName: "dice.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                            .foregroundStyle(accentColor)
                            .offset(x: 60, y: diceOffset)
                            .rotationEffect(.degrees(diceRotation))
                            
                        // 食物图标
                        Image(systemName: "carrot.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 38, height: 38)
                            .foregroundStyle(primaryColor)
                            .offset(x: -50, y: -35)
                            .rotationEffect(.degrees(-rotation * 0.5))
                    }
                    .padding(.bottom, 25)
                    
                    VStack(spacing: 15) {
                        // APP名称
                        Text("Random Eats")
                            .font(.system(size: 42, weight: .heavy, design: .rounded))
                            .foregroundStyle(primaryColor)
                        
                        // 标语
                        Text("Discover Your Next Meal")
                            .font(.system(size: 22, weight: .medium, design: .rounded))
                            .foregroundStyle(secondaryColor)
                    }
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    // 添加连续旋转动画
                    withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                        self.rotation = 360
                    }
                    
                    // 碗的摇摆动画
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        self.bowlRotation = 30
                    }
                    
                    // 骰子弹跳动画
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.6)) {
                        self.diceOffset = -60
                    }
                    
                    // 骰子旋转动画
                    withAnimation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 8, initialVelocity: 0)) {
                        self.diceRotation = 1080
                    }
                    
                    // 碗的缩放动画
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        self.plateScale = 1.15
                    }
                    
                    // 整体渐入和缩放动画
                    withAnimation(.easeOut(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                    
                    // 3秒后切换到主界面
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(RecipeViewModel())
        .environmentObject(FavoriteManager())
}
