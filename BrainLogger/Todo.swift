import Foundation
import SwiftData

@Model
class Todo{
    // var id = UUID()
    var name: String
    var status: Int
    var dateCreated: Date
    var dateCompleted: Date?
    var priority: Int
    var isTodo = true
    var isTimerActive = false
    var timerStart: Date?
    var elapsedTime: Double
    var notes = ""
    var log = ""
    
    init(name: String, status: Int, dateCreated: Date, priority: Int) {
        self.name = name
        self.status = status
        self.dateCreated = Date.now
        self.priority = priority
        self.elapsedTime = 0.0
        self.log = name + " created at \(formatedDate(date: dateCreated))\n"
    }
    init(name: String) {
        self.name = name
        self.status = 0
        self.dateCreated = Date.now
        self.priority = 0
        self.elapsedTime = 0.0
        self.log = "\(formatedDate(date: dateCreated)): created \(name)\n"
    }
    
    func formatedDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    func displayIcon() -> String{
        switch status{
        case 0: return "circle"
        case 1: return "slash.circle"
        case 2: return "checkmark.circle"
        case 3: return "minus.circle"
        default: return "circle"
        }
    }
    func updateStatus(){
        var addText = logIntro()
        switch status{
        case 0:  // listed
            self.status = 1
            addText += "Status changed to In Progress\n"
        case 1: // in progress
            self.status = 2
            self.timerStart = Date.now
            addText += "Status changed to Done\n"
        case 2: // done
            self.status = 3
            self.dateCompleted = Date.now
            if isTimerActive{
                toggleTimer()
            }
            addText += "Status changed to Archived\n"
        case 3: // archive
            print("Already archived")
        default:
            print("error")
        }
        log += addText
        writeToFile(text: addText)
    }
    func displayTimer() -> String{
        // if timer isn't active, it should show a play button
        return isTimerActive ? "stop.circle" : "play.circle"
    }
    func toggleTimer(){
        var addText = logIntro()
        if isTimerActive{
            // timer is active, need to stop the timer, and update elapsed time
            // print elapsed time to cosle to debug.
            let current = Date.now
            let timeDifference = current.timeIntervalSince(self.timerStart ?? self.dateCreated)
            // print("elapsedTime: \(timeDifference)")
            self.isTimerActive = false
            self.elapsedTime = (elapsedTime) + timeDifference
            addText += "stopped timer. Added \(timeString(time: timeDifference)) \n"
            
        }else{
            // time is not active, need to set start timer date and isTimerActive
            self.timerStart = Date.now
            self.isTimerActive = true
            addText += "started timer.\n"
        }
        
        log += addText
        writeToFile(text: addText)
    }
    func timeString(time: Double) -> String{
        // elapsed time is in seoconds, so need to calculate number of hours, minute, and seconds that is covered by the elapsed time. Second is rounded up.
        var workingTime = time
        var hour: Int = 0
        var minute: Int = 0
        var second: Int = 0
        
        // print("in seconds:")
        // print(workingTime)
        if workingTime >= 3600{
            hour = Int(workingTime / 3600)
            workingTime = workingTime - Double((hour * 3600))
        }
        if workingTime >= 60{
            minute = Int(workingTime / 60)
            workingTime = workingTime - Double((minute * 60))
        }
        second = Int(workingTime.rounded(.up))
        
        let stringTime = "\(hour)h \(minute)m \(second)s"
        return stringTime
    }
    func logIntro() -> String{
        return "\n ****** \n - \(formatedDate(date: Date.now)) - \(name): "
        
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
    func pickerChange(){
        var addText = logIntro()
        switch status{
        case 0:  // listed
            addText += "Status changed to Todo.\n"
        case 1: // in progress
            self.timerStart = Date.now
            addText += "Status changed to In Progress\n"
        case 2: // done
            self.dateCompleted = Date.now
            if isTimerActive{
                toggleTimer()
            }
            addText += "Status changed to Done\n"
        case 3: // archive
            addText += "Status changed to Archived\n"
        default:
            print("error")
        }
        log += addText
        writeToFile(text: addText)
    }
}
