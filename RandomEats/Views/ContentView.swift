import SwiftUI

struct ContentView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @ObservedObject var favoriteManager: FavoriteManager
    @State private var showingCategorySelection = false
    @State private var selectedCategory: String = ""
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RandomRecipeView(
                recipeViewModel: recipeViewModel,
                favoriteManager: favoriteManager,
                showingCategorySelection: $showingCategorySelection,
                selectedCategory: $selectedCategory
            )
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
        }
        .sheet(isPresented: $showingCategorySelection) {
            CategorySelectionView(viewModel: recipeViewModel) { category in
                selectedCategory = category
                recipeViewModel.generateRandomRecipe(category: category.isEmpty ? nil : category)
            }
        }
    }
}

struct RandomRecipeView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @ObservedObject var favoriteManager: FavoriteManager
    @Binding var showingCategorySelection: Bool
    @Binding var selectedCategory: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 分类选择按钮
                    Button(action: {
                        showingCategorySelection = true
                    }) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text(selectedCategory.isEmpty ? "全部分类" : selectedCategory)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // 随机菜谱生成按钮
                    Button(action: {
                        recipeViewModel.generateRandomRecipe(category: selectedCategory.isEmpty ? nil : selectedCategory)
                    }) {
                        HStack {
                            Image(systemName: "dice")
                            Text("随机生成菜谱")
                        }
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    // 菜谱卡片
                    if let currentRecipe = recipeViewModel.currentRecipe {
                        NavigationLink(destination: RecipeDetailView(recipe: currentRecipe, favoriteManager: favoriteManager)) {
                            RecipeCard(recipe: currentRecipe)
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
                .padding(.vertical)
            }
            .navigationTitle("Random Eats")
        }
    }
}
