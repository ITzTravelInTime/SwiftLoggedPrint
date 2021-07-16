//
//  File.swift
//  
//
//  Created by Pietro Caruso on 05/07/21.
//

import Foundation

public protocol LoggedPrintStorage{
    ///The archived logged prints
    var logs: [LoggedLine] { get set }
    ///The unreaded logged prints
    var unreadedLogLines: Int { get set }
}

public protocol LoggedPrinterProtocol {

    ///The prefix to be used on printed messanges
    static var prefix: String { get }
    
    ///The additional prefix to be used for debug prints
    static var debugPrefix: String { get }
    
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
    
    ///Sets if prefixes should be visible into the logged messanges
    static var showPrefixesIntoLoggedLines: Bool { get }
    
    ///The identifier string for the printer class so logs can be better organised depending on who sent a log messange
    static var printerID: String { get }
    
    ///Sets if logs from the read functions should print logs for all printers or just this one
    static var readLoggedLinesFromAllPrinters: Bool { get }
    
    ///Sets if the prefix should be present at each new line of the printented messanges or just at the beginning of each messange
    static var putPrefixOnAllLines: Bool { get }
    
    ///Sets if the logged prints should keep track of the time they were sent
    static var trackPrintTime: Bool { get }
    
    ///Sets if the time in which a print has been done should be displayed when reading the stored log and printing
    static var displayPrintTime: Bool { get }
    
    ///This is the storage for the logged print lines
    static var storage: LoggedPrintStorage { get set }
}


