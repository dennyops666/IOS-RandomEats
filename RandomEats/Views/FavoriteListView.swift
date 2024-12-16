import SwiftUI

struct FavoriteListView: View {
    @ObservedObject var favoriteManager: FavoriteManager
    
    var body: some View {
        List {
            ForEach(favoriteManager.favorites.sorted(by: { $0.dateAdded > $1.dateAdded })) { favorite in
                NavigationLink(destination: RecipeDetailView(recipe: favorite.recipe, favoriteManager: favoriteManager)) {
                    HStack {
                        if let image = UIImage(named: favorite.recipe.image) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(favorite.recipe.name)
                                .font(.headline)
                            Text(favorite.recipe.category)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .onDelete(perform: deleteFavorites)
        }
        .navigationTitle("收藏菜谱")
        .listStyle(InsetGroupedListStyle())
    }
    
    private func deleteFavorites(at offsets: IndexSet) {
        let sortedFavorites = favoriteManager.favorites.sorted(by: { $0.dateAdded > $1.dateAdded })
        offsets.forEach { index in
            favoriteManager.removeFavorite(sortedFavorites[index])
        }
    }
}

struct FavoriteListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FavoriteListView(favoriteManager: FavoriteManager())
        }
    }
}
