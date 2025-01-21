import SwiftUI

struct CategoryView : View{
    let category: Category
    
    var body: some View{
        HStack {
            Text(category.name)
                .font(.subheadline)
                .cornerRadius(10)
        
            Spacer()
        
            category.colorComponent.color
                .frame(width: 30, height: 30)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
        }
    }
}
