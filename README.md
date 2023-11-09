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
#### Podstawowa konfiguracja. Tworzy instacje log która zapisuje dane do pliku log.txt  
```Swift
var log = KKLogManager(config: config)
```

 #### Konfiguracja wartosci domyslnych  
```Swift
let config2: KKLogConfig = .init(levelDebug: .verbose,
                                sizeWhenDelateFile_KB: 2_000,
                                identifier: "log2_identifer",
                                appendMarker: "# # # # Start App # # # # #", 
                                shouldAppend: true, 
                                nameLogFile: "log2.txt")

let log2: KKLogManager = .init(config: config2)
```
### Konfiguracja znacznikow
```Swift
let levelDestination: LevelDestination = [ .info: "Info", .verbose: "verbose", .warning: "warning", .alert: "alert" ]
let log3: KKLogManager = .init(levelDescriprion: levelDestination)
```

Mozna skonfigurowac wiecej niz jeden KKLogManager. Muszą kozystac z innych nazw plikow
Dzieki temu mozemy skonfigurowac plik logowania tylko dla konkretnego kontentu 
