//
//  MSTabView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/27.
//

import SwiftUI

public struct MSTabView<Selection>: View where Selection: Hashable & Identifiable & Comparable {
  public var icons: [Selection: Image]
  public var titles: [Selection: String]
  public var views: [Selection: AnyView]
  
  @Binding public var selection: Selection
  
  public init(
    icons: [Selection: Image],
    titles: [Selection: String],
    views: [Selection: AnyView],
    selection: Binding<Selection>
  ) {
    self.icons = icons
    self.titles = titles
    self.views = views
    self._selection = selection
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      views[selection]
      
      Spacer(minLength: 0)
      
      HStack(spacing: 0) {
        ForEach(
          views.keys.sorted(),
          content: { key in
            if let icon = icons[key],
               let title = titles[key] {
              MSTab(
                icon: icon,
                title: title,
                selected: selection == key,
                action: { selection = key }
              )
            }
          }
        )
      }
    }
    .ignoresSafeArea(.container, edges: .bottom)
  }
}

private struct MSTab: View {
  var icon: Image
  var title: String
  var selected: Bool
  var action: () -> Void
  
  var backgroundColor: Color {
    selected ? .gray10 : .gray11
  }
  var foregroundColor: Color {
    selected ? .msWhite : .gray1
  }
  
  let keyWindow = UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .flatMap { $0.windows }
    .first { $0.isKeyWindow }
  
  var body: some View {
    Button(action: action) {
      VStack(spacing: 5) {
        icon
        Text(title)
          .font(.caption1)
      }
      .frame(maxWidth: .infinity, maxHeight: 50)
      .padding(.bottom, keyWindow?.safeAreaInsets.bottom)
      .background(backgroundColor)
      .foregroundColor(foregroundColor)
      .overlay(
        Rectangle().foregroundColor(.msWhite)
          .frame(height: 1),
        alignment: .top
      )
    }
  }
}
