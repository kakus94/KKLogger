//
//  LogManager.swift
//  Created by Kamil Karpiak on 07/11/2023.
//

import Foundation
import XCGLogger

// variable used to log in applikacjia during debugging
//@available(iOS 16.0, *)
//var log: XCGLogger = KKLogManager.share.getXCGLog(levelLog: .info)

@available(iOS 16.0, *)
public class KKLogManager { 
  
  static public let share = KKLogManager()
  
  public var config: KKLogConfig = KKLogConfig.defaultConfig
  
  var log: XCGLogger = KKLogManager.share.getXCGLog(levelLog: .info)
  
  func setLevelDebug(_ level: XCGLogger.Level ) { 
    log.setup(level: level)
  }
  
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
  
  func whetherDeleteFile() { 
    guard let size = size() else { return }//KB 
    if size > config.sizeWhenDelateFile_KB { 
      NotificationCenter.default.post(name: Notification.Name("AskDelateFile"), object: nil)
    }
  }
  
  func delete() { 
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
  
  public func getXCGLog(levelLog: XCGLogger.Level = .info, config: KKLogConfig) -> XCGLogger {
    self.config = config 
    return getXCGLog(levelLog: levelLog)    
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
    self.log = log
    return log
   }()
  }
  
}



@available(iOS 16.0, *)
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
  
  public func delateFileLog() { 
    let kklm = KKLogManager.share
    kklm.delete()
  }
  
  public func getSizeLogFile() -> String? { 
    let kklm = KKLogManager.share
    return kklm.sizeString()
  }
  
  public func getSizeLogFile() -> Double? { 
    let kklm = KKLogManager.share
    return kklm.size()
  }
  
  public func whetherDeleteFile() { 
    let kklm = KKLogManager.share
    kklm.whetherDeleteFile()
  }
  
  public func setLevelDebug(_ level: XCGLogger.Level) { 
    let kklm = KKLogManager.share
    kklm.setLevelDebug(level)
  }
  
}




public struct KKLogConfig { 
  
  public var levelDebug: XCGLogger.Level = .debug 
  public var sizeWhenDelateFile_KB: Double = 10_000.0
  public var identifier: String = "logDestination" 
  public var appendMarker: String = "-- ** * START APP * ** --"
  public var shouldAppend: Bool = true 
  public var nameLogFile: String = "log.txt"
  
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
  
  
  static public var defaultConfig: KKLogConfig { 
    .init(levelDebug: .debug,
          sizeWhenDelateFile_KB: 5_000.0, 
          identifier: "logDestination", 
          appendMarker: "-- ** * START APP * ** --", 
          shouldAppend: true)
  }
  
}
