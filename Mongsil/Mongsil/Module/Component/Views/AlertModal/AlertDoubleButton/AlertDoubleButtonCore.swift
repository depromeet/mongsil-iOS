//
//  AlertDoubleButtonCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/18.
//

import Combine
import ComposableArchitecture
import Foundation

public struct AlertDoubleButtonState: Equatable {
  public var title: String?
  public var body: String
  public var secondaryButtonTitle: String
  public var primaryButtonTitle: String

  public init(
    title: String? = nil,
    body: String,
    secondaryButtonTitle: String = "취소",
    primaryButtonTitle: String = "확인"
  ) {
    self.title = title
    self.body = body
    self.secondaryButtonTitle = secondaryButtonTitle
    self.primaryButtonTitle = primaryButtonTitle
  }
}

public enum AlertDoubleButtonAction: Equatable {
  case secondaryButtonTapped
  case primaryButtonTapped
}

public struct AlertDoubleButtonEnvironment {
  public init() {}
}

public let alertDoubleButtonReducer = Reducer.combine([
  Reducer<AlertDoubleButtonState, AlertDoubleButtonAction, AlertDoubleButtonEnvironment> {
    _, action, _ in
    switch action {
    case .secondaryButtonTapped:
      return .none

    case .primaryButtonTapped:
      return .none
    }
  }
])