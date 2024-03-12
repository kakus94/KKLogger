//
//  LogManager.swift
//  Created by Kamil Karpiak on 07/11/2023.
//

import Foundation
import XCGLogger

// variable used to log in applikacjia during debugging
//@available(iOS 16.0, *)
//var log: XCGLogger = KKLogManager.share.getXCGLog(levelLog: .info)

public typealias LevelDestination = [XCGLogger.Level: String]

@available(iOS 16.0, watchOS 9, *)
public class KKLogManager: XCGLogger {
  
  public init(config: KKLogConfig = .defaultConfig, 
              consoleLevel: XCGLogger.Level = .verbose,
              levelDescriprion: LevelDestination = KKLogManager.levelDescriprionDefault) {
    super.init()
    
    self.config = config     
    
    //Ustawienie opisow
    self.setLevelDescriptions(newDescs: levelDescriprion)
    
    // Dodaj miejsce docelowe pliku do loggera
    self.add(destination: fileDestination()) 
    self.setLevelDebugConsole(consoleLevel)
    self.logAppDetails()    
  }
  
  public func getConsoleDestination() -> ConsoleDestination? { 
    self.destination(withIdentifier: XCGLogger.Constants.baseConsoleDestinationIdentifier) as? ConsoleDestination
  }
  
  public func setLevelDebugConsole(_ level: XCGLogger.Level) { 
    guard let console = getConsoleDestination() else { return }
    console.outputLevel = level
  }

  
  public static var levelDescriprionDefault: LevelDestination {
    var values: LevelDestination = .init()
    
    values[.info] = "🩵Info"
    values[.debug] = "💚debug"
    values[.warning] = "⚠️warning"
    values[.alert] = "❗️alert"
    values[.error] = "⛔️error"
    values[.severe] = "❌severe"
    values[.emergency] = "🆘emergency"
    
    return values
  }
  
  public var config: KKLogConfig = KKLogConfig.defaultConfig  
  
  public func setLevelDescriptions(newDescs: [XCGLogger.Level: String]) {
    for newDesc in newDescs {
      self.levelDescriptions[newDesc.key] = newDesc.value
    }
  }
  
  public func size() -> Double? { 
    do { 
      let fileAttributes = try FileManager.default
        .attributesOfItem(atPath: config.paths.path())
      if let fileSize = fileAttributes[.size] as? Int64 {
//        self.info("Log file size: \(fileSize) B")
        return Double( Double(fileSize) / 1_000 )
      }
    } catch { 
      print(error)
    }
    
    return nil    
  }
  
  public func buttonDeleteAction() { 
    sendNotifyToShowConfirmDialog()
  }
  
  public func sizeString() -> String? { 
    guard let size = size() else { return "not find" }    
    return String(format: "%.0f", size)
  }   
  
  public func whetherDeleteFile() { 
    guard let size = size() else { return }//KB 
    if size > config.sizeWhenDelateFile_KB { 
      sendNotifyToShowConfirmDialog()
    }
  }
  
  private func sendNotifyToShowConfirmDialog() { 
    NotificationCenter.default.post(name: Notification.Name.askDelateFile, object: nil, userInfo: ["id": config.identifier, "path": config.paths])
  }
  
  public func NotificationObserver(_ handler: @escaping (Notification) -> Void) { 
    NotificationCenter.default.addObserver(forName: Notification.Name.askDelateFile, object: nil, queue: .main, using: handler)
  }
  
  public func delete() { 
    do {
      let fileManager = FileManager.default
      
      // Check if the file exists before attempting to delete it
      if fileManager.fileExists(atPath: config.paths.path) {        
        
        self.remove(destinationWithIdentifier: config.identifier)
        try fileManager.removeItem(at: config.paths)
        self.add(destination: fileDestination())                
        
        self.info("File deleted successfully")
      } else {
        self.warning("File does not exist")
      }
    } catch {
      self.error("Error deleting the file: \(error)")
    }
  }
  
  private func fileDestination() -> FileDestination { 
    // Skonfiguruj miejsce docelowe pliku
    let fileDestination = FileDestination(writeToFile: config.paths, 
                                          identifier: config.identifier, 
                                          shouldAppend: config.shouldAppend, 
                                          appendMarker: config.appendMarker)
    
    fileDestination.outputLevel = config.levelDebug // Ustaw poziom logowania według potrzeb
    fileDestination.showLogIdentifier = false
    fileDestination.showFunctionName = true
    fileDestination.showThreadName = false
    fileDestination.showLevel = true
    fileDestination.showFileName = true
    fileDestination.showLineNumber = true 
    
    return fileDestination
  }

  
}



@available(iOS 16.0, watchOS 9, *)
extension KKLogManager { 
  
  
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

  
  public func fileLocation() -> String { 
    return self.config.paths.description
  }
  
}




public struct KKLogConfig { 
  
  public var levelDebug: XCGLogger.Level = .debug 
  public var sizeWhenDelateFile_KB: Double = 10_000.0
  public var identifier: String = "logDestination" 
  public var appendMarker: String = "-- ** * START APP * ** --"
  public var shouldAppend: Bool = true 
  public var nameLogFile: String = "log.txt"
  
  public init(levelDebug: XCGLogger.Level, sizeWhenDelateFile_KB: Double, identifier: String, appendMarker: String, shouldAppend: Bool, nameLogFile: String) {
    self.levelDebug = levelDebug
    self.sizeWhenDelateFile_KB = sizeWhenDelateFile_KB
    self.identifier = identifier
    self.appendMarker = appendMarker
    self.shouldAppend = shouldAppend
    self.nameLogFile = nameLogFile
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
          shouldAppend: true,
          nameLogFile: "log.txt")
  }
  
}


extension Notification.Name { 
  
  static let askDelateFile = Notification.Name("AskDelateFile")
  
}
