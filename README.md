# KKLogger
Library for writing logs to a file and console.
It is as simplified as possible. With one line of code we can start saving logs to a file 

# Project objective
* Simple use and configuration
* Ready login view
* Sending logs to the server


# Technologies
The library is based on XCGLogger https://github.com/DaveWoodCom/XCGLogger

# Installation

## Swift Package Manager

Add the following entry to your package's dependencies:

```Swift
.Package(url: "https://github.com/kakus94/KKLogger", branch: "main")
```

## Basic Usage (Quick Start)
#### Basic configuration. Creates a log instance that writes data to the log.txt file  
```Swift
var log = KKLogManager(config: config)
```

 #### Configuration of default values 
```Swift
let config2: KKLogConfig = .init(levelDebug: .verbose,
                                sizeWhenDelateFile_KB: 2_000,
                                identifier: "log2_identifer",
                                appendMarker: "# # # # Start App # # # # #", 
                                shouldAppend: true, 
                                nameLogFile: "log2.txt")

let log2: KKLogManager = .init(config: config2)
```
### Tag configuration
```Swift
let levelDestination: LevelDestination = [ .info: "Info", .verbose: "verbose", .warning: "warning", .alert: "alert" ]
let log3: KKLogManager = .init(levelDescriprion: levelDestination)
```

More than one LogManager can be configured. They must use different filenames
Thanks to this, we can configure the login file only for specific content

## Log View 

Abys korzystac z widoku pilku wystarczy odwolac sie do KKLogContentView z parametrem KKLogManager 
```Swift
let log: KKLogManager = .init()

KKLoggerContentView(model: log)

```
![Zrzut ekranu 2023-11-10 o 10 16 39](https://github.com/kakus94/KKLogger/assets/32176685/378cb34b-ff9e-43cb-9744-4ec5eb690927)

A view with the option to delete a file
* option 1: without confirmation
* option 2: with confirmation

```Swift
struct LogView: View {
  
  let model: KKLogManager  
 @Environment(\.presentationMode) var presentationMode

    var body: some View {
        KKLoggerContentView(model: model)
        .navigationTitle("Log file")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) { 
            Button(action: {
              // Option 1# delete file
              log.delete()
              //OR
              // Option 2# confirm dialog
              log.buttonDeleteAction() 
              presentationMode.wrappedValue.dismiss()
            }, label: {
              Image(systemName: "trash.fill")
            })
          }
        }        
    }
}
```

### Option 2 
A view that will handle the deletion query.
For the deletion to work, you must also handle file deletion notifications. 
```Swift 
struct ContentView: View {

@State private var showAskDelateFile: Bool = false

var body: some View {
 Text("Parrent View")
    .alert(isPresented: $showAskDelateFile) {
      Alert(
        title: Text("Log FIle "),
        message: Text("The file size is \(log.sizeString() ?? "" )KB. \nDo you want to delete the file?"),
        primaryButton: .default(Text("Yes")) {
          log.delete()
          log.info("User delete File'")
        },
        secondaryButton: .cancel(Text("No")) {
          log.info("The user did not delete the file'")
        }
      )
    }
    .onAppear {      
      log.NotificationObserver { notify in
        if log.config.identifier == notify.userInfo?["id"] as! String {
          showAskDelateFile = true
          log.info("Show ask delate log file")
        }
      }
    }
}

}
```
![Zrzut ekranu 2023-11-10 o 10 29 42](https://github.com/kakus94/KKLogger/assets/32176685/c5df4733-5eb1-42bd-95a2-a17337d40180)

![Zrzut ekranu 2023-11-10 o 10 32 13](https://github.com/kakus94/KKLogger/assets/32176685/2db968db-da2d-4645-8c57-20fe013a7c33)



