import XCTest
@testable import RandomEats

final class RecipeViewModelTests: XCTestCase {
    var viewModel: RecipeViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = RecipeViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // 测试用例 1：测试数据加载
    func testDataLoading() {
        XCTAssertFalse(viewModel.recipes.isEmpty, "菜谱数据应该成功加载")
    }
    
    // 测试用例 2：测试随机生成
    func testRandomGeneration() {
        // 第一次生成
        viewModel.generateRandomRecipe()
        let firstRecipe = viewModel.currentRecipe
        XCTAssertNotNil(firstRecipe, "应该成功生成随机菜谱")
        
        // 连续生成多次，检查是否避免短期重复
        var seenRecipes = Set<UUID>()
        for _ in 0..<viewModel.recipes.count {
            viewModel.generateRandomRecipe()
            if let recipe = viewModel.currentRecipe {
                seenRecipes.insert(recipe.id)
            }
        }
        
        XCTAssertEqual(seenRecipes.count, min(viewModel.recipes.count, 5), "应该生成不同的菜谱")
    }
    
    // 测试用例 3：测试分类筛选
    func testCategoryFiltering() {
        let categories = viewModel.getAvailableCategories()
        XCTAssertFalse(categories.isEmpty, "应该有可用的分类")
        
        if let firstCategory = categories.first {
            viewModel.generateRandomRecipe(category: firstCategory)
            XCTAssertNotNil(viewModel.currentRecipe, "应该成功生成指定分类的菜谱")
            XCTAssertEqual(viewModel.currentRecipe?.category, firstCategory, "生成的菜谱应该属于指定分类")
        }
    }
}
