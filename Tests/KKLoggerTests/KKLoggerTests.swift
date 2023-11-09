import XCTest
import XCGLogger
@testable import KKLogger

@available(iOS 16.0, *)
final class KKLoggerTests: XCTestCase {
  
  
    func testExample() throws {
      let log = KKLogManager(levelDescriprion: [.info: "sda"])
      
      log.setLevelDebugConsole(.verbose)
      
      log.info("info")
      log.debug("debug")
      log.error()
      log.warning()
      
      print(log.fileLocation())
      print(log.sizeString() ?? "" )
      log.delete()
      print(log.sizeString() ?? "" )
    }
  
  
  func test_initDefault() throws { 
    print("##########  INIT DEFAULT ###########")
    let log = KKLogManager()
    
    let console = log.destination(withIdentifier: XCGLogger.Constants.baseConsoleDestinationIdentifier) as? ConsoleDestination
    
    console?.outputLevel = .emergency
    
    printAll(log)
    log.sizeString()?.print()
    //the file should contain a circle 1603 B
    XCTAssertTrue(log.size() ?? 0 > 1.4)//KB
    
    log.fileLocation().print()
    log.delete()
  }
  
  func test_initConfig() throws {
    print("##########  INIT USER CREATE DEFAULT ###########")
    let config: KKLogConfig = .init(levelDebug: .error,
                                    sizeWhenDelateFile_KB: 5.0,
                                    identifier: "testIden", 
                                    appendMarker: "new Run app",
                                    shouldAppend: true, 
                                    nameLogFile: "testUserCreateLog.txt")
    let log = KKLogManager(config: config)
    printAll(log)
    log.sizeString()?.print()
    //the file should contain a circle 716 B
    XCTAssertTrue(log.size() ?? 0 > 0.6)//KB
    
    log.delete()
  }
  
  func test_levelDescriprionDefault() { 
    print("########## Level Descriprion Default ###########")
    let levelDestination: LevelDestination = [.info: "i", .verbose: "v", .warning: "w", .alert: "a", .debug: "d", .error: "e", .emergency: "E", .severe: "s" ]
    let log3: KKLogManager = .init(levelDescriprion: levelDestination)
    printAll(log3)
    log3.size()?.description.print()
    //the file should contain a circle 1509 B
    XCTAssertTrue(log3.size() ?? 0 > 1.5)//KB
    log3.delete()
    
    let levelDestination2: LevelDestination = [.info: "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii", 
      .verbose: "vvvvvvvvvvvvvvvvvvvvvvv",
                                               .warning: "wwwwwwwwwwwwwwwwwww",
                                               .alert: "aaaaaaaaaaaaaaaaaaaaaaaaa",
                                               .debug: "ddddddddddddddddddddddddd",
                                               .error: "eeeeeeeeeeeeeeeeeeeeeeeeeee",
                                               .emergency: "EEEEEEEEEEEEEEEEEEEEEEEEE",
                                               .severe: "ssssssssssssssssssssssssssssssss" ]
    
    
    let log4: KKLogManager = .init(levelDescriprion: levelDestination2)
    printAll(log4)
    log4.size()?.description.print()
    //the file should contain a circle 1824 B
    XCTAssertTrue(log4.size() ?? 0 > 1.8)//KB
    
    log4.delete()
  }
  
  
  
  
  func printAll(_ log: KKLogManager ) { 
    log.verbose()
    log.debug()
    log.warning()
    log.error()
    log.alert()
    log.emergency()
    log.info()
    log.severe()
    log.enterView()
    log.get()
    log.response()
  }
  
}


extension String { 
  
  func print() { 
    Swift.print(self)
  }
  
}
