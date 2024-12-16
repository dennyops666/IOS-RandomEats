import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @EnvironmentObject var favoriteManager: FavoriteManager
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: recipe.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(recipe.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            favoriteManager.toggleFavorite(recipe)
                        }) {
                            Image(systemName: favoriteManager.isFavorite(recipe) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .imageScale(.large)
                        }
                    }
                    
                    if let category = recipe.category {
                        Text(recipeViewModel.getDisplayName(for: category))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("食材:")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    ForEach(recipe.ingredients, id: \.name) { ingredient in
                        HStack {
                            Text("•")
                            Text("\(ingredient.name): \(ingredient.amount)")
                        }
                        .font(.subheadline)
                    }
                    
                    if !recipe.steps.isEmpty {
                        Text("步骤:")
                            .font(.headline)
                            .padding(.top, 16)
                        
                        ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                            Text("\(index + 1). \(step)")
                                .font(.subheadline)
                                .padding(.vertical, 4)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeDetailView(recipe: Recipe(
                id: "1",
                name: "测试菜谱",
                category: "测试类别",
                image: "",
                ingredients: [
                    Ingredient(name: "测试食材1", amount: "100g"),
                    Ingredient(name: "测试食材2", amount: "200g")
                ],
                steps: ["步骤1", "步骤2"]
            ))
            .environmentObject(FavoriteManager())
            .environmentObject(RecipeViewModel())
        }
    }
}
