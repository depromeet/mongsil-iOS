//
//  AppInfoCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import Combine
import ComposableArchitecture

struct AppInfoState: Equatable {
  public var isTermsPushed: Bool = false
  public var isPersonalInfoPolicyPushed: Bool = false
  public var isOpenSourcePushed: Bool = false
  public var isMakersPushed: Bool = false
  
  // Child State
  public var terms: TermsState?
  public var personalInfoPolicy: PersonalInfoPolicyState?
  public var openSource: OpenSourceState?
  public var makers: MakersState?
  
  init(
    isTermsPushed: Bool = false,
    isPersonalInfoPolicyPushed: Bool = false,
    isOpenSourcePushed: Bool = false,
    isMakersPushed: Bool = false
  ) {
    self.isTermsPushed = isTermsPushed
    self.isPersonalInfoPolicyPushed = isPersonalInfoPolicyPushed
    self.isOpenSourcePushed = isOpenSourcePushed
    self.isMakersPushed = isMakersPushed
  }
}

enum AppInfoAction {
  case backButtonTapped
  case setTermsPushed(Bool)
  case setPersonalInfoPolicyPushed(Bool)
  case setOpenSourcePushed(Bool)
  case setMakersPushed(Bool)
  
  // Child Action
  case terms(TermsAction)
  case personalInfoPolicy(PersonalInfoPolicyAction)
  case openSource(OpenSourceAction)
  case makers(MakersAction)
}

struct AppInfoEnvironment { }

let appInfoReducer: Reducer<WithSharedState<AppInfoState>, AppInfoAction, AppInfoEnvironment> =
Reducer.combine([
  termsReducer
    .optional()
    .pullback(
      state: \.terms,
      action: /AppInfoAction.terms,
      environment: { _ in
        TermsEnvironment()
      }
    ) as Reducer<WithSharedState<AppInfoState>, AppInfoAction, AppInfoEnvironment>,
  personalInfoPolicyReducer
    .optional()
    .pullback(
      state: \.personalInfoPolicy,
      action: /AppInfoAction.personalInfoPolicy,
      environment: { _ in
        PersonalInfoPolicyEnvironment()
      }
    ) as Reducer<WithSharedState<AppInfoState>, AppInfoAction, AppInfoEnvironment>,
  openSourceReducer
    .optional()
    .pullback(
      state: \.openSource,
      action: /AppInfoAction.openSource,
      environment: { _ in
        OpenSourceEnvironment()
      }
    ) as Reducer<WithSharedState<AppInfoState>, AppInfoAction, AppInfoEnvironment>,
  makersReducer
    .optional()
    .pullback(
      state: \.makers,
      action: /AppInfoAction.makers,
      environment: { _ in
        MakersEnvironment()
      }
    ) as Reducer<WithSharedState<AppInfoState>, AppInfoAction, AppInfoEnvironment>,
  Reducer<WithSharedState<AppInfoState>, AppInfoAction, AppInfoEnvironment> {
    state, action, _ in
    switch action {
    case .backButtonTapped:
      return .none
      
    case let .setTermsPushed(pushed):
      state.local.isTermsPushed = pushed
      if pushed {
        state.local.terms = .init()
      }
      return .none
      
    case let .setPersonalInfoPolicyPushed(pushed):
      state.local.isPersonalInfoPolicyPushed = pushed
      if pushed {
        state.local.personalInfoPolicy = .init()
      }
      return .none
      
    case let .setOpenSourcePushed(pushed):
      state.local.isOpenSourcePushed = pushed
      if pushed {
        state.local.openSource = .init()
      }
      return .none
      
    case let .setMakersPushed(pushed):
      state.local.isMakersPushed = pushed
      if pushed {
        state.local.makers = .init()
      }
      return .none
      
    case .terms(.backButtonTapped):
      return Effect(value: .setTermsPushed(false))
      
    case .terms:
      return .none
      
    case .personalInfoPolicy(.backButtonTapped):
      return Effect(value: .setPersonalInfoPolicyPushed(false))
      
    case .personalInfoPolicy:
      return .none
      
    case .openSource(.backButtonTapped):
      return Effect(value: .setOpenSourcePushed(false))
      
    case .makers(.backButtonTapped):
      return Effect(value: .setMakersPushed(false))
      
    case .openSource:
      return .none
      
    case .makers:
      return .none
    }
  }
])
