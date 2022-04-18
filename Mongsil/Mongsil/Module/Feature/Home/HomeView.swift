//
//  HomeView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
  private let store: Store<WithSharedState<HomeState>, HomeAction>
  
  init(store: Store<WithSharedState<HomeState>, HomeAction>) {
    self.store = store
  }
  var body: some View {
    Text("homeView")
      .navigationTitle("")
      .navigationBarHidden(true)
  }
}
