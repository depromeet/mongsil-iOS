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
    userDiary.categories.count < 2
  }
  var categoryImages: [String] {
    userDiary.categories.map({ $0.image })
  }
  var categoryKeywords: [String] {
    userDiary.categories.map({ $0.name })
  }

  var isSearchPushed: Bool = false
  var isSearchResultPushed: Bool = false

  // Child State
  var search: SearchState?
  var searchResult: SearchResultState?
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
  case presentToast(String)

  case setSearchPushed(Bool)
  case setSearchResultPushed(Bool)

  // Child Action
  case search(SearchAction)
  case searchResult(SearchResultAction)
  case cardResult(CardResultAction)
  case requestDeleteDiaryAlertModal(AlertDoubleButtonAction)
  case moveDreamAlertModal(AlertDoubleButtonAction)
}

struct DiaryEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var kakaoLoginService: KakaoLoginService
  var userService: UserService
  var signUpService: SignUpService
  var diaryService: DiaryService
  var dreamService: DreamService
  var userDreamListService: UserDreamListService
}

let diaryReducer: Reducer<WithSharedState<DiaryState>, DiaryAction, DiaryEnvironment> =
Reducer.combine([
  searchReducer
    .optional()
    .pullback(
      state: \.search,
      action: /DiaryAction.search,
      environment: {
        SearchEnvironment(
          mainQueue: $0.mainQueue,
          kakaoLoginService: $0.kakaoLoginService,
          userService: $0.userService,
          signUpService: $0.signUpService,
          dreamService: $0.dreamService,
          diaryService: $0.diaryService,
          userDreamListService: $0.userDreamListService
        )
      }
    ) as Reducer<WithSharedState<DiaryState>, DiaryAction, DiaryEnvironment>,
  searchResultReducer
    .optional()
    .pullback(
      state: \.searchResult,
      action: /DiaryAction.searchResult,
      environment: {
        SearchResultEnvironment(
          mainQueue: $0.mainQueue,
          kakaoLoginService: $0.kakaoLoginService,
          userService: $0.userService,
          signUpService: $0.signUpService,
          dreamService: $0.dreamService,
          diaryService: $0.diaryService,
          userDreamListService: $0.userDreamListService
        )
      }
    ) as Reducer<WithSharedState<DiaryState>, DiaryAction, DiaryEnvironment>,
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
      environment: {
        CardResultEnvironment(mainQueue: $0.mainQueue, diaryService: $0.diaryService, dreamService: $0.dreamService)
      }
    )
  as Reducer<WithSharedState<DiaryState>, DiaryAction, DiaryEnvironment>,
  Reducer<WithSharedState<DiaryState>, DiaryAction, DiaryEnvironment> {
    state, action, env in
    switch action {
    case .backButtonTapped:
      return .none

    case let .setSearchPushed(pushed):
      state.local.isSearchPushed = pushed
      if pushed {
        state.local.search = .init()
      }
      return .none

    case let .setSearchResultPushed(pushed):
      state.local.isSearchResultPushed = pushed
      if pushed {
        state.local.searchResult = .init()
      }
      return .none

    case .presentToast:
      return .none

    case .cardResult(.removeDiaryButtonTapped):
      return setAlertModal(
        state: &state.local.requestDeleteDiaryAlertModal,
        titleText: "??? ????????? ????????????????",
        bodyText: "???????????? ?????? ????????? ??? ?????????.",
        secondaryButtonTitle: "?????????",
        primaryButtonTitle: "????????????",
        primaryButtonHierachy: .warning
      )

    case .cardResult(.moveDream):

      guard let keyword = state.local.categoryKeywords.first else {
        return Effect(value: .setSearchPushed(true))
      }

      if state.local.isSingleKeyword {
        return Effect.concatenate([
          Effect(value: .setSearchResultPushed(true)),
          Effect(value: .searchResult(.search(keyword)))
        ])
      }
      return setAlertModal(
        state: &state.local.moveDreamAlertModal,
        titleText: "?????? ???????????? ????????????????",
        bodyText: "??? ????????? ??? ????????? ????????? ??? ?????????.",
        secondaryButtonTitle: state.local.categoryKeywords.first ?? "",
        secondaryButtonHierachy: .primary,
        primaryButtonTitle: state.local.categoryKeywords[safe: 1] ?? "",
        primaryButtonHierachy: .primary,
        isExistCloseButton: true
      )

    case let .cardResult(.record(.recordKeyword(.moveToDiaryView(diary)))):
      guard let diary = diary else {
        return Effect.merge([
          Effect(value: .cardResult(.setRecordPushed(false))),
          Effect(value: .presentToast("????????? ?????? ??? ????????????."))
        ])
      }

      state.local.userDiary = diary

      return Effect(value: .cardResult(.setRecordPushed(false)))

    case let .cardResult(.setRecordPushed(isRecordPushed)):
      state.local.cardResult.isRecordPushed = isRecordPushed
      if isRecordPushed {
        state.local.cardResult.record = .init(editTarget: state.local.userDiary)
      }
      return .none

    case .cardResult:
      return .none

    case .requestDeleteDiaryAlertModal(.primaryButtonTapped):
      let idList = state.local.userDiary.id
      state.local.requestDeleteDiaryAlertModal = nil

      return env.diaryService.deleteDiary(idList: [idList])
        .catchToEffect()
        .flatMapLatest({ result -> Effect<DiaryAction, Never> in
          switch result {
          case .success:
            popToRoot()
            return .none

          case .failure:
            return Effect(value: .presentToast("??? ????????? ???????????? ????????????. ?????? ??????????????????."))
          }
        })
        .eraseToEffect()

    case .requestDeleteDiaryAlertModal(.secondaryButtonTapped):
      state.local.requestDeleteDiaryAlertModal = nil
      return .none

    case .requestDeleteDiaryAlertModal:
      return .none

    case .moveDreamAlertModal(.primaryButtonTapped):
      state.local.moveDreamAlertModal = nil
      guard let keyword = state.local.categoryKeywords.last else { return .none }
      return Effect.concatenate([
        Effect(value: .setSearchResultPushed(true)),
        Effect(value: .searchResult(.search(keyword)))
      ])

    case .moveDreamAlertModal(.secondaryButtonTapped):
      state.local.moveDreamAlertModal = nil
      guard let keyword = state.local.categoryKeywords.first else { return .none }
      return Effect.concatenate([
        Effect(value: .setSearchResultPushed(true)),
        Effect(value: .searchResult(.search(keyword)))
      ])

    case .moveDreamAlertModal(.closeButtonTapped):
      state.local.moveDreamAlertModal = nil
      return .none

    case .searchResult(.backButtonTapped):
      return Effect(value: .setSearchResultPushed(false))

    case .search(.backButtonTapped):
      return Effect(value: .setSearchPushed(false))

    case .search:
      return .none

    case .searchResult:
      return .none

    case .moveDreamAlertModal:
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
  primaryButtonHierachy: AlertButton.Hierarchy = .primary,
  isExistCloseButton: Bool = false
) -> Effect<DiaryAction, Never> {
  state = .init(
    title: titleText,
    body: bodyText,
    secondaryButtonTitle: secondaryButtonTitle,
    secondaryButtonHierachy: secondaryButtonHierachy,
    primaryButtonTitle: primaryButtonTitle,
    primaryButtonHierachy: primaryButtonHierachy,
    isExistCloseButton: isExistCloseButton
  )
  return .none
}
