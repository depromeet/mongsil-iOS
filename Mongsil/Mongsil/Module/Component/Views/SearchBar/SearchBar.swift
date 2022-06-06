//
//  SearchBar.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/06/06.
//

import SwiftUI

public struct SearchBar: View {
  @Binding public var text: String
  @Binding public var isSearched: Bool
  @Binding public var isTextInputed: Bool
  public var backbuttonAction: () -> Void = {}
  public var removeButtonAction: () -> Void = {}
  public var searchButtonAction: () -> Void = {}

  public init(
    text: Binding<String> = .constant(""),
    isSearched: Binding<Bool> = .constant(false),
    isTextInputed: Binding<Bool> = .constant(false),
    backbuttonAction: @escaping () -> Void = {},
    removeButtonAction: @escaping () -> Void = {},
    searchButtonAction: @escaping () -> Void = {}
  ) {
    self._text = text
    self._isSearched = isSearched
    self._isTextInputed = isTextInputed
    self.backbuttonAction = backbuttonAction
    self.removeButtonAction = removeButtonAction
    self.searchButtonAction = searchButtonAction
  }

  public var body: some View {
    HStack(alignment: .center, spacing: 0) {
      Button(action: backbuttonAction) {
        R.CustomImage.backIcon.image
      }
      Spacer()
        .frame(width: 10)
      HStack(alignment: .center, spacing: 0) {
        Spacer()
          .frame(width: 8)
        TextField("", text: $text)
          .foregroundColor(.gray2)
          .placeholder(
            when: text.isEmpty,
            placeholder: {
              Text("궁금한 꿈의 키워드를 검색하세요")
                .foregroundColor(.gray6)
            }
          )
          .font(.caption1)
          .frame(maxWidth: .infinity)
        if isTextInputed {
          Button(action: removeButtonAction) {
            R.CustomImage.cancelSmallIcon.image
          }
        }
        if !isSearched {
          Spacer()
            .frame(width: 8)
          Button(action: searchButtonAction) {
            R.CustomImage.searchIcon.image
          }
        }
        Spacer()
          .frame(width: 8)
      }
      .frame(height: 36)
      .background(Color.gray9)
      .clipShape(
        RoundedRectangle(
          cornerRadius: 8,
          style: .continuous
        )
      )
    }
  }
}
