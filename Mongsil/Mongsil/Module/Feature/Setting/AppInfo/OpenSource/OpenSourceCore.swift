//
//  OpenSourceCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import Combine
import ComposableArchitecture

struct OpenSourceState: Equatable { }

enum OpenSourceAction {
  case backButtonTapped
}

struct OpenSourceEnvironment { }

let openSourceReducer = Reducer<WithSharedState<OpenSourceState>, OpenSourceAction, OpenSourceEnvironment> {
  _, action, _ in
  switch action {
  case .backButtonTapped:
    return .none
  }
}
