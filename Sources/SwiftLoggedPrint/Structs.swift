//
//  SwiftLoggedPrint.swift
//
//
//  Created by Pietro Caruso on 04/07/21.
//

import Foundation

///Struct used to represent logged print lines
public struct LoggedLine: Equatable, Codable{
    public let line: String
    public let isDebug: Bool
    public let printerID: String
    public let printTime: Date?
}

public struct DefaultLogMemory: LoggedPrintStorage{
    //this code manages the print logging system
    public var logs: [LoggedLine] = []
    public var unreadedLogLines: Int = 0
}

///Class used to provvide a default way of using the logged printer
open class LoggedPrinter: LoggedPrinterProtocol{
    
    
   
    
    public typealias LogLine = LoggedLine
    
    ///The prefix to be used on printed messanges
    open class var prefix: String{
        if let main = Bundle.main.name{
            return "[\(main)]"
        }
        return ""
    }
    
    ///The additional prefix to be used for debug prints
    open class var debugPrefix: String{
        return "[Debug]"
    }
    
    open class var printerID: String{
        return Bundle.main.bundleIdentifier ?? "SwiftLoggedPrintDefault"
    }
    
    public static var enabled: Bool = true
    
    public static var allowsLogging: Bool = true
    
    public static var willHaveZeroLogLinesUnreadedAfterReadAllLogIsUsed: Bool = false
    
    public static var readLoggedDebugLines: Bool = false
    
    public static var printDebugLines: Bool = true
    
    public static var logsDebugLines: Bool = true
    
    public static var showPrefixesIntoLoggedLines: Bool = true
    
    public static var readLoggedLinesFromAllPrinters: Bool = true
    
    public static var putPrefixOnAllLines: Bool = true
    
    public static var trackPrintTime: Bool = false
    
    public static var displayPrintTime: Bool = false
    
    public static var storage: LoggedPrintStorage = DefaultLogMemory()
    
}