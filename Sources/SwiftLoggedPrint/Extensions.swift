/*
 SwiftLoggedPrint: A library for logging and keeping track of prints and debug prints.
 Copyright (C) 2021-2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import SwiftPackagesBase

public extension LoggedPrinterProtocol{
    
    ///Prints somethings to the console and the log (if enabled) ether as normal log messanges or debug log messanges
    static func print( _ str: String, isDebug: Bool = false){
        if !enabled{
            return
        }
        
        let now: Date? = displayPrintTime ? Date() : nil
        
        let prefix = (displayPrintTime ? "[\(now!.getTimeString())] " : "") + "\(self.prefix)" + (isDebug ? " \(debugPrefix)" : "")
        
        var line = ""
        
        if putPrefixOnAllLines{
            for l in str.split(separator: "\n"){
                for ll in l.split(separator: "\r"){
                    line += "\(prefix) \(ll)\n"
                }
            }
            
            if line.last == "\n"{
                line.removeLast()
            }
        }else{
            line = "\(prefix) \(str)"
        }
        
        if (printDebugLines && isDebug) || !isDebug{
            Swift.print(line)
        }
        
        if allowsLogging && (!isDebug || (isDebug && logsDebugLines)) {
            storage.unreadedLogLines += 1
            storage.logs.append(LoggedLine(line: showPrefixesIntoLoggedLines ? line : str, isDebug: isDebug, printerID: printerID, printTime: trackPrintTime ? now : nil))
        }
    }
    
    ///Prints a messange and marks it as debug
    static func debug( _ str: String){
        print(str, isDebug: true)
    }
    
    ///Returns the ammount of logged lines stored
    static var numberOfLoggedLines: Int{
        return storage.logs.count
    }
    
    ///Returns an interval of logged lines as a single string, if the input parameters are not valid or the number of logged lines is 0 this functon returns `nil`
    static func readLogInterval(from start: Int, to finish: Int) -> String?{
        if start < 0 || finish >= storage.logs.count || start > finish{
            return nil
        }
        
        var ret = ""
        var line: LoggedLine = .init(line: "", isDebug: false, printerID: "", printTime: nil) //initialized as non-nil to avoid crashes.
        
        for i in start...finish{
            
            //redundant check to make sure this doesn't happen while the log changes.
            if i >= storage.logs.count{
                return ret.isEmpty ? nil : ret
            }
            
            line = storage.logs[i]
            
            if !readLoggedLinesFromAllPrinters && line.printerID != printerID{
                continue
            }
            
            if !readLoggedDebugLines && line.isDebug{
                continue
            }
            
            ret += line.line + "\n"
        }
        
        return ret
    }
    
    ///Returns all the logged prints as one string if the number of logged lines is 0 it will return `nil`
    static func readAllLog() -> String?{
        
        if willHaveZeroLogLinesUnreadedAfterReadAllLogIsUsed{
            storage.unreadedLogLines = 0
        }
        
        return readLogInterval(from: 0, to: storage.logs.count - 1)
    }
    
    ///Gets the stored print log `as is`
    ///
    ///This is usefoul to get a copy of the log that can be serialized and sent over to a remote server for instance
    static func getCompleteLog() -> [LoggedLine]{
        return storage.logs
    }
    
    ///Returns only the unreaded log lines as a single string
    static func readUndreadedLog() -> String?{
        let count = storage.logs.count
        
        storage.unreadedLogLines = 0
        return readLogInterval(from: count - storage.unreadedLogLines, to: count - 1)
    }
    
    ///Emptyes the list of logged prints
    static func clearLog(){
        
        storage.logs.removeAll()
        storage.logs = []
        
        storage.unreadedLogLines = 0
    }
    
}
