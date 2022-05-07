//
//  ErrorFactory.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/06.
//

import Foundation

public protocol ErrorFactory {
  static var domain: String { get }
  associatedtype Code: RawRepresentable where Code.RawValue == Int
}

extension ErrorFactory {
  public static var domain: String { "\(Self.self)" }
}
