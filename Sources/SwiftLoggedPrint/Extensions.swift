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

public extension Date{
    ///Returns `String` values for Year, Month, Day, Hour, Minute, Second and Nanosecond for the current `Date` instance using the Georgian calendar
    func getTimeStrings() -> [Calendar.Component: String]{
        let now = self
        let calendar = Calendar.init(identifier: .gregorian)
        
        var timeItems: [Calendar.Component: String]  = [
            .year:  "\(calendar.component(.year, from: now))",    //0 YEAR
            .month: "\(calendar.component(.month, from: now))",   //1 MONTH
            .day:   "\(calendar.component(.day, from: now))",     //2 DAY
            .hour:  "\(calendar.component(.hour, from: now))",    //3 HOUR
            .minute:"\(calendar.component(.minute, from: now))",  //4 MINUTE
            .second:"\(calendar.component(.second, from: now))",  //5 SECOND
            .nanosecond: "\(calendar.component(.nanosecond, from: now))" //6 NANOSECOND
        ]
        
        for i in timeItems{
            if i.value.count == 1{
                timeItems[i.key] = "0" + i.value
            }
        }
        
        return timeItems
    }
    
    ///Returns a `String` containing the hour of the current `Date` instance using the Georgian calendar
    func getHourString(includingSeconds: Bool = false) -> String{
        let timeItems = getTimeStrings()
    
        return "\(timeItems[.hour]!):\(timeItems[.minute]!)" + (includingSeconds ? ":\(timeItems[.second]!)" : "")
    }
    
    ///Returns a string with the date of the current `Date` instance using the Georgian calendae
    func getDateString() -> String{
        let timeItems = getTimeStrings()
    
        return "\(timeItems[.month]!)/\(timeItems[.day]!)/\(timeItems[.year]!)"
    }
    
    ///Returns a `String` representing the date and hour of the current `Date` instance using the Georgian calendar
    func getTimeString(includingSeconds: Bool = false) -> String{
        return getDateString() + " " + getHourString(includingSeconds: includingSeconds)
    }
    
}

public extension Encodable{
    func json(prettyPrinted: Bool = false) -> String?{
        let encoder = JSONEncoder()
        
        if prettyPrinted{
            encoder.outputFormatting = .prettyPrinted
        }
        
        var str: String?
        
        do{
            str = try String(data: encoder.encode(self), encoding: .utf8)
        }catch{
            return nil
        }
        
        return str
    }
    
    func plist() -> String?{
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        var str: String?
        
        do{
            str = try String(data: encoder.encode(self), encoding: .utf8)
        }catch{
            return nil
        }
        
        return str
    }
}

public extension Decodable{
    init?(fromJSONSerialisedString json: String){
        let decoder = JSONDecoder()
        
        guard let data = json.data(using: .utf8) else { return nil }
        
        do{
            self = try decoder.decode(Self.self, from: data)
        }catch{
            return nil
        }
    }
    
    init?(fromPlistSerialisedString plist: String){
        let decoder = PropertyListDecoder()
        
        guard let data = plist.data(using: .utf8) else { return nil }
        
        do{
            self = try decoder.decode(Self.self, from: data)
        }catch{
            return nil
        }
    }
}

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
                line += "\(prefix) \(l)\n"
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
        
        for i in start...finish{
            if !readLoggedLinesFromAllPrinters{
                if storage.logs[i].printerID != printerID{
                    continue
                }
            }
            
            if !readLoggedDebugLines{
                if storage.logs[i].isDebug{
                    continue
                }
            }
            
            ret += storage.logs[i].line + "\n"
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
