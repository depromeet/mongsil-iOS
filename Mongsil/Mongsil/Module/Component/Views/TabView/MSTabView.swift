//
//  MSTabView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/27.
//

import SwiftUI

public struct MSTabView<Selection>: View where Selection: Hashable & Identifiable & Comparable {
  public var activeIcons: [Selection: Image]
  public var disabledIcons: [Selection: Image]
  public var views: [Selection: AnyView]

  @Binding public var selection: Selection

  public init(
    activeIcons: [Selection: Image],
    disabledIcons: [Selection: Image],
    views: [Selection: AnyView],
    selection: Binding<Selection>
  ) {
    self.activeIcons = activeIcons
    self.disabledIcons = disabledIcons
    self.views = views
    self._selection = selection
  }

  public var body: some View {
    GeometryReader { geometry in
      ZStack {
        VStack(spacing: 0) {
          views[selection]
          Spacer(minLength: 0)
        }
        VStack {
          Spacer()
          HStack(spacing: 0) {
            ForEach(
              views.keys.sorted(),
              content: { key in
                if let activeIcon = activeIcons[key],
                   let disabledIcon = disabledIcons[key] {
                  MSTab(
                    activeIcon: activeIcon,
                    disabledIcon: disabledIcon,
                    selected: selection == key,
                    action: { selection = key }
                  )
                }
              }
            )
          }
          .cornerRadius(20)
          .overlay(
            RoundedRectangle(20)
              .stroke(Color.gray8, lineWidth: 1)
              .frame(
                width: geometry.width + 1,
                height: geometry.height + 1
              ),
            alignment: .top
          )
        }
      }
      .ignoresSafeArea(.container, edges: .bottom)
    }
    .ignoresSafeArea(.keyboard, edges: .bottom)
  }
}

private struct MSTab: View {
  var activeIcon: Image
  var disabledIcon: Image
  var selected: Bool
  var action: () -> Void

  let keyWindow = UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .flatMap { $0.windows }
    .first { $0.isKeyWindow }

  var body: some View {
    Button(action: action) {
      VStack {
        Spacer()
          .frame(height: 16)
        selected ? activeIcon : disabledIcon
        Spacer()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: 56)
    .padding(.bottom, keyWindow?.safeAreaInsets.bottom)
    .background(Color.msTabBar)
  }
}
