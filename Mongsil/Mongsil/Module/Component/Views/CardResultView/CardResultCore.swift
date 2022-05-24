//
//  CardResultCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/21.
//

import Combine
import ComposableArchitecture
import SwiftUI

public struct CardResultState: Equatable {
  var isModifyAndDeleteSheetPresented: Bool = false
  var isShareViewPresented: Bool = false
  var totalImage: UIImage?

  init(
    isModifyAndDeleteSheetPresented: Bool = false,
    isShareViewPresented: Bool = false
  ) {
    self.isModifyAndDeleteSheetPresented = isModifyAndDeleteSheetPresented
    self.isShareViewPresented = isShareViewPresented
  }
}

public enum CardResultAction {
  case onAppear
  case bottomImageButtonTapped(CardResult)
  case bottomTitleButtonTapped(CardResult)
  case setModifyAndDeleteSheetPresented(Bool)
  case setShareViewPresented(Bool)
  case modifyDiaryButtonTapped
  case removeDiaryButtonTapped
  case moveDream
  case deleteDream
  case saveDream
}

public struct CardResultEnvironment {
}

public let cardResultReducer = Reducer<WithSharedState<CardResultState>, CardResultAction, CardResultEnvironment> {
  state, action, _ in
  switch action {
  case .onAppear:
    state.local.totalImage = snapshot()
    return .none

  case let .bottomImageButtonTapped(cardType):
    if cardType == .diary {
      return Effect(value: .setModifyAndDeleteSheetPresented(true))
    }
    return Effect(value: .setShareViewPresented(true))

  case let .bottomTitleButtonTapped(cardType):
    switch cardType {
    case .diary:
      return Effect(value: .moveDream)
    case .dreamForDelete:
      return Effect(value: .deleteDream)
    case .dreamForSave:
      return Effect(value: .saveDream)
    }

  case let .setModifyAndDeleteSheetPresented(presented):
    state.local.isModifyAndDeleteSheetPresented = presented
    return .none

  case let .setShareViewPresented(presented):
    state.local.isShareViewPresented = presented
    return .none

  case .modifyDiaryButtonTapped:
    return Effect(value: .setModifyAndDeleteSheetPresented(false))

  case .removeDiaryButtonTapped:
    return Effect(value: .setModifyAndDeleteSheetPresented(false))

  case .moveDream:
    return .none

  case .deleteDream:
    return .none

  case .saveDream:
    return .none
  }
}

private func snapshot() -> UIImage {
  var totalImage: UIImage?

  let keyWindow = UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .flatMap { $0.windows }
    .first { $0.isKeyWindow }
  guard let currentLayer = keyWindow?.layer else {
    return UIImage()
  }

  let currentScale = UIScreen.main.scale
  UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale)

  guard let currentContext = UIGraphicsGetCurrentContext() else { return UIImage() }
  currentLayer.render(in: currentContext)

  totalImage = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  return totalImage ?? UIImage()
}
