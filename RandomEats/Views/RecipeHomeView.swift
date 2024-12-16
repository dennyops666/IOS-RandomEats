import SwiftUI

struct RecipeHomeView: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @EnvironmentObject var favoriteManager: FavoriteManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            // 随机生成按钮
            Button(action: {
                recipeViewModel.generateRandomRecipe()
            }) {
                HStack {
                    Image(systemName: "dice")
                    Text("随机生成菜谱")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .disabled(recipeViewModel.isLoading)
            .padding(.horizontal)
            
            // 分类显示
            if let recipe = recipeViewModel.currentRecipe {
                HStack {
                    Image(systemName: "list.bullet")
                    Text(recipeViewModel.getDisplayName(for: recipe.category ?? "all"))
                        .font(.headline)
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                .onTapGesture {
                    recipeViewModel.showingCategorySelection.toggle()
                }
            }
            
            if recipeViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else if let recipe = recipeViewModel.currentRecipe {
                ScrollView {
                    RecipeDetailView(recipe: recipe)
                        .padding()
                }
            } else if let errorMessage = recipeViewModel.errorMessage {
                VStack(spacing: 10) {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    
                    Button("重试") {
                        recipeViewModel.generateRandomRecipe()
                    }
                    .foregroundColor(.blue)
                }
            }
            
            if recipeViewModel.showingCategorySelection {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(recipeViewModel.getAvailableCategories, id: \.apiName) { category in
                            Button(action: {
                                recipeViewModel.selectedCategory = category.apiName
                                recipeViewModel.showingCategorySelection = false
                                recipeViewModel.generateRandomRecipe(category: category.apiName)
                            }) {
                                Text(category.displayName)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        recipeViewModel.selectedCategory == category.apiName ?
                                            Color.blue : Color.gray.opacity(0.2)
                                    )
                                    .foregroundColor(
                                        recipeViewModel.selectedCategory == category.apiName ?
                                            .white : .primary
                                    )
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            }
            
            Spacer()
        }
        .navigationBarTitle("随机菜谱", displayMode: .inline)
        .onAppear {
            if recipeViewModel.currentRecipe == nil {
                recipeViewModel.generateRandomRecipe()
            }
        }
    }
}
