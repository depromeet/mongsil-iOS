//
//  LottieView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/07/09.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
  private let animation: String

  init(
    animation: String
  ) {
    self.animation = animation
  }

  func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
    let view = UIView(frame: .zero)
    let animationView = AnimationView()

    animationView.animation = Animation.named(animation)
    animationView.frame = view.bounds

    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.animationSpeed = 2
    view.addSubview(animationView)

    animationView.play()

    NSLayoutConstraint.activate([
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
    ])
    animationView.translatesAutoresizingMaskIntoConstraints = false

    return view
  }

  func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
  }
}
