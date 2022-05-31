//
//  UINavigationController+extensions.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/16.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }

  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}

public func popToRoot() {
  let window = UIApplication.shared.connectedScenes
    .filter { $0.activationState == .foregroundActive }
    .map { $0 as? UIWindowScene }
    .compactMap { $0 }
    .first?.windows
    .filter { $0.isKeyWindow }
    .first

  let profile = window?.rootViewController?.children.first as? UINavigationController

  profile?.popToRootViewController(animated: true)
}
