import Foundation
import SwiftLoggedPrint

//The usage of a subclass is recommended sice it allows for a shorter name in the code and to customize the prefix
class Log: LoggedPrinter{
    override class var prefix: String{
        return "[My App]"
    }
    
    override class var debugPrefix: String{
        return "[Debug]"
    }
}

for i in 0...1{
    
Log.displayPrintTime = i == 1 //The first time the log should display without the date, the second time with the date
Log.trackPrintTime = i == 1 //The first time the log will not keep track of the time, the second time it will
    
Log.debug("This should print and be visible in the log")
Log.print("Hello this is my app!") //this will print and show up in the log

Log.allowsLogging = false

Log.debug("This should print and not be visible in the log")
Log.print("Hello this is my app!") //This will print and not show up in the log

Log.enabled = false

Log.print("This should not print and not be visible in the log")

Log.enabled = true
Log.allowsLogging = true
    
}

Log.readLoggedDebugLines = false

print(" ----- Here is the log so far [excluding debug lines]: \n\n\(Log.readAllLog() ?? "")")

Log.readLoggedDebugLines = true

print(" ---- Here is the log so far [with debug lines]: \n\n\(Log.readAllLog() ?? "")")

print(" ---- Here is the RAW log so far: \n\n\(Log.getCompleteLog().json(prettyPrinted: true) ?? "")")


//Test
Log.putPrefixOnAllLines = true
Log.print(" Test:\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \r \r \r \n \r \n \n \n \n Test")
