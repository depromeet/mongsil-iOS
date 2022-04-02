//
//  AppView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
  private let store: Store<AppState, AppAction>
  
  init(store: Store<AppState, AppAction>) {
    self.store = store
  }
  
  var body: some View {
    Text("Mongsil")
      .padding()
  }
}
