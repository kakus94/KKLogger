//
//  LogManager.swift
//  Created by Kamil Karpiak on 07/11/2023.
//

import Foundation
import XCGLogger

// variable used to log in applikacjia during debugging
@available(iOS 16.0, *)
var log: XCGLogger = LogManager.share.getXCGLog(levelLog: .info)

@available(iOS 16.0, *)
public class LogManager { 
  
  static public let share = LogManager()
  
  public var config: Config = Config.defaultConfig
  
//  var sizeWhenDelateFile_KB: Double = 10_000.0
  
//  private let paths = FileManager.default
//    .urls(for: .documentDirectory, in: .userDomainMask)
//    .first!
//    .appendingPathComponent("message.txt")
  
  
  func size() -> Double? { 
    do { 
      let fileAttributes = try FileManager.default
        .attributesOfItem(atPath: config.paths.path())
      if let fileSize = fileAttributes[.size] as? Int64 {
        log.info("Log file size: \(fileSize) B")
        return Double( fileSize / 1_000 )
      }
    } catch { 
      print(error)
    }
    
    return nil    
  }
  
  func sizeString() -> String? { 
    guard let size = size() else { return "not find" }    
    return String(format: "%.0f", size)
  }  
  
  public func whetherDeleteFile() { 
    guard let size = size() else { return }//KB 
    if size > config.sizeWhenDelateFile_KB { 
      NotificationCenter.default.post(name: Notification.Name("AskDelateFile"), object: nil)
    }
  }
  
  public func delete() { 
    do {
      let fileManager = FileManager.default
      
      // Check if the file exists before attempting to delete it
      if fileManager.fileExists(atPath: config.paths.path) {        
        
        log.remove(destinationWithIdentifier: "fileDestination")
        try fileManager.removeItem(at: config.paths)
        log.add(destination: fileDestination())                
        
        log.info("File deleted successfully")
      } else {
        log.warning("File does not exist")
      }
    } catch {
      log.error("Error deleting the file: \(error)")
    }
  }
  
  private func fileDestination(_ levelLog: XCGLogger.Level = .info) -> FileDestination { 
    // Skonfiguruj miejsce docelowe pliku
    let fileDestination = FileDestination(writeToFile: config.paths, 
                                          identifier: "fileDestination", 
                                          shouldAppend: true, 
                                          appendMarker: "-- ** * START APP * ** --")
    
    fileDestination.outputLevel = levelLog // Ustaw poziom logowania według potrzeb
    fileDestination.showLogIdentifier = false
    fileDestination.showFunctionName = true
    fileDestination.showThreadName = false
    fileDestination.showLevel = true
    fileDestination.showFileName = true
    fileDestination.showLineNumber = true 
    
    return fileDestination
  }
  
  public func getXCGLog(levelLog: XCGLogger.Level = .info) -> XCGLogger { 
   {
    
    let log = XCGLogger.default
    
    log.levelDescriptions[.info] = "🩵Info"
    log.levelDescriptions[.debug] = "💚debug"
    log.levelDescriptions[.warning] = "⚠️warning"
    log.levelDescriptions[.alert] = "❗️alert"
    log.levelDescriptions[.error] = "⛔️error"
    log.levelDescriptions[.severe] = "❌severe"
    log.levelDescriptions[.emergency] = "🆘emergency"
    
    // Dodaj miejsce docelowe pliku do loggera
    log.add(destination: fileDestination())
    
    // Opcjonalnie, możesz dodać inne miejsca docelowe, takie jak konsola, aby widzieć logi w konsoli Xcode.
    //  let consoleDestination = ConsoleDestination(identifier: "consoleDestination")
    //  consoleDestination.outputLevel = .debug // Ustaw poziom logowania według potrzeb
    //  log.add(destination: consoleDestination)
    
    return log
   }()
  }
  
}



extension XCGLogger { 
  
 public func get(_ functionName: StaticString = #function,
           fileName: StaticString = #file, 
           lineNumber: Int = #line,
           userInfo: [String: Any] = [:], 
           closure: () -> Any? = { return "" })  {     
    
    self.logln(.info, functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo) {
      "📨 Get: \(closure() ?? "")"
    }
  }
  
  public func response(_ functionName: StaticString = #function,
                fileName: StaticString = #file,
                lineNumber: Int = #line,
                userInfo: [String: Any] = [:], level: Level = .info,
                closure: () -> Any? = { return "" }) {
    
    self.logln(level, functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo) {
      "📩 Response: \(closure() ?? "")"
    }
  }
  
  public func enterView(_ functionName: StaticString = #function,
                 fileName: StaticString = #file, 
                 lineNumber: Int = #line,
                 userInfo: [String: Any] = [:], 
                 closure: () -> Any? = { return "" }) {
    
    self.logln(.info, functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo) {
      "🪟 Enter View \(closure() ?? "")"
    }
    
  }
  
}




public struct Config { 
  
  public var levelDebug: XCGLogger.Level = .debug 
  public var sizeWhenDelateFile_KB: Double = 10_000.0
  public var identifier: String = "logDestination" 
  public var appendMarker: String = "-- ** * START APP * ** --"
  public var shouldAppend: Bool = true 
  public var nameLogFile: String = "message.txt"
  
  public init(levelDebug: XCGLogger.Level,
              sizeWhenDelateFile_KB: Double, 
              identifier: String,
              appendMarker: String, 
              shouldAppend: Bool) {
    
    self.levelDebug = levelDebug
    self.sizeWhenDelateFile_KB = sizeWhenDelateFile_KB
    self.identifier = identifier
    self.appendMarker = appendMarker
    self.shouldAppend = shouldAppend
  }
  
  //private 
  lazy var paths = FileManager.default
    .urls(for: .documentDirectory, in: .userDomainMask)
    .first!
    .appendingPathComponent(nameLogFile)
  
  
  static public var defaultConfig: Config { 
    .init(levelDebug: .debug,
          sizeWhenDelateFile_KB: 5_000.0, 
          identifier: "logDestination", 
          appendMarker: "-- ** * START APP * ** --", 
          shouldAppend: true)
  }
  
}
