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
      self.imageURLs = userDream.categories.map { $0.image }
      self.keywords = userDream.categories.map { $0.name }
    }
  }
}

enum DreamAction: ToastPresentableAction {
  case backButtonTapped
  case presentToast(String)

  // Child Action
  case cardResult(CardResultAction)
  case displaySaveDreamAlertModal
  case requestDeleteDreamAlertModal(AlertDoubleButtonAction)
  case requestSaveDreamAlertModal(AlertDoubleButtonAction)
}

struct DreamEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var userDreamListService: UserDreamListService
  var diaryService: DiaryService
  var dreamService: DreamService
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
      environment: {
        CardResultEnvironment(mainQueue: $0.mainQueue, diaryService: $0.diaryService, dreamService: $0.dreamService)
      }
    )
  as Reducer<WithSharedState<DreamState>, DreamAction, DreamEnvironment>,
  Reducer<WithSharedState<DreamState>, DreamAction, DreamEnvironment> {
    state, action, env in
    switch action {
    case .backButtonTapped:
      return .none

    case .presentToast:
      return .none

    case .cardResult(.deleteDream):
      return setAlertModal(
        state: &state.local.requestDeleteDreamAlertModal,
        titleText: "????????? ????????????????",
        bodyText: "???????????? ?????? ???????????? ????????? ??? ?????????.",
        secondaryButtonTitle: "?????????",
        primaryButtonTitle: "????????????",
        primaryButtonHierachy: .warning
      )

    case .cardResult(.saveDream):
      guard let userID = state.shared.userID else {
        return .none
      }
      let dreamID = state.local.userDreamCardResult.userDream.dreamID

      return env.userDreamListService.saveUserDream(
        userID: userID,
        dreamID: dreamID
      )
      .catchToEffect()
      .flatMapLatest({ result -> Effect<DreamAction, Never> in
        switch result {
        case .success:
          return Effect(value: .displaySaveDreamAlertModal)
        case .failure:
          return Effect(value: .presentToast("????????? ???????????? ????????????. ?????? ??????????????????."))
        }
      })
      .eraseToEffect()

    case .cardResult:
      return .none

    case .displaySaveDreamAlertModal:
      return setAlertModal(
        state: &state.local.requestSaveDreamAlertModal,
        titleText: "????????? ???????????????!",
        bodyText: "????????? ????????? ???????????? ??????????????? ????????? ??? ?????????.",
        secondaryButtonTitle: "????????? ??????",
        primaryButtonTitle: "??????"
      )

    case .requestDeleteDreamAlertModal(.primaryButtonTapped):
      state.local.requestDeleteDreamAlertModal = nil
      let dreamIDs = state.local.userDreamCardResult.userDream.id

      return env.userDreamListService.deleteUserDreamList(dreamIDs: [dreamIDs])
        .catchToEffect()
        .flatMapLatest({ result -> Effect<DreamAction, Never> in
          switch result {
          case .success:
            return Effect(value: .backButtonTapped)
          case .failure:
            return Effect(value: .presentToast("????????? ???????????? ????????????. ?????? ??????????????????."))
          }
        })
        .eraseToEffect()

    case .requestDeleteDreamAlertModal(.secondaryButtonTapped):
      state.local.requestDeleteDreamAlertModal = nil
      return .none

    case .requestSaveDreamAlertModal(.primaryButtonTapped):
      state.local.requestSaveDreamAlertModal = nil
      return .none

    case .requestSaveDreamAlertModal(.secondaryButtonTapped):
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
