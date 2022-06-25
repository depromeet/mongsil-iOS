//
//  CategoryItem.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/21.
//

import SwiftUI
import NukeUI

public struct CategoryItem: View {
  var image: String
  var name: String
  var isSelected: Bool

  init(image: String, name: String, isSelected: Bool) {
    self.image = image
    self.name = name
    self.isSelected = isSelected
  }

  public var body: some View {
    VStack(spacing: 2) {

      LazyImage(url: image) { state in
        if let image = state.image {
          image
            .resizingMode(.fill)
            .scaledToFit()
        } else {
          R.CustomImage.cardResultDefaultImage.image
            .resizedToFill()
            .scaledToFit()
        }
      }
      .padding(.horizontal, 10)
      .padding(.top, 10)

      Text(name)
        .foregroundColor(isSelected ? .msYellow : .gray4)
        .font(.caption1)
        .padding(.bottom, 6)
    }
    .backgroundColor(isSelected ? .gray9 : .clear)
    .cornerRadius(8)
    .frame(height: 76)
  }
}
