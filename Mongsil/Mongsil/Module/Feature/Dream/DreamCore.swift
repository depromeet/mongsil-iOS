//
//  DreamCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/11.
//

import Combine
import ComposableArchitecture

struct DreamState: Equatable {
  var userDreamCardResult: UserDreamCardResult

  // Child State
  var cardResult: CardResultState = .init()
  var requestDeleteDreamAlertModal: AlertDoubleButtonState?
  var requestSaveDreamAlertModal: AlertDoubleButtonState?

  init(
    userDreamCardResult: UserDreamCardResult,
    cardResult: CardResultState = .init(),
    requestDeleteDreamAlertModal: AlertDoubleButtonState? = nil,
    requestSaveDreamAlertModal: AlertDoubleButtonState? = nil
  ) {
    self.userDreamCardResult = userDreamCardResult
    self.cardResult = cardResult
    self.requestDeleteDreamAlertModal = requestDeleteDreamAlertModal
    self.requestSaveDreamAlertModal = requestSaveDreamAlertModal
  }
}

extension DreamState {
  struct UserDreamCardResult: Equatable {
    var userDream: UserDream
    var imageURLs: [String]
    var keywords: [String]

    init(userDream: UserDream) {
      self.userDream = userDream
      self.imageURLs = userDream.categoryList.map { $0.image }
      self.keywords = userDream.categoryList.map { $0.name }
    }
  }
}

enum DreamAction {
  case backButtonTapped

  // Child Action
  case cardResult(CardResultAction)
  case requestDeleteDreamAlertModal(AlertDoubleButtonAction)
  case requestSaveDreamAlertModal(AlertDoubleButtonAction)
}

struct DreamEnvironment {
}

let dreamReducer: Reducer<WithSharedState<DreamState>, DreamAction, DreamEnvironment> =
Reducer.combine([
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.requestDeleteDreamAlertModal,
      action: /DreamAction.requestDeleteDreamAlertModal,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    )
  as Reducer<WithSharedState<DreamState>, DreamAction, DreamEnvironment>,
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.requestSaveDreamAlertModal,
      action: /DreamAction.requestSaveDreamAlertModal,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    )
  as Reducer<WithSharedState<DreamState>, DreamAction, DreamEnvironment>,
  cardResultReducer
    .pullback(
      state: \.cardResult,
      action: /DreamAction.cardResult,
      environment: { _ in
        CardResultEnvironment()
      }
    )
  as Reducer<WithSharedState<DreamState>, DreamAction, DreamEnvironment>,
  Reducer<WithSharedState<DreamState>, DreamAction, DreamEnvironment> {
    state, action, _ in
    switch action {
    case .backButtonTapped:
      return .none

    case .cardResult(.deleteDream):
      return setAlertModal(
        state: &state.local.requestDeleteDreamAlertModal,
        titleText: "해몽을 삭제할까요?",
        bodyText: "삭제해도 다시 검색해서 찾아볼 수 있어요.",
        secondaryButtonTitle: "아니요",
        primaryButtonTitle: "삭제하기",
        primaryButtonHierachy: .warning
      )

    case .cardResult(.saveDream):
      // 해몽 저장 API 호출 필요
      return setAlertModal(
        state: &state.local.requestSaveDreamAlertModal,
        titleText: "해몽을 저장했어요!",
        bodyText: "저장된 해몽은 언제든지 보관함에서 꺼내볼 수 있어요.",
        secondaryButtonTitle: "보관함 가기",
        primaryButtonTitle: "닫기"
      )

    case .cardResult:
      return .none

    case .requestDeleteDreamAlertModal(.primaryButtonTapped):
      // 해몽 삭제 API 호출 필요
      state.local.requestDeleteDreamAlertModal = nil
      return Effect(value: .backButtonTapped)

    case .requestDeleteDreamAlertModal(.secondaryButtonTapped):
      state.local.requestDeleteDreamAlertModal = nil
      return .none

    case .requestSaveDreamAlertModal(.primaryButtonTapped):
      state.local.requestSaveDreamAlertModal = nil
      return .none

    case .requestSaveDreamAlertModal(.secondaryButtonTapped):
      // 보관함 가기 로직 구현
      state.local.requestSaveDreamAlertModal = nil
      return .none

    case .requestDeleteDreamAlertModal:
      return .none

    case .requestSaveDreamAlertModal:
      return .none
    }
  }
])

private func setAlertModal(
  state: inout AlertDoubleButtonState?,
  titleText: String? = nil,
  bodyText: String,
  secondaryButtonTitle: String,
  primaryButtonTitle: String,
  primaryButtonHierachy: AlertButton.Hierarchy = .primary
) -> Effect<DreamAction, Never> {
  state = .init(
    title: titleText,
    body: bodyText,
    secondaryButtonTitle: secondaryButtonTitle,
    primaryButtonTitle: primaryButtonTitle,
    primaryButtonHierachy: primaryButtonHierachy
  )
  return .none
}
