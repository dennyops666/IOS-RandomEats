import SwiftUI

struct ContentView: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @EnvironmentObject var favoriteManager: FavoriteManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RandomRecipeView()
                .tabItem {
                    Label("随机", systemImage: "dice")
                }
                .tag(0)
            
            NavigationView {
                FavoriteListView(favoriteManager: favoriteManager)
                    .navigationTitle("收藏")
            }
            .tabItem {
                Label("收藏", systemImage: "heart.fill")
            }
            .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
                .tag(2)
        }
        .accentColor(themeManager.accentColor)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
}

struct RandomRecipeView: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @EnvironmentObject var favoriteManager: FavoriteManager
    @State private var showingCategorySelection = false
    @State private var selectedCategory: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button(action: {
                    showingCategorySelection.toggle()
                }) {
                    Text(selectedCategory.isEmpty ? "全部分类" : selectedCategory)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Button(action: {
                    let category = selectedCategory.isEmpty ? nil : selectedCategory
                    recipeViewModel.generateRandomRecipe(category: category)
                }) {
                    HStack {
                        Image(systemName: "dice.fill")
                        Text("随机生成菜谱")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                if let recipe = recipeViewModel.currentRecipe {
                    NavigationLink(destination: RecipeDetailView(recipe: recipe, favoriteManager: favoriteManager)) {
                        RecipeCard(recipe: recipe)
                            .padding(.horizontal)
                    }
                } else {
                    // 显示提示信息
                    VStack(spacing: 12) {
                        Image(systemName: "arrow.up.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("点击上方按钮生成菜谱")
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                }
            }
            .padding()
            .navigationTitle("Random Eats")
            .sheet(isPresented: $showingCategorySelection) {
                // 这里添加分类选择视图
                CategorySelectionView(viewModel: recipeViewModel) { category in
                    selectedCategory = category
                    recipeViewModel.generateRandomRecipe(category: category.isEmpty ? nil : category)
                }
            }
        }
    }
}
