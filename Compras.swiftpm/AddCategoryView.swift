////
//  SwiftUIView.swift
//  TaskList
//
//  Created by found on 03/12/24.
//

import SwiftUI
import _SwiftData_SwiftUI

struct AddCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State var title = ""
    
    //É @Binding porque você está trazendo uma informação de uma tela e levando-a para outra tela.
    @Binding var isShowing: Bool
    
    @State var category_name: String = ""
    
    @State var category_color: Color = Color.secondary
    
    @State var isShowingAlertToDeleteCategory: Bool = false
    
    @Query var categories : [Category]
    
    @Query var tasks: [Task]
    
    var body: some View {
        List{
            //Seção das Categorias
            Section{
                HStack{
                    TextField("Categoria ", text: $category_name)
                    
                    ColorPicker(selection: $category_color, label: {
                        Text("")
                    })
                    Button{
                        let category = Category(name: category_name, color:category_color)
                        print(category)
                        if category_name != ""{
                            modelContext.insert(category)
                        }
                        category_name = ""
                        dismiss()
                        
                    } label: {
                        Text("SALVAR")
                    }
                }
            }header: {
                HStack{
                    Text("Criar Nova Categoria")
                }
            }
            
            Section{
                ForEach(categories){ categ in
                    CategoryView(category: categ).swipeActions(edge: .trailing, allowsFullSwipe: false){
                            Button(role: .destructive){
                                if !tasks.contains(where: {$0.category == categ}){
                                    modelContext.delete(categ)
                                }else{
                                    isShowingAlertToDeleteCategory = true
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                    }
                }
                .alert(isPresented: $isShowingAlertToDeleteCategory){
                    Alert(title: Text("Falha ao deletar categoria"), message: Text("Não foi possível deletar esta categoria, visto que há um produto associada a ela."), dismissButton: .default(Text("Ok")))
                }
            }
            header: {
                HStack{
                    Text("Categorias")
                }
            } footer: {
                HStack{
                    Text("Total de Categorias: \(categories.count)")
                }
            }
        }
    }
}

#Preview {
    //Nesse caso, você está esclarecendo que a variável que está chamada lá de isShowing
    AddCategoryView(isShowing: .constant(true))
}
