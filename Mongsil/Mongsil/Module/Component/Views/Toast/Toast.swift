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
      return .gray10
    case .dark:
      return .gray10
    @unknown default:
      return .gray10
    }
  }

  var backgroundColor: Color {
    switch colorScheme {
    case .light:
      return .gray2
    case .dark:
      return .gray2
    @unknown default:
      return .gray2
    }
  }

  var body: some View {
    VStack {
      if text != nil {
        Text(text ?? "")
          .font(.body2)
          .padding(.vertical, 12)
          .padding(.horizontal, 20)
          .foregroundColor(foregroundColor)
          .background(
            backgroundColor.cornerRadius(24)
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
