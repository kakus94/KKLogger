//
//  SwiftUIView.swift
//  
//
//  Created by Kamil Karpiak on 10/11/2023.
//

import SwiftUI

@available(iOS 16.0, watchOS 9, *)
public struct KKLoggerContentView: View {
  
  var model: KKLogManager
  var nlastLines = 1000
  
  @State private var bodyArray: ArraySlice<String> = ArraySlice<String>()
  
  public init(model: KKLogManager) {
    self.model = model
  }
  
   public var body: some View {
      VStack {
        List(bodyArray, id: \.self ) { value in
            Text(value)
            .font(.footnote)
        }
          #if iOS
        .listStyle(InsetListStyle())
          #endif
      }
      .onAppear { 
        bodyArray = getLogArrayFromFile(nlastLines)
      }
    }  
  
  func getLogArrayFromFile(_ nlastLines: Int) -> ArraySlice<String> {
     let logContent = getLogFromFile()
     let lines = logContent.components(separatedBy: "\n")
     let nLines = lines.count
     if nLines > nlastLines {
         let linesToGet = lines[nLines - nlastLines ..< nLines]
         return linesToGet
     } else {
         return lines[0 ..< nLines]
     }
  }
  
  func getLogFromFile() -> String {
    let fileUrl = model.config.paths
      let logContent = (try? String(contentsOf: fileUrl)) ?? ""
      return logContent
  }    
}

@available(iOS 16.0, watchOS 9, *)
struct ppreview: PreviewProvider {  
  static var previews: some View {
    KKLoggerContentView(model: KKLogManager())
  }  
}
