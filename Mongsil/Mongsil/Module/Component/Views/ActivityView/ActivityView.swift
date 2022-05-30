//
//  ActivityView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/22.
//

import SwiftUI

public struct ActivityView: UIViewControllerRepresentable {
  @Binding var isPresented: Bool
  public let applicationActivities: [UIActivity]? = nil
  public var image: UIImage?

  public func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }

  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    guard let image = image else { return }
    let activityViewController = UIActivityViewController(
      activityItems: [image as Any],
      applicationActivities: applicationActivities
    )

    if isPresented && uiViewController.presentedViewController == nil {
      uiViewController.present(activityViewController, animated: true)
    }

    activityViewController.completionWithItemsHandler = { (_, _, _, _) in
      isPresented = false
    }
  }
}
