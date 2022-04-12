//
//  TermsCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import Combine
import ComposableArchitecture

struct TermsState: Equatable {}

enum TermsAction {
  case backButtonTapped
}

struct TermsEnvironment { }

let termsReducer = Reducer<WithSharedState<TermsState>, TermsAction, TermsEnvironment> {
  _, action, _ in
  switch action {
  case .backButtonTapped:
    return .none
  }
}
