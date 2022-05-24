//
//  DiaryCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/11.
//

import Combine
import ComposableArchitecture

struct DiaryState: Equatable {
  var diary: Diary
  
  init(diary: Diary) {
    self.diary = diary
  }
}

enum DiaryAction {
  case backButtonTapped
}

struct DiaryEnvironment {
}

let diaryReducer = Reducer<WithSharedState<DiaryState>, DiaryAction, DiaryEnvironment> {
  _, action, _ in
  switch action {
  case .backButtonTapped:
    return .none
  }
}
