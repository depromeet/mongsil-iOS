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
  var isSingleKeyword: Bool {
    userDiary.categoryList.count < 2
  }
  var categoryImages: [String] {
    userDiary.categoryList.map({ $0.image })
  }
  var categoryKeywords: [String] {
    userDiary.categoryList.map({ $0.name })
  }

  // Child State
  var cardResult: CardResultState = .init()
  var requestDeleteDiaryAlertModal: AlertDoubleButtonState?
  var moveDreamAlertModal: AlertDoubleButtonState?

  init(
    userDiary: Diary,
    cardResult: CardResultState = .init(),
    requestDeleteDiaryAlertModal: AlertDoubleButtonState? = nil,
    moveDreamAlertModal: AlertDoubleButtonState? = nil
  ) {
    self.userDiary = userDiary
    self.cardResult = cardResult
    self.requestDeleteDiaryAlertModal = requestDeleteDiaryAlertModal
    self.moveDreamAlertModal = moveDreamAlertModal
  }
}

enum DiaryAction: ToastPresentableAction {
  case backButtonTapped
  case deleteDiaryList
  case presentToast(String)

  // Child Action
  case cardResult(CardResultAction)
  case requestDeleteDiaryAlertModal(AlertDoubleButtonAction)
  case moveDreamAlertModal(AlertDoubleButtonAction)
}

struct DiaryEnvironment {
  var diaryListService: DiaryService

  init(diaryListService: DiaryService) {
    self.diaryListService = diaryListService
  }
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
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.moveDreamAlertModal,
      action: /DiaryAction.moveDreamAlertModal,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    ) as Reducer<WithSharedState<DiaryState>, DiaryAction, DiaryEnvironment>,
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
    state, action, env in
    switch action {
    case .backButtonTapped:
      return .none

    case .presentToast:
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
      if state.local.isSingleKeyword {
        // MARK: - 키워드를 통한 꿈카드 결과 화면 이동 구현 필요
        return Effect(value: .backButtonTapped)
      }
      return setAlertModal(
        state: &state.local.moveDreamAlertModal,
        titleText: "어떤 키워드로 검색할까요?",
        bodyText: "두 키워드 중 하나로 검색할 수 있어요.",
        secondaryButtonTitle: state.local.categoryKeywords.first ?? "",
        secondaryButtonHierachy: .primary,
        primaryButtonTitle: state.local.categoryKeywords[safe: 1] ?? "",
        primaryButtonHierachy: .primary
      )

    case .cardResult:
      return .none

    case .requestDeleteDiaryAlertModal(.primaryButtonTapped):
      let idList = state.local.userDiary.id
      popToRoot()
      return env.diaryListService.deleteDiary(idList: [idList])
        .catchToEffect()
        .flatMapLatest({ result -> Effect<DiaryAction, Never> in
          switch result {
          case .success:
            return Effect(value: .deleteDiaryList)
          case .failure:
            return Effect(value: .presentToast("꿈 일기가 삭제되지 않았어요. 다시 시도해주세요."))
          }
        })
        .eraseToEffect()

    case .requestDeleteDiaryAlertModal(.secondaryButtonTapped):
      state.local.requestDeleteDiaryAlertModal = nil
      return .none

    case .requestDeleteDiaryAlertModal:
      return .none

    case .moveDreamAlertModal(.primaryButtonTapped):
      // MARK: - 얼럿 우측 선택 키워드를 통한 꿈카드 결과 화면 이동 구현 필요
      state.local.moveDreamAlertModal = nil
      return Effect(value: .backButtonTapped)

    case .moveDreamAlertModal(.secondaryButtonTapped):
      // MARK: - 얼럿 좌측 선택 키워드를 통한 꿈카드 결과 화면 이동 구현 필요
      state.local.moveDreamAlertModal = nil
      return Effect(value: .backButtonTapped)

    case .moveDreamAlertModal:
      return .none

    case .deleteDiaryList:
      return .none
    }
  }
])

private func setAlertModal(
  state: inout AlertDoubleButtonState?,
  titleText: String? = nil,
  bodyText: String,
  secondaryButtonTitle: String,
  secondaryButtonHierachy: AlertButton.Hierarchy = .secondary,
  primaryButtonTitle: String,
  primaryButtonHierachy: AlertButton.Hierarchy = .primary
) -> Effect<DiaryAction, Never> {
  state = .init(
    title: titleText,
    body: bodyText,
    secondaryButtonTitle: secondaryButtonTitle,
    secondaryButtonHierachy: secondaryButtonHierachy,
    primaryButtonTitle: primaryButtonTitle,
    primaryButtonHierachy: primaryButtonHierachy
  )
  return .none
}
