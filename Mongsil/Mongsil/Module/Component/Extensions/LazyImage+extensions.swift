//
//  LazyImage+extensions.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/22.
//

import Foundation
import NukeUI
import SwiftUI

extension LazyImage {
  public init(url: String, @ViewBuilder content: @escaping (LazyImageState) -> Content) {
    self.init(source: url.decodeURL(), content: content)
  }
}
