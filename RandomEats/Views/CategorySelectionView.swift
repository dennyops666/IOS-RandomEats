import SwiftUI

struct CategorySelectionView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    let onCategorySelected: (String) -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.getAvailableCategories, id: \.apiName) { category in
                    Button(action: {
                        onCategorySelected(category.apiName)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(category.displayName)
                            Spacer()
                            Image(systemName: "arrow.right.circle")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("选择分类")
            .navigationBarItems(trailing: Button("关闭") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
