//
//  AlertSingleButtonCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/18.
//

import Combine
import ComposableArchitecture
import Foundation

public struct AlertSingleButtonState: Equatable {
  public var title: String?
  public var body: String
  public var primaryButtonTitle: String

  public init(
    title: String? = nil,
    body: String,
    primaryButtonTitle: String = "확인"
  ) {
    self.title = title
    self.body = body
    self.primaryButtonTitle = primaryButtonTitle
  }
}

public enum AlertSingleButtonAction: Equatable {
  case primaryButtonTapped
}

public struct AlertSingleButtonEnvironment {
  public init() {}
}

public let alertSingleButtonreducer = Reducer.combine([
  Reducer<AlertSingleButtonState, AlertSingleButtonAction, AlertSingleButtonEnvironment> { _, action, _ in
    switch action {
    case .primaryButtonTapped:
      return .none
    }
  }
])
