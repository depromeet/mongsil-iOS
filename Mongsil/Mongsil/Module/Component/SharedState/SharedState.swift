//
//  SharedState.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import Foundation

@dynamicMemberLookup
public struct WithSharedState<LocalState: Equatable>: Equatable {
  public var local: LocalState
  public var shared: SharedState

  public init(
    local: LocalState,
    shared: SharedState
  ) {
    self.local = local
    self.shared = shared
  }

  public subscript<T>(dynamicMember keyPath: WritableKeyPath<LocalState, T>) -> WithSharedState<T> {
    get { .init(local: local[keyPath: keyPath], shared: shared) }
    set { local[keyPath: keyPath] = newValue.local }
  }

  public subscript<T>(dynamicMember keyPath: WritableKeyPath<LocalState, T?>) -> WithSharedState<T>? {
    get {
      if let local = local[keyPath: keyPath] {
        return .init(local: local, shared: shared)
      } else {
        return nil
      }
    }
    set {
      if let newValue = newValue {
        local[keyPath: keyPath] = newValue.local
        shared = newValue.shared
      }
    }
  }
}

public struct SharedState: Equatable {
  public var toastText: String?
  public var isToastBottomPosition: Bool = true
  public var isLogined: Bool = false

  public init(
    toastText: String? = nil,
    isLogined: Bool = false
  ) {
    self.toastText = toastText
    self.isLogined = isLogined
  }

}
