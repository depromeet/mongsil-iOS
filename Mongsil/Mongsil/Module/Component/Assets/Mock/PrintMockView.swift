//
//  PrintMockView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/01.
//

import SwiftUI

struct PrintMockView: View {
  var body: some View {
    printMock()
    return Text("A")
  }
}

private func printMock() {
  guard let path = Bundle.main.path(forResource: "mock", ofType: "json") else {
    return print("path error")
  }
  
  guard let jsonString = try? String(contentsOfFile: path) else {
    return print("error")
  }
  let decoder = JSONDecoder()
  let data = jsonString.data(using: .utf8)
  if let data = data,
     let dream = try? decoder.decode(Dream.self, from: data) {
    print(dream)
  }
}
