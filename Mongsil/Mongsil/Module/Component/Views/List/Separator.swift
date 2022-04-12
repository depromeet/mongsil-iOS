//
//  Separator.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import SwiftUI

public struct Separator: View {
  public var color: Color = .white
  public var height: CGFloat = 1

  public init(
    color: Color = .white,
    height: CGFloat = 1
  ) {
    self.color = color
    self.height = height
  }

  public var body: some View {
    Rectangle()
      .frame(height: 1)
      .foregroundColor(color)
  }
}

extension View {
  public func separator(
    color: Color = .white,
    height: CGFloat = 1,
    alignment: Alignment = .bottom
  ) -> some View {
    self.overlay(Separator(color: color, height: height), alignment: alignment)
  }

  public func separator(
    when condition: Bool,
    color: Color = .white,
    height: CGFloat = 1,
    alignment: Alignment = .bottom
  ) -> some View {
    if condition {
      return self.overlay(
        Separator(color: color, height: height),
        alignment: alignment
      ).eraseToAnyView()
    } else {
      return self.eraseToAnyView()
    }
  }
}
