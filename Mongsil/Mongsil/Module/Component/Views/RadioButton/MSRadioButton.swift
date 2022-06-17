//
//  MSRadioButton.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/08.
//

import Foundation
import SwiftUI

public struct RadioButton: View {
  public let title: String
  @Binding private var isActive: Bool

  public init(_ title: String, isActive: Binding<Bool>) {
    self.title = title
    self._isActive = isActive
  }

  public var body: some View {
    Button(action: {
      isActive.toggle()
    }, label: {
      HStack {
        if isActive {
          R.CustomImage.checkIcon.image
        } else {
          R.CustomImage.nonCheckIcon.image
        }
        Text(title)
          .font(.caption1)
          .foregroundColor(.gray4)
      }
      .padding(.vertical, 7)
      .padding(.horizontal, 12)
      .background(Color.gray10)
      .cornerRadius(17)
    })
  }
}
