import SwiftUI

struct CategorySelectionView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    let onCategorySelected: (String) -> Void
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    onCategorySelected("")
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text("全部分类")
                        Spacer()
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.blue)
                    }
                }
                
                ForEach(Array(viewModel.getAvailableCategories), id: \.self) { category in
                    Button(action: {
                        onCategorySelected(category)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(category)
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
