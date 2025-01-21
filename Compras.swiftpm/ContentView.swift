import SwiftUI
import SwiftData

struct ContentView: View {
    
    //Quando você quer alterar algo dentro da View, você usa o @State.
    
    @State var title = ""
    
    @State var category_name: String = ""
    
    @State var category_color: Color = Color.secondary
    
    @State var isShowingSheetTask: Bool = false
    @State var isShowingSheetCategory: Bool = false
    @State var isShowingSheetCategoryToTask: Bool = false
    
    let strAll : String = "Todos"
    
    @State var categoryActive: Category = Category(name: "Todos", color: .secondary)

    
    @Environment(\.modelContext) var modelContext
    
    @Query var tasks: [Task]
    
    //Mudando o taskDoneCount, que está fora do escopo da função.
    func countTasksDone (tasks: [Task]) ->(dones: Int, notDones: Int) {
        var taskDoneCount: Int = 0
        var taskNotDoneCount: Int = 0
        taskDoneCount = tasks.filter { task in task.isDone }.count
        taskNotDoneCount = tasks.count - taskDoneCount
        return (dones: taskDoneCount, notDones: taskNotDoneCount)
    }
    
    @Query var categories : [Category]
    
    var tasksFiltered : [Task] {
        tasks.filter { $0.category.name == categoryActive.name}
    }
    
    @State var taskSelected : Task = Task(title:"", date:.now)
    
//    @State var tasksFilter = tasks.filter ({
//        return $0.category.id == categorySelected.id
//    })
    
    @State var isBtnVsbl : Bool = true
    
    @State private var isDarkMode = false
    
    //Mudar os nomes das categorias.
    let categorias: [Category] = [
        Category(name: "Sem Categoria", color: .accentColor),
        Category(name: "Alimentação", color: .yellow),
        Category(name: "Automotivo", color: .brown),
        Category(name: "Eletrônicos", color: .indigo),
        Category(name: "Higiene Pessoal", color: .gray),
        Category(name: "Lazer e Entretenimento", color: .orange),
        Category(name: "Limpeza", color: .mint),
        Category(name: "Medicações", color: .purple),
        Category(name: "Animais de Estimação", color: .pink),
        Category(name: "Roupas e Acessórios", color: .red),
        Category(name: "Utilidades Domésticas", color: .green)
    
        ]
    
    var body: some View {
        Text("Lista de Compras")
            .foregroundColor(.accentColor)
            .font(.largeTitle)
            .fontWeight(.bold)
        if categories.isEmpty{
            if isBtnVsbl{
                Button{
                    for categoria in categorias{
                        modelContext.insert(categoria)
                        isBtnVsbl = false
                    }
                } label: {
                    Text("Adicionar as Categorias-Padrão       ").foregroundColor(.accentColor)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.white)
                .background(.quaternary)
                .cornerRadius(5)

            }
        }
     
        
        List{
            //Usando o cifrão($) para conetar com uma variável State!
                Toggle("Modo escuro", isOn: $isDarkMode)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            
            Section{
            } header: {
                HStack{
                    Text("Criar nova compra")
                    Button{
                        isShowingSheetTask = true
                    }label: {
                        Spacer()
                        Image(systemName: "plus")
                    }
                }
            }
            
            Section{
            }header: {
                HStack{
                    Text("Gerenciar Categorias")
                    Button{
                        isShowingSheetCategory = true
                    }label: {
                        Spacer()
                        Image(systemName: "plus")
                    }
                }
            }
            
            Section {
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        Button{
                            categoryActive = Category(name: strAll, color: .accentColor)
                        } label: {
                            Text(strAll)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(strAll == categoryActive.name ? Color.accentColor : .gray)
                        
                        Button{
                            //categorias[0] é o "Sem Categoria"
                            categoryActive = categorias[0]
                        } label: {
                            Text(categorias[0].name)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(categorias[0].name == categoryActive.name ? Color.accentColor : .gray)
                        
                        ForEach(categories){ categ in
                            if categ.name != "Sem Categoria"{
                                Button {
                                    categoryActive = categ
                                }label:{
                                    Text(categ.name)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(categ.name == categoryActive.name ? Color.accentColor : .gray)                        }
                        }
                    }
                }
            }  header: {
                    Text("Categorias")
            }
            
            Section{
                ForEach(categoryActive.name == strAll ? tasks : tasksFiltered){ task in
                        TaskView(task).swipeActions(edge: .trailing, allowsFullSwipe: false){
                            //Botão de delete.
                            Button(role: .destructive){
                                modelContext.delete(task)
                            } label: {
                                Image(systemName: "trash")
                            }
                            Button{
                                isShowingSheetCategoryToTask = true
                                taskSelected = task
                            } label: {
                                Image(systemName: "ellipsis")
                            }.tint(.blue)
                            //Botão de adicionar categoria.
                        }
                    }
            }
            header: {
                HStack{
                    Text("Compras a fazer: \(countTasksDone(tasks: tasks).notDones)")
                    Spacer()
                    Text("Lista de Compras")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                    Spacer()
                    Text("Compras feitas:\(countTasksDone(tasks: tasks).dones)")
                }
            }
        }
        
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .animation(.interpolatingSpring(stiffness: 20, damping: 5), value: isDarkMode)
        
        .sheet(isPresented: $isShowingSheetTask){
            AddTaskView(isShowing: $isShowingSheetTask)
        }
        .sheet(isPresented: $isShowingSheetCategory){
            AddCategoryView(isShowing: $isShowingSheetCategory)
        }
        .sheet(isPresented: $isShowingSheetCategoryToTask){
            AddCategoryToTaskView(taskSelected: $taskSelected)
        }
    }
}

//Variável Binding pressedTaskToCategory significa a task que você estava apertando quando abriu a aba de AddCategoryToTaskView.
//A sheet addCategoryToTaskView foi feita para que voce possa adicionar uma categoria a uma task
//Foram feitas alteracoes na taskview para mostrar a categoria dela.
