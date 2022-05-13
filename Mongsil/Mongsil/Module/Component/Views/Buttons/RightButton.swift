//
//  RightButton.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import SwiftUI

public struct RightButton: View {
  public var text: String?
  public var image: Image?
  public var action: () -> Void

  public init(
    text: String? = nil,
    image: Image? = nil,
    action: @escaping () -> Void
  ) {
    self.text = text
    self.image = image
    self.action = action
  }

  public var body: some View {
    if let text = text {
      RightButtonWithText(
        text: text,
        action: action
      )
    }
    if let image = image {
      RightButtonWithImage(
        image: image,
        action: action
      )
    }
  }
}

private struct RightButtonWithText: View {
  var text: String
  var action: () -> Void

  init(
    text: String,
    action: @escaping () -> Void
  ) {
    self.text = text
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      Text(text)
        .font(.title1)
        .foregroundColor(.gray2)
        .padding(.trailing, 10)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
  }
}

private struct RightButtonWithImage: View {
  var image: Image
  var action: () -> Void

  init(
    image: Image,
    action: @escaping () -> Void
  ) {
    self.image = image
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      image
    }
  }
}
