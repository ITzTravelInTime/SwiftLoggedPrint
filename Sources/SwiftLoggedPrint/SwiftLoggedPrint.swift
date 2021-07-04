//
//  SwiftLoggedPrint.swift
//
//
//  Created by Pietro Caruso on 04/07/21.
//

import Foundation



public protocol LoggedPrinterProtocol {
    ///Sets if printing is enabled or not
    static var enabled: Bool { get }
    
    ///Sets if logging of the prints should be enabled
    static var allowsLogging: Bool { get }
    
    ///Sets if the number of unreaded log lines should be set to 0 when all the log is readed
    static var willHaveZeroLogLinesUnreadedAfterReadAllLogIsUsed: Bool { get }
    
    ///Sets if the debug log lines should be included into the log reads or not
    static var readLoggedDebugLines: Bool { get }
    
    ///Sets if debug prints should be printed or not
    static var printDebugLines: Bool { get }
    
    ///Sets if debug prints should be memorised into the log
    static var logsDebugLines: Bool { get }
}

///Struct used to represent logged print lines
public struct LoggedLine: Equatable, Codable{
    public let line: String
    public let isDebug: Bool
}

fileprivate struct LogMemory{
    //this code manages the print logging system
    static var logs = [LoggedLine]()
    static var unreadedLogLines: Int = 0
}

//open class LoggedPrinter {

public extension LoggedPrinterProtocol{
    
    ///The prefix to be used on printed messanges
    static var prefix: String{
        return ""
    }
    
    ///The additional prefix to be used for debug prints
    static var debugPrefix: String{
        return "[Debug]"
    }
    
    ///Prints somethings to the console and the log (if enabled) ether as normal log messanges or debug log messanges
    static func print( _ str: String, isDebug: Bool = false){
        if enabled{
            let line = "\(prefix)\(debugPrefix.isEmpty ? "" : " \(debugPrefix)") \(str)"
            if (printDebugLines && isDebug) || !isDebug{
                print(line)
            }
            if allowsLogging && (!isDebug || (isDebug && logsDebugLines)) {
                LogMemory.unreadedLogLines += 1
                LogMemory.logs.append(LoggedLine(line: line, isDebug: false))
            }
        }
    }
    
    static func debug( _ str: String){
        print(str, isDebug: true)
    }
    
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
            if !readLoggedDebugLines && LogMemory.logs[i].isDebug{
                continue
            }
            
            ret += LogMemory.logs[i].line + "\n"
        }
        
        if willHaveZeroLogLinesUnreadedAfterReadAllLogIsUsed{
            LogMemory.unreadedLogLines = 0
        }
        
        return ret
    }
    
    ///Returns all the logged prints as one string if the number of logged lines is 0 it will return `nil`
    static func readAllLog() -> String?{
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

open class LoggedPrinter: LoggedPrinterProtocol{
    
    public typealias LogLine = LoggedLine
    
    public static var enabled: Bool = true
    
    public static var allowsLogging: Bool = true
    
    public static var willHaveZeroLogLinesUnreadedAfterReadAllLogIsUsed: Bool = false
    
    public static var readLoggedDebugLines: Bool = false
    
    public static var printDebugLines: Bool = true
    
    public static var logsDebugLines: Bool = true
    
}
