//
//  AddCategoryToTaskView.swift
//  TaskList
//
//  Created by found on 10/12/24.
//

import SwiftUI
import SwiftData

struct AddCategoryToTaskView : View{
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query var categories : [Category]
    
    @Binding var taskSelected: Task
    
    var body : some View {
        HStack{
            Image(systemName: "rainbow").symbolRenderingMode(.multicolor).resizable().frame(width: 30, height: 15)
            Text("Adicione uma categoria à sua compra!")
                .font(.title).padding(.top).fontWeight(.bold)
        }
        List{
            Section{
                ForEach(categories){ categ in
                    CategoryView(category: categ)
                        .onTapGesture {
                            taskSelected.category = categ
                            
                            dismiss()
                        }
                }
            } header: {
                Text("Selecione a categoria")
            }
        }
    }
    
}

//#Preview {
//    AddCategoryToTaskView()
//}

