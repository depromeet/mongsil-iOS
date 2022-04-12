//
//  ListItemWithText.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import SwiftUI

public struct ListItemWithText<Content: View>: View {
  private var content: Content

  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Spacer()
          .frame(width: 16)
        content
        Spacer()
          .frame(width: 16)
      }
      Spacer()
        .frame(height: 5)
    }
    .separator()
  }
}
