import Foundation

// TheMealDB API 响应模型
struct MealDBResponse: Codable {
    let meals: [MealDBRecipe]?
}

struct MealDBRecipe: Codable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strTags: String?
    
    // 食材和用量（TheMealDB 提供20个食材字段）
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    
    // 将计算属性改为方法
    func asRecipe() -> Recipe {
        // 处理食材和用量
        var ingredients: [Ingredient] = []
        let ingredientPairs: [(String?, String?)] = [
            (strIngredient1, strMeasure1),
            (strIngredient2, strMeasure2),
            (strIngredient3, strMeasure3),
            (strIngredient4, strMeasure4),
            (strIngredient5, strMeasure5)
        ]
        
        for (ingredient, measure) in ingredientPairs {
            if let ing = ingredient, !ing.isEmpty,
               let mea = measure, !mea.isEmpty {
                ingredients.append(Ingredient(name: ing, amount: mea))
            }
        }
        
        // 处理烹饪步骤
        let steps = strInstructions?
            .components(separatedBy: "\r\n")
            .filter { !$0.isEmpty }
            ?? []
        
        return Recipe(
            id: idMeal,
            name: strMeal,
            category: strCategory ?? "其他",
            image: strMealThumb ?? "",
            ingredients: ingredients,
            steps: steps
        )
    }
}

struct Recipe: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let category: String
    let image: String
    let ingredients: [Ingredient]
    let steps: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Ingredient: Codable, Hashable {
    let name: String
    let amount: String
}
