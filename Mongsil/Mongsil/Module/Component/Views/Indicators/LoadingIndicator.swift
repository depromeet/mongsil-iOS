//
//  LoadingIndicator.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/18.
//

import PureSwiftUI

public struct LoadingIndicator: View, UIViewRepresentable {
  public var style: UIActivityIndicatorView.Style = .medium

  public init(style: UIActivityIndicatorView.Style = .medium) {
    self.style = style
  }

  public func makeUIView(context: Context) -> UIActivityIndicatorView {
    let view = UIActivityIndicatorView(style: style)
    view.startAnimating()
    return view
  }

  public func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
  }
}

extension View {
  public func overlayLoading(when loading: Bool) -> some View {
    return self.overlayIf(
      loading,
      Color.gray1.opacity(0.8)
        .overlay(LoadingIndicator())
    )
  }
}
