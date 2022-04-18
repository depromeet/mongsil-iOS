//
//  RecordCore.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import Combine
import ComposableArchitecture

struct RecordState: Equatable {
}

enum RecordAction: Equatable {
  case backButtonTapped
}

struct RecordEnvironment {
}

let recordReducer = Reducer<WithSharedState<RecordState>, RecordAction, RecordEnvironment> {
  state, action, env in
  switch action {
  case .backButtonTapped:
    return .none
  }
}
