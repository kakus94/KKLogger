# KKLogger
Biblioteka do zapisu logow do pliku i consoli. 
Jest maksymalnie uproszczona aby za pomoca jednej linijki kodu umozliwic zapis logow do pliku 

# Cel projektu
* Proste użycie i konfiguracja 
* Gotowy widok logow
* wysylanie logow na serwer 


# Technologie
Biblioteka oparta jest na XCGLogger https://github.com/DaveWoodCom/XCGLogger

# Installation

## Swift Package Manager

Add the following entry to your package's dependencies:

```Swift
.Package(url: "https://github.com/kakus94/KKLogger", majorVersion: 7)
```

## Basic Usage (Quick Start)
Podstawowa konfiguracja. Tworzy instacje log która zapisuje dane do pliku log.txt  
```Swift
var log = KKLogManager(config: config)
```

 Konfiguracja wartosci domyslnych  
```Swift
let config2: KKLogConfig = .init(levelDebug: .verbose,
                                sizeWhenDelateFile_KB: 2_000,
                                identifier: "log2_identifer",
                                appendMarker: "# # # # Start App # # # # #", 
                                shouldAppend: true, 
                                nameLogFile: "log2.txt")

let log2: KKLogManager = .init(config: config2)
```
Konfiguracja znacznikow
```Swift
let levelDestination: LevelDestination = [ .info: "Info", .verbose: "verbose", .warning: "warning", .alert: "alert" ]
let log3: KKLogManager = .init(levelDescriprion: levelDestination)
```

Mozna skonfigurowac wiecej niz jeden KKLogManager. Muszą kozystac z innych nazw plikow
Dzieki temu mozemy skonfigurowac plik logowania tylko dla konkretnego kontentu 
