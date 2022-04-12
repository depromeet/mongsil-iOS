//
//  RightButton.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import SwiftUI

public struct RightButton: View {
  public var titleText: String
  public var action: () -> Void

  public init(
    titleText: String,
    action: @escaping () -> Void
  ) {
    self.titleText = titleText
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      Text(titleText)
        .font(.title1)
        .foregroundColor(.gray1)
    }
  }
}
