//
//  StorageView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import SwiftUI
import ComposableArchitecture

struct StorageView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>
  
  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }
  var body: some View {
    VStack{
      MSNavigationBar(
        titleText: "보관함"
//        rightButtonImageText: "circle.fill"
      )
      Spacer()
      Text("StoreView")
      Spacer()
    }
    .navigationTitle("")
    .navigationBarHidden(true)
  }
}
