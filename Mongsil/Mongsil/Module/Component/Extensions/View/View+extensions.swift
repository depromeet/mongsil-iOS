//
//  View+extensions.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import SwiftUI
import Combine

extension View {
  public func `if`<Content: View>(
    _ conditional: Bool,
    content: (Self) -> Content
  ) -> some View {
    if conditional {
      return content(self).eraseToAnyView()
    } else {
      return self.eraseToAnyView()
    }
  }
  
  public func apply<Content: View>(content: (Self) -> Content) -> AnyView {
    return content(self).eraseToAnyView()
  }
  
  public func eraseToAnyView() -> AnyView {
    return AnyView(self)
  }
  
  public func shadow(
    color: Color,
    x: CGFloat,
    y: CGFloat,
    blur: CGFloat,
    spread: CGFloat
  ) -> some View {
    let radius = blur / 2.0
    let spreadedX = x + spread
    let spreadedY = y + spread
    return shadow(
      color: color,
      radius: radius,
      x: spreadedX,
      y: spreadedY
    )
  }
  
  public func cornerRadius(
    _ radius: CGFloat,
    corners: UIRectCorner
  ) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
  
  public func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content) -> some View {
      
      ZStack(alignment: alignment) {
        placeholder().opacity(shouldShow ? 1 : 0)
        self
      }
    }
}

public struct RoundedCorner: Shape {
  public var radius: CGFloat = .infinity
  public var corners: UIRectCorner = .allCorners
  
  public func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

extension View {
  public func hideKeyboard() {
    let resign = #selector(UIResponder.resignFirstResponder)
    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
  }
}

extension View {
  public func onKeyboard(_ keyboardYOffset: Binding<CGFloat>) -> some View {
    return ModifiedContent(content: self, modifier: KeyboardModifier(keyboardYOffset))
  }
}

struct KeyboardModifier: ViewModifier {
  @Binding var keyboardYOffset: CGFloat
  let keyboardWillAppearPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
  let keyboardWillHidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
  
  init(_ offset: Binding<CGFloat>) {
    _keyboardYOffset = offset
  }
  
  func body(content: Content) -> some View {
    let anumationValue = 0
    return content.offset(x: 0, y: -$keyboardYOffset.wrappedValue)
      .animationIf(true)
      .animation(.easeInOut(duration: 0.35), value: anumationValue)
      .onReceive(keyboardWillAppearPublisher) { notification in
        _ = UIApplication.shared.connectedScenes
          .filter { $0.activationState == .foregroundActive }
          .map { $0 as? UIWindowScene }
          .compactMap { $0 }
          .first?.windows
          .filter { $0.isKeyWindow }
          .first
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        self.$keyboardYOffset.wrappedValue = (keyboardFrame.height)
      }.onReceive(keyboardWillHidePublisher) { _ in
        self.$keyboardYOffset.wrappedValue = 0
      }
  }
}

struct AdaptsToKeyboard: ViewModifier {
  @State var currentHeight: CGFloat = 0
  
  func body(content: Content) -> some View {
    GeometryReader { geometry in
      content
        .padding(.bottom, self.currentHeight)
        .onAppear(perform: {
          NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
            .compactMap { notification in
              withAnimation(.easeOut(duration: 0.16)) {
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
              }
            }
            .map { rect in
              rect.height - geometry.safeAreaInsets.bottom
            }
            .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
          
          NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
            .compactMap { notification in
              CGFloat.zero
            }
            .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
        })
    }
  }
}

extension View {
  func adaptsToKeyboard() -> some View {
    return modifier(AdaptsToKeyboard())
  }
}
