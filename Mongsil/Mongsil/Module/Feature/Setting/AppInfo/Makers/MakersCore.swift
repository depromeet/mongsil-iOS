//
//  MakersCore.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/20.
//

import ComposableArchitecture
import SwiftUI

struct MakersState: Equatable {
  public var makersList: [Makers]?
}

enum MakersAction {
  case backButtonTapped
  case onAppear
  case makersCardTapped(URL)
}

struct MakersEnvironment {
}

let makersReducer = Reducer<WithSharedState<MakersState>, MakersAction, MakersEnvironment> {
  state, action, _ in
  switch action {
  case .onAppear:
    state.local.makersList = Makers.makersList
    return .none

  case .backButtonTapped:
    return .none

  case let .makersCardTapped(url):
    UIApplication.shared.open(url)
    return .none
  }
}
