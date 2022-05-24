//
//  DiaryView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/11.
//

import SwiftUI
import ComposableArchitecture

struct DiaryView: View {
  private let store: Store<WithSharedState<DiaryState>, DiaryAction>
  
  init(store: Store<WithSharedState<DiaryState>, DiaryAction>) {
    self.store = store
  }
  
  var body: some View {
    VStack {
      MSNavigationBar(
        backButtonImage: R.CustomImage.backIcon.image,
        backButtonAction: { ViewStore(store).send(.backButtonTapped) }
      )
      WithViewStore(store.scope(state: \.local.diary)) { diaryViewStore in
        Text("\(diaryViewStore.state.title)")
      }
      
      Spacer()
    }
    .navigationBarHidden(true)
  }
}
