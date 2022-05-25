//
//  MakersCore.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/20.
//

import ComposableArchitecture

struct MakersState: Equatable {
  public var makersList: [Makers]?
}

enum MakersAction {
  case backButtonTapped
}

struct MakersEnvironment {
}

let makersReducer = Reducer<WithSharedState<MakersState>, MakersAction, MakersEnvironment> {
  state, action, environment in
  switch action {
  case .backButtonTapped:
    return .none
  }
}
