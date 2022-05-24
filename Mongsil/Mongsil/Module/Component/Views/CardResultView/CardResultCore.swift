//
//  CardResultCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/21.
//

import Combine
import ComposableArchitecture

public struct CardResultState: Equatable {
  var isModifyAndDeleteSheetPresented: Bool = false
  var isShareViewPresented: Bool = false

  init(
    isModifyAndDeleteSheetPresented: Bool = false,
    isShareViewPresented: Bool = false
  ) {
    self.isModifyAndDeleteSheetPresented = isModifyAndDeleteSheetPresented
    self.isShareViewPresented = isShareViewPresented
  }
}

public enum CardResultAction {
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
