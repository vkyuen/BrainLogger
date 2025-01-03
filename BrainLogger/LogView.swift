import SwiftUI

struct LogView: View {
    
    @FileState("timeLog")
    var content: String
    
    var body: some View {
        VStack {
            Text("Timeline:")
                .font(.title)
            Text(readFromFile())
                .padding()
        }
        
        .padding()
    }
    
    func writeToFile(text: String){
        let url = URL.documentsDirectory.appending(path: "timeLog.txt")
        
        do{
            let readContents = try String(contentsOf: url, encoding: .utf8)
            print("read contents: \(readContents)")
            
            let writeContents = readContents + text
            let data = Data(writeContents.utf8)
            try data.write(to: url, options: [.atomic])
        }catch{
            print("error in reading or writing file")
        }
    }
    
    func readFromFile()->String{
        let url = URL.documentsDirectory.appending(path: "timeLog.txt")
        
        do{
            let readContents = try String(contentsOf: url, encoding: .utf8)
            print("read contents: \(readContents)")
            return readContents
        }catch{
            return "error in reading or writing file"
        }
    }
}
