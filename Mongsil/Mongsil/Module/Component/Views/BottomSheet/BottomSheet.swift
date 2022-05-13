//
//  BottomSheet.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/12.
//

import SwiftUI

public struct BottomSheet<Content: View, BottomArea: View>: View {
  public var title: String
  @Binding public var isPresented: Bool
  public var content: Content
  public var bottomArea: BottomArea

  public let keyWindow = UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .flatMap { $0.windows }
    .first { $0.isKeyWindow }

  public init(
    title: String,
    isPresented: Binding<Bool>,
    @ViewBuilder content: () -> Content,
    @ViewBuilder bottomArea: () -> BottomArea
  ) {
    self.title = title
    self._isPresented = isPresented
    self.content = content()
    self.bottomArea = bottomArea()
  }

  public var body: some View {
    VStack(spacing: 0) {
      HeaderView(title: title)
        .padding(.top, 10)

      content
        .padding(.top, 20)

      bottomArea
        .padding(.horizontal, 20)
        .padding(.top, 20)

      Rectangle()
        .foregroundColor(.gray9)
        .frame(height: keyWindow?.safeAreaInsets.bottom)
    }
    .background(Color.gray9.cornerRadius(20, corners: [.topLeft, .topRight]))
    .padding(.top, 32)
    .clipped()
  }
}

private struct HeaderView: View {
  var title: String

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Spacer()
        Rectangle()
          .foregroundColor(.gray3)
          .frame(width: 40, height: 4)
        Spacer()
      }
      HStack {
        Spacer()
        Text(title)
          .font(.subTitle)
          .foregroundColor(.msWhite)
        Spacer()
      }
      .padding(.top, 18)
    }
  }
}

extension View {
  public func bottomSheet<Content: View, BottomArea: View>(
    title: String,
    isPresented: Binding<Bool>,
    @ViewBuilder content: () -> Content,
    @ViewBuilder bottomArea: () -> BottomArea
  ) -> some View {
    ZStack(alignment: .bottom) {
      self

      if isPresented.wrappedValue {
        Color.black.opacity(0.8)
          .ignoresSafeArea(.container, edges: .all)
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.25)))
          .zIndex(1)
          .onTapGesture {
            isPresented.wrappedValue = false
          }

        BottomSheet(
          title: title,
          isPresented: isPresented,
          content: content,
          bottomArea: bottomArea
        )
        .zIndex(2)
        .animation(.easeInOut, value: 0.25)
      }
    }
    .edgesIgnoringSafeArea(.bottom)
  }
}
