import SwiftUI

struct RecipeHomeView: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @EnvironmentObject var favoriteManager: FavoriteManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
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
            
            if recipeViewModel.showingCategorySelection {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(recipeViewModel.getAvailableCategories, id: \.self) { category in
                            Button(action: {
                                recipeViewModel.selectedCategory = category
                                recipeViewModel.generateRandomRecipe()
                            }) {
                                Text(category)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        recipeViewModel.selectedCategory == category ?
                                            Color.blue : Color.gray.opacity(0.2)
                                    )
                                    .foregroundColor(
                                        recipeViewModel.selectedCategory == category ?
                                            .white : .primary
                                    )
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("随机菜谱")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    recipeViewModel.showingCategorySelection.toggle()
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .imageScale(.large)
                }
            }
        }
        .onAppear {
            if recipeViewModel.currentRecipe == nil {
                recipeViewModel.generateRandomRecipe()
            }
        }
    }
}
