//
//  Effect+extensions.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import ComposableArchitecture

extension Effect {
  public func mapTo<T>(_ value: T) -> Effect<T, Failure> {
    return self.map({ _ in value })
  }

  public func ignoreOutput() -> Effect<Never, Failure> {
    return self.eraseToAnyPublisher().ignoreOutput().eraseToEffect()
  }
}
