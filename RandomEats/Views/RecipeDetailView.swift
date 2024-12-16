import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @EnvironmentObject var favoriteManager: FavoriteManager
    
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
                    
                    Text(recipe.category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("食材")
                        .font(.headline)
                    
                    ForEach(recipe.ingredients, id: \.name) { ingredient in
                        HStack {
                            Text("•")
                            Text(ingredient.name)
                            Spacer()
                            Text(ingredient.amount)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    Text("步骤")
                        .font(.headline)
                    
                    ForEach(Array(recipe.steps.enumerated()), id: \.0) { index, step in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .foregroundColor(.secondary)
                            Text(step)
                        }
                        .padding(.vertical, 4)
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
        }
    }
}
