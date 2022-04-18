//
//  AlertButton.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/18.
//

import SwiftUI

public struct AlertButton: View {
  public static var height: CGFloat { 40 }

  public var title: String
  public var hierarchy: Hierarchy = .primary
  public var status: Bool = false

  public var loading: Bool = false
  public var action: () -> Void = {}

  public init(
    title: String,
    hierarchy: Hierarchy = .primary,
    status: Bool = true,
    loading: Bool = false,
    action: @escaping () -> Void = {}
  ) {
    self.title = title
    self.hierarchy = hierarchy
    self.status = status
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
        HStack(spacing: 0) {
          Text(title)
            .font(.title3)
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
        }
        .foregroundColor(status ? hierarchy.enableForegroundColor : hierarchy.disableForegroundColor)
        .frame(height: AlertButton.height)
      }
    )
    .background(status ? hierarchy.enableBackgroundColor : hierarchy.disableBackgroundColor)
    .cornerRadius(4)
    .disabled(status == false)
    .overlayLoading(when: loading)
  }
}

extension AlertButton {
  public enum Hierarchy {
    case primary
    case secondary

    var disableBackgroundColor: Color {
      switch self {
      case .primary: return .gray9
      case .secondary: return .gray9
      }
    }

    var enableBackgroundColor: Color {
      switch self {
      case .primary: return .gray9
      case .secondary: return .gray9
      }
    }

    var disableForegroundColor: Color {
      switch self {
      case .primary: return .gray4
      case .secondary: return .gray4
      }
    }

    var enableForegroundColor: Color {
      switch self {
      case .primary: return .white
      case .secondary: return .white
      }
    }
  }
}
