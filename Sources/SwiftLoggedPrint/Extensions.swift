//
//  File.swift
//  
//
//  Created by Pietro Caruso on 05/07/21.
//

import Foundation

internal extension Bundle {
    ///Returns the name of the current bundle
    var name: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
}

fileprivate struct LogMemory{
    //this code manages the print logging system
    static var logs = [LoggedLine]()
    static var unreadedLogLines: Int = 0
}

public extension LoggedPrinterProtocol{
    
    ///Prints somethings to the console and the log (if enabled) ether as normal log messanges or debug log messanges
    static func print( _ str: String, isDebug: Bool = false){
        if enabled{
            let line = "\(prefix)\(!isDebug ? "" : " \(debugPrefix)") \(str)"
            if (printDebugLines && isDebug) || !isDebug{
                Swift.print(line)
            }
            if allowsLogging && (!isDebug || (isDebug && logsDebugLines)) {
                LogMemory.unreadedLogLines += 1
                LogMemory.logs.append(LoggedLine(line: showPrefixesIntoLoggedLines ? line : str, isDebug: isDebug, id: printerID))
            }
        }
    }
    
    ///Prints a messange and marks it as debug
    static func debug( _ str: String){
        print(str, isDebug: true)
    }
    
    ///Returns the ammount of logged lines stored
    static var numberOfLoggedLines: Int{
        return LogMemory.logs.count
    }
    
    ///Returns an interval of logged lines as a single string, if the input parameters are not valid or the number of logged lines is 0 this functon returns `nil`
    static func readLogInterval(from start: Int, to finish: Int) -> String?{
        if start < 0 || finish >= LogMemory.logs.count || start > finish{
            return nil
        }
        
        var ret = ""
        
        for i in start...finish{
            if !readLoggedLinesFromAllPrinters{
                if LogMemory.logs[i].id != printerID{
                    continue
                }
            }
            
            if !readLoggedDebugLines{
                if LogMemory.logs[i].isDebug{
                    continue
                }
            }
            
            ret += LogMemory.logs[i].line + "\n"
        }
        
        return ret
    }
    
    ///Returns all the logged prints as one string if the number of logged lines is 0 it will return `nil`
    static func readAllLog() -> String?{
        
        if willHaveZeroLogLinesUnreadedAfterReadAllLogIsUsed{
            LogMemory.unreadedLogLines = 0
        }
        
        return readLogInterval(from: 0, to: LogMemory.logs.count - 1)
    }
    
    ///Gets the stored print log `as is`
    ///
    ///This is usefoul to get a copy of the log that can be serialized and sent over to a remote server for instance
    static func getCompleteLog() -> [LoggedLine]{
        return LogMemory.logs
    }
    
    ///Returns only the unreaded log lines as a single string
    static func readUndreadedLog() -> String?{
        let count = LogMemory.logs.count
        
        LogMemory.unreadedLogLines = 0
        return readLogInterval(from: count - LogMemory.unreadedLogLines, to: count - 1)
    }
    
    ///Emptyes the list of logged prints
    static func clearLog(){
        
        LogMemory.logs.removeAll()
        LogMemory.logs = []
        
        LogMemory.unreadedLogLines = 0
    }
    
}
