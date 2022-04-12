//
//  View+extensions.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import SwiftUI

extension View {
  public func `if`<Content: View>(
    _ conditional: Bool,
    content: (Self) -> Content
  ) -> some View {
    if conditional {
      return content(self).eraseToAnyView()
    } else {
      return self.eraseToAnyView()
    }
  }

  public func apply<Content: View>(content: (Self) -> Content) -> AnyView {
    return content(self).eraseToAnyView()
  }

  public func eraseToAnyView() -> AnyView {
    return AnyView(self)
  }

  public func shadow(
    color: Color,
    x: CGFloat,
    y: CGFloat,
    blur: CGFloat,
    spread: CGFloat
  ) -> some View {
    let radius = blur / 2.0
    let spreadedX = x + spread
    let spreadedY = y + spread
    return shadow(
      color: color,
      radius: radius,
      x: spreadedX,
      y: spreadedY
    )
  }

  public func cornerRadius(
    _ radius: CGFloat,
    corners: UIRectCorner
  ) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

public struct RoundedCorner: Shape {
  public var radius: CGFloat = .infinity
  public var corners: UIRectCorner = .allCorners

  public func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}
