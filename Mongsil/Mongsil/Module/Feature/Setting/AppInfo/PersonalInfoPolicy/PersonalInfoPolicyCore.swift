//
//  PersonalInfoPolicyCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import Combine
import ComposableArchitecture

struct PersonalInfoPolicyState: Equatable { }

enum PersonalInfoPolicyAction {
  case backButtonTapped
}

struct PersonalInfoPolicyEnvironment { }

let personalInfoPolicyReducer = Reducer<
  WithSharedState<PersonalInfoPolicyState>,
  PersonalInfoPolicyAction,
  PersonalInfoPolicyEnvironment
> {
  _, action, _ in
  switch action {
  case .backButtonTapped:
    return .none
  }
}
