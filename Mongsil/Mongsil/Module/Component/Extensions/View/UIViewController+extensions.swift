//
//  UIViewController+extensions.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/29.
//

import SwiftUI

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
