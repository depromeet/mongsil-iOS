//
//  NounKeywordItem.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/21.
//

import SwiftUI
import NukeUI

public struct NounKeywordItem: View {
  @State var name: String
  @State var image: String
  @State var categoryCount: Int
  @State var isActive: Bool

  let tappedAction: () -> Void

  public var body: some View {
    Button(
      action: tappedAction,
      label: {
        HStack(spacing: 0) {
          HStack(alignment: .center, spacing: 0) {

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
            .frame(width: 18, height: 18)
            .padding(.trailing, 10)

            Text(name)
              .padding(.trailing, 4)
              .foregroundColor(.gray2)
              .font(.body2)
            Text("\(categoryCount)")
              .foregroundColor(.gray8)
              .font(.button)
          }

          Spacer()

          isActive ? R.CustomImage.arrowUpIcon.image : R.CustomImage.arrowDownIcon.image
        }
      }
    )
    .padding(.vertical, 15)
    .padding(.horizontal, 20)
    .height(56)
  }
}
