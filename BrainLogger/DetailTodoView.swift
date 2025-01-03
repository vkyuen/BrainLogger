import SwiftUI
import SwiftData

struct DetailTodoView: View {
    @Bindable var todo: Todo
    
    var body: some View {
        Form{
            TextField("Name", text: $todo.name)
            Text("Date created: \(todo.formatedDate(date: todo.dateCreated))")
            Toggle("Is this a todo?", isOn: $todo.isTodo.animation())
            if todo.isTodo{
                Section("Status"){
                    Picker("Status", selection: $todo.status){
                        Text("Todo").tag(0)
                        Text("In-Progress").tag(1)
                        Text("Done").tag(2)
                        Text("Archive").tag(3)
                    }
                    .onChange(of: todo.status){
                        todo.pickerChange()
                    }
                    // Toggle("Is timer active?", isOn: $todo.isTimerActive.animation())
                    HStack{
                        Text("Elapsed time:")
                        Spacer()
                        Text(todo.timeString(time: todo.elapsedTime))
                    }
                }
                Section("Priority"){
                    Picker("Priority", selection: $todo.priority){
                        Text("Not Set").tag(0)
                        Text("Low").tag(1)
                        Text("Medium").tag(2)
                        Text("High").tag(3)
                    }
                    .pickerStyle(.segmented)
                }
                Section("Notes"){
                    TextField("Notes", text: $todo.notes)
                }
                Section("Log"){
                    Text(todo.log)
                }
            }
            
        }
        .navigationTitle("Edit Todo")
        .navigationBarTitleDisplayMode(.inline)
    }
}
