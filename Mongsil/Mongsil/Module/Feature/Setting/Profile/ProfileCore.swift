//
//  ProfileCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import Combine
import ComposableArchitecture

struct ProfileState: Equatable {

}

enum ProfileAction {
  case backButtonTapped
  case logoutButtonTapped
  case withdrawButtonTapped
}

struct ProfileEnvironment {

}

let profileReducer = Reducer<WithSharedState<ProfileState>, ProfileAction, ProfileEnvironment> {
  _, action, _ in
  switch action {
  case .backButtonTapped:
    return .none

  case .logoutButtonTapped:
    return Effect(value: .backButtonTapped)

  case .withdrawButtonTapped:
    return .none
  }
}
