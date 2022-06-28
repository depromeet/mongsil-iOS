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
  public var secondaryButtonHierachy: AlertButton.Hierarchy = .secondary
  public var primaryButtonTitle: String
  public var primaryButtonHierachy: AlertButton.Hierarchy = .primary
  public var isExistCloseButton: Bool = false

  public init(
    title: String? = nil,
    body: String,
    secondaryButtonTitle: String = "취소",
    secondaryButtonHierachy: AlertButton.Hierarchy = .secondary,
    primaryButtonTitle: String = "확인",
    primaryButtonHierachy: AlertButton.Hierarchy = .primary,
    isExistCloseButton: Bool = false
  ) {
    self.title = title
    self.body = body
    self.secondaryButtonTitle = secondaryButtonTitle
    self.secondaryButtonHierachy = secondaryButtonHierachy
    self.primaryButtonTitle = primaryButtonTitle
    self.primaryButtonHierachy = primaryButtonHierachy
    self.isExistCloseButton = isExistCloseButton
  }
}

public enum AlertDoubleButtonAction: Equatable {
  case secondaryButtonTapped
  case primaryButtonTapped
  case closeButtonTapped
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

    case .closeButtonTapped:
      return .none
    }
  }
])
