import Foundation

class FavoriteManager: ObservableObject {
    @Published private(set) var favorites: [FavoriteRecipe] = []
    private let saveKey = "FavoriteRecipes"
    
    init() {
        loadFavorites()
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            do {
                favorites = try JSONDecoder().decode([FavoriteRecipe].self, from: data)
            } catch {
                print("Error loading favorites: \(error)")
            }
        }
    }
    
    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Error saving favorites: \(error)")
        }
    }
    
    func addFavorite(_ recipe: Recipe) {
        let favorite = FavoriteRecipe(recipe: recipe)
        favorites.append(favorite)
        saveFavorites()
    }
    
    func removeFavorite(_ favorite: FavoriteRecipe) {
        favorites.removeAll { $0.id == favorite.id }
        saveFavorites()
    }
    
    func removeFavoriteByRecipe(_ recipe: Recipe) {
        favorites.removeAll { $0.recipe.id == recipe.id }
        saveFavorites()
    }
    
    func isFavorite(_ recipe: Recipe) -> Bool {
        favorites.contains { $0.recipe.id == recipe.id }
    }
}
