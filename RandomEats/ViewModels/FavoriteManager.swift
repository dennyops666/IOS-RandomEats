import SwiftUI
import Foundation

class FavoriteManager: ObservableObject {
    @Published private(set) var favorites: [Recipe] = []
    private let favoritesKey = AppConfig.UserDefaults.favoriteRecipesKey
    
    init() {
        loadFavorites()
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey) {
            do {
                // 尝试使用新的数据格式解码
                let decoder = JSONDecoder()
                favorites = try decoder.decode([Recipe].self, from: data)
            } catch {
                // 如果解码失败，清除旧数据并开始新的收藏列表
                print("Error decoding favorites: \(error)")
                UserDefaults.standard.removeObject(forKey: favoritesKey)
                favorites = []
            }
        }
    }
    
    func toggleFavorite(_ recipe: Recipe) {
        if let index = favorites.firstIndex(where: { $0.id == recipe.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(recipe)
        }
        saveFavorites()
    }
    
    func removeFavoriteAtIndex(_ index: Int) {
        favorites.remove(at: index)
        saveFavorites()
    }
    
    private func saveFavorites() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favorites)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Error saving favorites: \(error)")
        }
    }
    
    func isFavorite(_ recipe: Recipe) -> Bool {
        return favorites.contains(where: { $0.id == recipe.id })
    }
}
