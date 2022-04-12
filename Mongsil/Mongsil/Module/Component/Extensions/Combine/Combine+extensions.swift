//
//  Combine+extensions.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import Combine

extension Publisher {
  public func mapTo<T>(_ value: T) -> Publishers.Map<Self, T> {
    return self.map({ _ in value })
  }
}
