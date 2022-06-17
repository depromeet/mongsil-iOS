//
//  VerbKeywordItem.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/21.
//

import SwiftUI

public struct VerbKeywordItem: View {
  @State var name: String
  @State var categoryCount: Int

  public var body: some View {
    HStack(alignment: .center, spacing: 0) {
      Text(name)
        .padding(.trailing, 4)
        .foregroundColor(.gray2)
        .font(.body2)
      Text("\(categoryCount)")
        .foregroundColor(.gray8)
        .font(.button)
      Spacer()
    }
    .padding(.vertical, 15)
    .padding(.horizontal, 20)
    .height(56)
  }
}
