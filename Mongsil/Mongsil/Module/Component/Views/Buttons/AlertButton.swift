//
//  AlertButton.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/18.
//

import SwiftUI

public struct AlertButton: View {
  public static var height: CGFloat { 56 }

  public var title: String
  public var hierarchy: Hierarchy = .primary
  public var loading: Bool = false
  public var action: () -> Void = {}

  public init(
    title: String,
    hierarchy: Hierarchy = .primary,
    loading: Bool = false,
    action: @escaping () -> Void = {}
  ) {
    self.title = title
    self.hierarchy = hierarchy
    self.loading = loading
    self.action = action
  }

  public var body: some View {
    Button(
      action: {
        guard !loading else { return }
        self.action()
      },
      label: {
        HStack {
          Spacer()
          Text(title)
            .font(.button)
            .foregroundColor(hierarchy.foregroundColor)
          Spacer()
        }
      }
    )
    .frame(height: AlertButton.height)
    .background(hierarchy.backgroundColor)
    .overlayLoading(when: loading)
  }
}

extension AlertButton {
  public enum Hierarchy {
    case primary
    case warning
    case secondary

    var backgroundColor: Color {
      switch self {
      case .primary: return .gray9
      case .warning: return .gray9
      case .secondary: return .gray9
      }
    }

    var foregroundColor: Color {
      switch self {
      case .primary: return .white
      case .warning: return .msRed
      case .secondary: return .gray7
      }
    }
  }
}
