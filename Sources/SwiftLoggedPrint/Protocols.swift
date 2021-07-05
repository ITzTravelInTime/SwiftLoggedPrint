//
//  File.swift
//  
//
//  Created by Pietro Caruso on 05/07/21.
//

import Foundation

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
}
