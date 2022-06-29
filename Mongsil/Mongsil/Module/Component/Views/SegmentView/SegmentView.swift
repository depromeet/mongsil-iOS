//
//  SegmentView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/10.
//

import SwiftUI

public struct SegmentView<Selection>: View where Selection: Hashable & Identifiable & Comparable {
  public var title: [Selection: String]
  public var views: [Selection: AnyView]

  @Binding public var selection: Selection

  public init(
    title: [Selection: String],
    views: [Selection: AnyView],
    selection: Binding<Selection>
  ) {
    self.title = title
    self.views = views
    self._selection = selection
  }

  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        ForEach(
          views.keys.sorted(),
          content: { key in
            if let title = title[key] {
              SegmentTab(
                title: title,
                selected: selection == key,
                action: { selection = key
                  hideKeyboard()
                }
              )
            }
          }
        )
      }

      views[selection]
    }
    .ignoresSafeArea(.container, edges: .all)
  }
}

private struct SegmentTab: View {
  var title: String
  var selected: Bool
  var action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 0) {
        Text(title)
          .font(.button)
          .foregroundColor(selected ? .gray2 : .gray8)
          .frame(maxWidth: .infinity, maxHeight: .infinity)

        if selected {
          Rectangle().frame(height: 1).foregroundColor(.gray3)
        }
      }.frame(maxWidth: .infinity, maxHeight: 44)
    }
  }
}
