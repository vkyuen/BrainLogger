import SwiftUI

@propertyWrapper
struct FileState: DynamicProperty {
    var wrappedValue: String {
        get {
            return contents
        }
        nonmutating set {
            try? newValue.write(to: fileUrl, atomically: true, encoding: .utf8)
            contents = newValue
        }
    }
    
    let fileUrl: URL
    
    @State
    private var contents: String
    
    init(_ fileName: String) {
        let documentsUrl = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        fileUrl = documentsUrl.appendingPathComponent(fileName + ".txt")
        
        contents = (try? String(contentsOf: fileUrl,
                               encoding: .utf8)) ?? ""
        print(fileUrl)
    }
    
    var projectedValue: Binding<String> {
        Binding(
            get: { return wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}
