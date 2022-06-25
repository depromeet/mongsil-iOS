//
//  KeywordClibView.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/08.
//

import Foundation
import SwiftUI

public struct KeywordClibView: View {
  public let title: String
  public let cancelTappedAction: () -> Void

  public init(_ title: String, cancelTappedAction: @escaping () -> Void) {
    self.title = title
    self.cancelTappedAction = cancelTappedAction
  }

  public var body: some View {
    HStack(spacing: 4) {
      Text(title)
        .font(.caption1)
        .foregroundColor(.gray4)
      Button(action: cancelTappedAction) {
        R.CustomImage.cancelSmallIcon.image
      }
    }
    .padding(.vertical, 5)
    .padding(.leading, 14)
    .padding(.trailing, 4)
    .background(Color.gray8)
    .cornerRadius(17)
  }
}
