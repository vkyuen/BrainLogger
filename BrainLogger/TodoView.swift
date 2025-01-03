import SwiftUI
import SwiftData

struct TodoView: View {
    @Query(filter: #Predicate<Todo>{todo in todo.status < 3}, sort:\Todo.status)var todos: [Todo] // return todo that are not archived
    @Environment(\.modelContext) var modelContext
    @State private var path = [Todo]()
    @State var newName: String = ""
    
    var body: some View {
        NavigationStack(path: $path){
            TextField("What's on your mind?", text: $newName)
                .onSubmit {
                    let name = newName
                    newName = ""
                    addTodo(name: name)
                }
            .padding()
            List{
                ForEach(todos){ todo in
                    NavigationLink(value: todo){
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: todo.displayIcon())
                                    .imageScale(.large)
                                    .foregroundStyle(.tint)
                                    .onTapGesture {
                                        todo.updateStatus()
                                    }
                                Text(todo.name)
                                    .font(.headline)
                                if todo.status == 1{
                                    // in progress, need to display timer
                                    Spacer()
                                    Image(systemName: todo.displayTimer())
                                        .imageScale(.large)
                                        .onTapGesture{
                                            todo.toggleTimer()
                                        }
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteTodos)
            }
            .navigationDestination(for: Todo.self){ todo in
                DetailTodoView(todo: todo)
            }
        }
    }
    
    func deleteTodos(_ indexSet: IndexSet){
        for index in indexSet{
            let todo = todos[index]
            modelContext.delete(todo)
        }
    }
    
    func addTodo(name: String){
        let todo = Todo(name: name)
        modelContext.insert(todo)
        path = [todo]
    }
}

#Preview {
    TodoView()
}
