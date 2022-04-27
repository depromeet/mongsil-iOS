//
//  Toast.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/25.
//

import Combine
import Foundation
import SwiftUI

extension View {
  public func toast(text: String?, isBottomPosition: Bool = true) -> some View {
    return self.overlay(
      ToastView(text: text)
        .animation(.easeInOut, value: 0.2),
      alignment: isBottomPosition ? .bottom : .top
    )
  }
}

private struct ToastView: View {
  @Environment(\.colorScheme) var colorScheme: ColorScheme

  var text: String?

  public init(text: String? = nil) {
    self.text = text
  }

  var foregroundColor: Color {
    switch colorScheme {
    case .light:
      return .black
    case .dark:
      return .black
    @unknown default:
      return .black
    }
  }

  var backgroundColor: Color {
    switch colorScheme {
    case .light:
      return Color.gray.opacity(0.8)
    case .dark:
      return Color.gray.opacity(0.8)
    @unknown default:
      return Color.gray.opacity(0.8)
    }
  }

  var body: some View {
    VStack {
      if text != nil {
        Text(text ?? "")
          .font(.caption1)
          .padding(.vertical, 8)
          .padding(.horizontal, 20)
          .foregroundColor(foregroundColor)
          .background(
            backgroundColor.cornerRadius(21.5)
          )
      } else {
        EmptyView()
      }
    }
  }
}

public protocol ToastPresentableAction {
  static func presentToast(_ toastText: String) -> Self
}
