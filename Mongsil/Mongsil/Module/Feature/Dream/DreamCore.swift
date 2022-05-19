//
//  DreamCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/11.
//

import Combine
import ComposableArchitecture

struct DreamState: Equatable {
  var userDream: UserDream

  init(userDream: UserDream) {
    self.userDream = userDream
  }
}

enum DreamAction {
  case backButtonTapped
}

struct DreamEnvironment {
}

let dreamReducer = Reducer<WithSharedState<DreamState>, DreamAction, DreamEnvironment> {
  _, action, _ in
  switch action {
  case .backButtonTapped:
    return .none
  }
}
