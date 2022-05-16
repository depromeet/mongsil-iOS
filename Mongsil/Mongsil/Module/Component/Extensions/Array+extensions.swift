//
//  Array+extensions.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/16.
//

extension Array where Element: Equatable {
  mutating func remove(object: Element) {
    guard let index = firstIndex(of: object) else { return }
    remove(at: index)
  }
}
