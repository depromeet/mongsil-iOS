//
//  ListButtonItemWithText.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import SwiftUI

public struct ListButtonItemWithText<Content: View>: View {
  private var buttonAction: () -> Void = {}
  private var content: Content

  public init(
    buttonAction: @escaping () -> Void = {},
    @ViewBuilder content: () -> Content
  ) {
    self.buttonAction = buttonAction
    self.content = content()
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Button(
        action: buttonAction,
        label: {
          HStack {
            content
            Spacer()
          }
        }
      )
      Spacer()
        .frame(height: 5)
    }
    .separator()
  }
}
