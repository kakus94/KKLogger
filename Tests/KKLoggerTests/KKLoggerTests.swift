import XCTest
@testable import KKLogger

@available(iOS 16.0, *)
final class KKLoggerTests: XCTestCase {
    func testExample() throws {
      let log = KKLogManager(levelDescriprion: [.info: "sda"])
      
      log.setLevelDebug(.verbose)
      
      log.info("info")
      log.debug("debug")
      log.error()
      log.warning()
      
      print(log.fileLocation())
      print(log.sizeString() ?? "" )
      log.delete()
      print(log.sizeString() ?? "" )
    }
}
