//
//  DiaryCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/11.
//

import Combine
import ComposableArchitecture

struct DiaryState: Equatable {
  var userDiary: Diary

  // Child State
  var cardResult: CardResultState = .init()
  var requestDeleteDiaryAlertModal: AlertDoubleButtonState?

  init(
    userDiary: Diary,
    cardResult: CardResultState = .init(),
    requestDeleteDiaryAlertModal: AlertDoubleButtonState? = nil
  ) {
    self.userDiary = userDiary
    self.cardResult = cardResult
    self.requestDeleteDiaryAlertModal = requestDeleteDiaryAlertModal
  }
}

enum DiaryAction {
  case backButtonTapped

  // Child Action
  case cardResult(CardResultAction)
  case requestDeleteDiaryAlertModal(AlertDoubleButtonAction)
}

struct DiaryEnvironment {
}

let diaryReducer: Reducer<WithSharedState<DiaryState>, DiaryAction, DiaryEnvironment> =
Reducer.combine([
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.requestDeleteDiaryAlertModal,
      action: /DiaryAction.requestDeleteDiaryAlertModal,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    )
  as Reducer<WithSharedState<DiaryState>, DiaryAction, DiaryEnvironment>,
  cardResultReducer
    .pullback(
      state: \.cardResult,
      action: /DiaryAction.cardResult,
      environment: { _ in
        CardResultEnvironment()
      }
    )
  as Reducer<WithSharedState<DiaryState>, DiaryAction, DiaryEnvironment>,
  Reducer<WithSharedState<DiaryState>, DiaryAction, DiaryEnvironment> {
    state, action, _ in
    switch action {
    case .backButtonTapped:
      return .none

    case .cardResult(.modifyDiaryButtonTapped):
      // MARK: - 기록하기 편집 화면 이동 필요
      return Effect(value: .backButtonTapped)

    case .cardResult(.removeDiaryButtonTapped):
      return setAlertModal(
        state: &state.local.requestDeleteDiaryAlertModal,
        titleText: "꿈 일기를 삭제할까요?",
        bodyText: "삭제하면 다시 복구할 수 없어요.",
        secondaryButtonTitle: "아니요",
        primaryButtonTitle: "삭제하기",
        primaryButtonHierachy: .warning
      )

    case .cardResult(.moveDream):
      // MARK: - 꿈카드 결과 화면 이동 필요
      return Effect(value: .backButtonTapped)

    case .cardResult:
      return .none

    case .requestDeleteDiaryAlertModal(.primaryButtonTapped):
      // MARK: - 꿈 일기 삭제 API 호출 필요
      state.local.requestDeleteDiaryAlertModal = nil
      return Effect(value: .backButtonTapped)

    case .requestDeleteDiaryAlertModal(.secondaryButtonTapped):
      state.local.requestDeleteDiaryAlertModal = nil
      return .none

    case .requestDeleteDiaryAlertModal:
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
) -> Effect<DiaryAction, Never> {
  state = .init(
    title: titleText,
    body: bodyText,
    secondaryButtonTitle: secondaryButtonTitle,
    primaryButtonTitle: primaryButtonTitle,
    primaryButtonHierachy: primaryButtonHierachy
  )
  return .none
}
