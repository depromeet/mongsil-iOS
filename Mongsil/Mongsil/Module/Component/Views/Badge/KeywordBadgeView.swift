//
//  KeywordBadgeView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/09.
//

import SwiftUI

public struct KeywordBadgeView: View {
  public let keywordTitle: String
  public let isSelected: Bool

  public init(_ keywordTitle: String, isSelected: Bool = false) {
    self.keywordTitle = keywordTitle
    self.isSelected = isSelected
  }

  public var body: some View {
    Text(keywordTitle)
      .lineLimit(1)
      .font(.caption1)
      .foregroundColor(.gray2)
      .padding(.vertical, 8)
      .padding(.horizontal, 14)
      .frame(minWidth: 51)
      .background(isSelected ? Color.gray8 : .clear)
      .cornerRadius(17)
      .overlay(
        RoundedRectangle(cornerRadius: 17)
          .stroke(Color.gray8, lineWidth: 1)
      )
  }
}
