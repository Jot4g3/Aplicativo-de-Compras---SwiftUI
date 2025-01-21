//
//  AddCategoryToTaskView.swift
//  TaskList
//
//  Created by found on 10/12/24.
//

import SwiftUI
import SwiftData

struct AddCategoryToNewTaskView : View{
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query var categories : [Category]
    
    @Binding var isShowing : Bool
    //@Binding var isShowingSheetAnterior : Bool
    
    @Binding var title: String
    var date: Date
    
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
                            let task = Task(title: title, date: date)
                            
                            task.category = categ
                            
                            modelContext.insert(task)
                            
                            title = ""
                            isShowing = false
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

