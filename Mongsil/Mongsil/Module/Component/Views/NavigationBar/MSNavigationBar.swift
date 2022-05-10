//
//  MSNavigationBar.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import SwiftUI

public struct MSNavigationBar: View {
  public var titleText: String?
  public var isUseBackButton: Bool
  public var backButtonAction: () -> Void = {}
  public var rightButtonText: String?
  public var rightButtonImage: Image?
  public var rightButtonAction: () -> Void = {}

  public init(
    titleText: String? = nil,
    isUseBackButton: Bool = true,
    backButtonAction: @escaping () -> Void = {},
    rightButtonText: String? = nil,
    rightButtonImage: Image? = nil,
    rightButtonAction: @escaping () -> Void = {}
  ) {
    self.titleText = titleText
    self.isUseBackButton = isUseBackButton
    self.backButtonAction = backButtonAction
    self.rightButtonText = rightButtonText
    self.rightButtonImage = rightButtonImage
    self.rightButtonAction = rightButtonAction
  }

  public var body: some View {
    ZStack {
      HStack(alignment: .center) {
        Spacer()
        Text(titleText ?? "")
          .font(.subTitle)
          .foregroundColor(.gray2)
        Spacer()
      }
      HStack {
        if isUseBackButton {
          BackButton(action: backButtonAction)
            .frame(height: 44, alignment: .bottom)
        }
        Spacer()
        if let rightButtonText = rightButtonText {
          RightButton(
            text: rightButtonText,
            action: rightButtonAction
          )
          .frame(height: 44)
          .padding(.trailing, 20)
        }
        if let rightButtonImage = rightButtonImage {
          RightButton(
            image: rightButtonImage,
            action: rightButtonAction
          )
          .frame(height: 44)
          .padding(.trailing, 20)
        }
      }
    }
  }
}
