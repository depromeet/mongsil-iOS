//
//  MSNavigationBar.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import SwiftUI

public struct MSNavigationBar: View {
  public var titleText: String?
  public var backButtonAction: () -> Void = {}
  public var rightButtonText: String?
  public var rightButtonAction: () -> Void = {}
//  public var rightButtonImageText: String?

  public init(
    titleText: String? = nil,
    backButtonAction: @escaping () -> Void = {},
    rightButtonText: String? = nil,
    rightButtonAction: @escaping () -> Void = {}
//    rightButtonImageText: String? = nil
  ) {
    self.titleText = titleText
    self.backButtonAction = backButtonAction
    self.rightButtonText = rightButtonText
    self.rightButtonAction = rightButtonAction
//    self.rightButtonImageText = rightButtonImageText
  }

  public var body: some View {
    ZStack {
      HStack(alignment: .center) {
        Spacer()
        Text(titleText ?? "")
          .font(.title1)
        Spacer()
      }
      HStack {
        BackButton(action: backButtonAction)
          .frame(height: 40, alignment: .bottom)
        Spacer()
        if let rightButtonText = rightButtonText {
          RightButton(
            titleText: rightButtonText,
            action: rightButtonAction
//            rightButtonImageText: rightButtonImageText ?? ""
          )
          .frame(height: 40)
          .padding(.trailing, 16)
        }
      }
    }
  }
}
