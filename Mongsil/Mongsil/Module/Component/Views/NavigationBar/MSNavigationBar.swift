//
//  MSNavigationBar.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import SwiftUI

public struct MSNavigationBar: View {
  public var backButtonImage: Image?
  public var backButtonAction: () -> Void = {}
  public var titleText: String = ""
  public var titleSubImage: Image?
  public var isButtonTitle: Bool = false
  public var titleButtonAction: () -> Void = {}
  public var rightButtonText: String?
  public var rightButtonImage: Image?
  public var rightButtonAction: () -> Void = {}
  public var displayTitle: Bool
  @Binding public var rightButtonAbled: Bool

  public init(
    backButtonImage: Image? = nil,
    backButtonAction: @escaping () -> Void = {},
    titleText: String = "",
    titleSubImage: Image? = nil,
    isButtonTitle: Bool = false,
    titleButtonAction: @escaping () -> Void = {},
    rightButtonText: String? = nil,
    rightButtonImage: Image? = nil,
    rightButtonAction: @escaping () -> Void = {},
    displayTitle: Bool = true,
    rightButtonAbled: Binding<Bool> = .constant(true)
  ) {
    self.backButtonImage = backButtonImage
    self.backButtonAction = backButtonAction
    self.titleText = titleText
    self.titleSubImage = titleSubImage
    self.isButtonTitle = isButtonTitle
    self.titleButtonAction = titleButtonAction
    self.rightButtonText = rightButtonText
    self.rightButtonImage = rightButtonImage
    self.rightButtonAction = rightButtonAction
    self.displayTitle = displayTitle
    self._rightButtonAbled = rightButtonAbled
  }

  public var body: some View {
    HStack(alignment: .center, spacing: 0) {
      HStack(spacing: 0) {
        if backButtonImage != nil {
          Button(action: backButtonAction) {
            backButtonImage?
              .renderingMode(.template)
              .foregroundColor(.gray2)
          }
        }
        Spacer()
      }
      .frame(width: 40)

      HStack(spacing: 0) {
        Spacer()
        if displayTitle {
          if isButtonTitle {
            Button(action: titleButtonAction) {
              HStack(spacing: 0) {
                Text(titleText)
                  .font(.subTitle)
                  .foregroundColor(.gray2)
                if titleSubImage != nil {
                  Spacer()
                    .frame(width: 4)
                  titleSubImage?
                    .renderingMode(.template)
                    .foregroundColor(.gray2)
                }
              }
            }
          } else {
            Text(titleText)
              .font(.subTitle)
              .foregroundColor(.gray2)
          }
          Spacer()
        }
      }

      HStack(spacing: 0) {
        Spacer()
        if rightButtonText != nil {
          Button(action: rightButtonAction) {
            Text(rightButtonText ?? "")
              .font(.button)
              .foregroundColor(rightButtonAbled ? .gray2 : .gray8)
          }
          .disabled(!rightButtonAbled)
        }
        if rightButtonImage != nil {
          Button(action: rightButtonAction) {
            rightButtonImage?
              .renderingMode(.template)
              .foregroundColor(rightButtonAbled ? .gray2 : .gray8)
          }
        }
      }
      .frame(width: 40)
    }
    .frame(height: 44)
  }
}
