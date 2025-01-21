import SwiftUI

struct TaskView: View {
        
    let task: Task
    
    init(_ task: Task) {
        self.task = task
    }
    
    var body: some View {
        
        HStack {
            //alignment: usado para pôr as coisas alinhadas à esquerda.
            VStack(alignment: .leading) {
                HStack(alignment: .center){
                    Text(task.title)
                        //Usando o .formatted na opção padrão. Deve-se SEMPRE formatar a data para usar ela no texto.
                        //Usando o .secondary para usar a cor secundária.
                    if task.category.name != "Sem Categoria"{
                        Text(task.category.name)
                            .foregroundStyle(task.category.colorComponent.color)
                            .font(.system(size: 15))
                    }
                }
                
                Text(task.date.formatted())
                    .foregroundStyle(.secondary)
            }
            //Usando o Spacer para extender até o final da página, se estende até ocupar o espaço entre os elementos do HStack.
            Spacer()
            //Se Task está feita, exiba o primeiro (checkmark.square.fill), senão, exiba o segundo(square).
            
            Button{
                //1a parte: Ação!
                //Só podemos alterar isso porque ela é uma classe (a task).
                task.isDone.toggle()
                //O toggle() é usado para inverter o booleano.
            } label: {
                //2a parte:Componentes do botão.
                Image(systemName: task.isDone ? "checkmark.square.fill" : "square")
            }
        }
    }
    
}
