import SwiftUI

struct ContentView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var favoriteManager = FavoriteManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("首页")
            }
            .tag(0)
            
            NavigationView {
                FavoriteListView()
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("收藏")
            }
            .tag(1)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
            .tag(2)
        }
        .environmentObject(recipeViewModel)
        .environmentObject(favoriteManager)
    }
}

struct HomeView: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @State private var selectedCategory: String? = nil
    @State private var showingCategorySelection = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                generateRecipeButton
                categorySelectionButton
                mainContent
            }
            .padding(.vertical)
        }
        .navigationTitle("Random Eats")
        .sheet(isPresented: $showingCategorySelection) {
            CategorySelectionView(viewModel: recipeViewModel) { category in
                selectedCategory = category
                recipeViewModel.generateRandomRecipe(category: category.isEmpty ? nil : category)
            }
        }
    }
    
    private var generateRecipeButton: some View {
        Button(action: {
            let category = selectedCategory ?? ""
            recipeViewModel.generateRandomRecipe(category: category.isEmpty ? nil : category)
        }) {
            HStack {
                Image(systemName: "dice.fill")
                Text("随机生成菜谱")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
    
    private var categorySelectionButton: some View {
        Button(action: {
            showingCategorySelection.toggle()
        }) {
            HStack {
                Image(systemName: "list.bullet")
                Text(selectedCategory ?? "全部分类")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.primary)
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var mainContent: some View {
        if recipeViewModel.isLoading {
            ProgressView()
                .scaleEffect(1.5)
                .padding()
        } else if let errorMessage = recipeViewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
        } else if let recipe = recipeViewModel.currentRecipe {
            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                RecipeCard(recipe: recipe)
                    .padding(.horizontal)
            }
        } else {
            VStack(spacing: 16) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                Text("点击上方按钮生成菜谱")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, minHeight: 200)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
