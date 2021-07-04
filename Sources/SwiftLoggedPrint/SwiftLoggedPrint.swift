//
//  SwiftLoggedPrint.swift
//
//
//  Created by Pietro Caruso on 04/07/21.
//

import Foundation

open class LoggedPrinter {
    
    ///Struct used to represent logged print lines
    public struct LogLine: Equatable, Codable{
        let line: String
        let isDebug: Bool
    }
    
    ///Sets if printing is enabled or not
    public static var enabled: Bool = true
    
    ///Sets if logging of the prints should be enabled
    public static var allowsLogging: Bool = true
    
    ///Sets if the number of unreaded log lines should be set to 0 when all the log is readed
    public static var willHaveZeroLogLinesUnreadedAfterReadAllLogIsUsed: Bool = false
    
    ///Sets if the debug log lines should be included into the log reads or not
    public static var readLoggedDebugLines: Bool = false
    
    ///Sets if debug prints should be printed or not
    public static var printDebugLines: Bool = true
    
    ///Sets if debug prints should be memorised into the log
    public static var logsDebugLines: Bool = true
    
    ///The prefix to be used on printed messanges
    open class var prefix: String{
        return ""
    }
    
    ///The additional prefix to be used for debug prints
    open class var debugPrefix: String{
        return "[Debug]"
    }
    
    ///Prints somethings to the console and the log (if enabled) ether as normal log messanges or debug log messanges
    open class func print( _ str: String, isDebug: Bool = false){
        if enabled{
            let line = "\(prefix)\(debugPrefix.isEmpty ? "" : " \(debugPrefix)") \(str)"
            if (printDebugLines && isDebug) || !isDebug{
                print(line)
            }
            if allowsLogging && (!isDebug || (isDebug && logsDebugLines)) {
                unreadedLogLines += 1
                logs.append(LogLine(line: line, isDebug: false))
            }
        }
    }
    
    open class func debug( _ str: String){
        print(str, isDebug: true)
    }
    
    //this code manages the print logging system
    private static var logs = [LogLine]()
    private static var unreadedLogLines: Int = 0
    
    public class var numberOfLoggedLines: Int{
        return logs.count
    }
    
    ///Returns an interval of logged lines as a single string, if the input parameters are not valid or the number of logged lines is 0 this functon returns `nil`
    open class func readLogInterval(from start: Int, to finish: Int) -> String?{
        if start < 0 || finish >= logs.count || start > finish{
            return nil
        }
        
        var ret = ""
        
        for i in start...finish{
            if !readLoggedDebugLines && logs[i].isDebug{
                continue
            }
            
            ret += logs[i].line + "\n"
        }
        
        if willHaveZeroLogLinesUnreadedAfterReadAllLogIsUsed{
            unreadedLogLines = 0
        }
        
        return ret
    }
    
    ///Returns all the logged prints as one string if the number of logged lines is 0 it will return `nil`
    public class func readAllLog() -> String?{
        return readLogInterval(from: 0, to: logs.count - 1)
    }
    
    ///Gets the stored print log `as is`
    ///
    ///This is usefoul to get a copy of the log that can be serialized and sent over to a remote server for instance
    public class func getCompleteLog() -> [LogLine]{
        return logs
    }
    
    ///Returns only the unreaded log lines as a single string
    open class func readUndreadedLog() -> String?{
        let count = logs.count
        
        unreadedLogLines = 0
        return readLogInterval(from: count - unreadedLogLines, to: count - 1)
    }
    
    ///Emptyes the list of logged prints
    open class func clearLog(){
        
        logs.removeAll()
        logs = []
        
        unreadedLogLines = 0
    }
    
}
