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
  var userDreamListService: UserDreamListService

  init(userDreamListService: UserDreamListService) {
    self.userDreamListService = userDreamListService
  }
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
    state, action, env in
    switch action {
    case .backButtonTapped:
      return .none

    case .presentToast:
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
          return Effect(value: .presentToast("해몽이 저장되지 않았어요. 다시 시도해주세요."))
        }
      })
      .eraseToEffect()

    case .cardResult:
      return .none

    case .displaySaveDreamAlertModal:
      return setAlertModal(
        state: &state.local.requestSaveDreamAlertModal,
        titleText: "해몽을 저장했어요!",
        bodyText: "저장된 해몽은 언제든지 보관함에서 꺼내볼 수 있어요.",
        secondaryButtonTitle: "보관함 가기",
        primaryButtonTitle: "닫기"
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
            return Effect(value: .presentToast("해몽이 삭제되지 않았어요. 다시 시도해주세요."))
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
      // MARK: - 추후 꿈 카드 검색 후 저장 시 보관함 가기 로직 구현 (AppAction에서 필요)
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
