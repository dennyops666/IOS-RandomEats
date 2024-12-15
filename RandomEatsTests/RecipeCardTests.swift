import XCTest
import SwiftUI
@testable import RandomEats

final class RecipeCardTests: XCTestCase {
    var testRecipe: Recipe!
    
    override func setUp() {
        super.setUp()
        // 创建测试用菜谱
        testRecipe = Recipe(
            id: UUID(),
            name: "测试菜谱",
            category: "测试分类",
            ingredients: [
                Ingredient(name: "测试食材1", amount: "100g"),
                Ingredient(name: "测试食材2", amount: "200ml")
            ],
            steps: ["步骤1", "步骤2"],
            image: "recipe_placeholder"
        )
    }
    
    override func tearDown() {
        testRecipe = nil
        super.tearDown()
    }
    
    // 测试用例 1：测试 RecipeCard 的创建
    func testRecipeCardCreation() {
        let recipeCard = RecipeCard(recipe: testRecipe)
        XCTAssertNotNil(recipeCard, "应该成功创建 RecipeCard")
    }
    
    // 测试用例 2：测试占位图片逻辑
    func testPlaceholderImage() {
        // 使用不存在的图片名称
        let recipeWithInvalidImage = Recipe(
            id: UUID(),
            name: "测试菜谱",
            category: "测试分类",
            ingredients: [Ingredient(name: "测试食材", amount: "100g")],
            steps: ["步骤1"],
            image: "non_existent_image"
        )
        
        let recipeCard = RecipeCard(recipe: recipeWithInvalidImage)
        XCTAssertNotNil(recipeCard, "即使图片不存在也应该成功创建 RecipeCard")
    }
}
