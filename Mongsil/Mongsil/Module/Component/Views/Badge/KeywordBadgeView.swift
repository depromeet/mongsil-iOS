//
//  KeywordBadgeView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/09.
//

import SwiftUI

public struct KeywordBadgeView: View {
  public let keywordTitle: String

  public init(_ keywordTitle: String) {
    self.keywordTitle = keywordTitle
  }

  public var body: some View {
    Text(keywordTitle)
      .font(.caption1)
      .foregroundColor(.gray2)
      .padding(.vertical, 8)
      .padding(.horizontal, 14)
      .background(Color.gray10)
      .cornerRadius(17)
      .overlay(
        RoundedRectangle(cornerRadius: 17)
          .stroke(Color.gray8, lineWidth: 1)
      )
  }
}
