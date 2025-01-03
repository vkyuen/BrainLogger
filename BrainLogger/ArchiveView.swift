import SwiftUI
import SwiftData

struct ArchiveView: View {
    @Query(sort: \Todo.name) var todos: [Todo] // Want all todo in file, sorted by name
    @Environment(\.modelContext) var modelContext
    @State private var path = [Todo]()
    @State var search: String = ""
    
    var body: some View {
        NavigationStack(path: $path){
            TextField("What's on your mind?", text: $search)
                .onSubmit {
                    search = search
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

