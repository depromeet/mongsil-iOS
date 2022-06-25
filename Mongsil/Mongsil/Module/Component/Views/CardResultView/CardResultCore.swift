//
//  CardResultCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/21.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct CardResultState: Equatable {
  var isModifyAndDeleteSheetPresented: Bool = false
  var isShareViewPresented: Bool = false
  var isRecordPushed: Bool = false
  var totalImage: UIImage?

  // Child State
  var record: RecordState?

  init(
    isModifyAndDeleteSheetPresented: Bool = false,
    isShareViewPresented: Bool = false
  ) {
    self.isModifyAndDeleteSheetPresented = isModifyAndDeleteSheetPresented
    self.isShareViewPresented = isShareViewPresented
  }
}

enum CardResultAction {
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

  case setRecordPushed(Bool)

  // Child Action
  case record(RecordAction)
}

struct CardResultEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let diaryService: DiaryService
  let dreamService: DreamService
}

let cardResultReducer = Reducer.combine([
  recordReducer
    .optional()
    .pullback(
      state: \.record,
      action: /CardResultAction.record,
      environment: { RecordEnvironment(mainQueue: $0.mainQueue, diaryService: $0.diaryService, dreamService: $0.dreamService) }
    ) as Reducer<WithSharedState<CardResultState>, CardResultAction, CardResultEnvironment>,
  Reducer<WithSharedState<CardResultState>, CardResultAction, CardResultEnvironment> {
    state, action, _ in
    switch action {
    case .onAppear:
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
      state.local.totalImage = snapshot()
      state.local.isShareViewPresented = presented
      return .none

    case .modifyDiaryButtonTapped:
      return Effect.merge([
        Effect(value: .setRecordPushed(true)),
        Effect(value: .setModifyAndDeleteSheetPresented(false))
      ])

    case .removeDiaryButtonTapped:
      return Effect(value: .setModifyAndDeleteSheetPresented(false))

    case .record(.backButtonTapped):
      return Effect(value: .setRecordPushed(false))

    case .moveDream:
      return .none

    case .deleteDream:
      return .none

    case .saveDream:
      return .none

    case .setRecordPushed:
      return .none

    case .record:
      return .none
    }
  }
])

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
