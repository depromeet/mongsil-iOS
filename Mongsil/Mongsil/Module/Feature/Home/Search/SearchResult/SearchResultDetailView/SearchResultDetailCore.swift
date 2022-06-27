//
//  SearchResultDetailCore.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/23.
//

import Combine
import ComposableArchitecture

struct SearchResultDetailState: Equatable {
  fileprivate var searchResult: SearchResult
  var searchResultDetail: Dream?
  var isLoginPushed: Bool = false

  public init(searchResult: SearchResult) {
    self.searchResult = searchResult
  }

  // Child State
  var cardResult: CardResultState = .init()
  var saveSuccessAlertModal: AlertDoubleButtonState?
  var requestLoginAlertModal: AlertDoubleButtonState?
  var login: LoginState?
}

enum SearchResultDetailAction: ToastPresentableAction {
  case onAppear
  case setSearchResultDetail(Dream)
  case backButtonTapped

  case moveToStorage

  case saveDreamResult(Result<Unit, Error>)

  case setLoginPushed(Bool)

  case saveDream

  // Child Action
  case cardResult(CardResultAction)
  case saveSuccessAlertModal(AlertDoubleButtonAction)
  case requestLoginAlertModal(AlertDoubleButtonAction)
  case login(LoginAction)

  case presentToast(String)
}

struct SearchResultDetailEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  var kakaoLoginService: KakaoLoginService
  var userService: UserService
  var signUpService: SignUpService
  var diaryService: DiaryService
  var dreamService: DreamService
  var userDreamListService: UserDreamListService
}

let searchResultDetailReducer: Reducer<WithSharedState<SearchResultDetailState>, SearchResultDetailAction, SearchResultDetailEnvironment> =
Reducer.combine([
  cardResultReducer
    .pullback(
      state: \.cardResult,
      action: /SearchResultDetailAction.cardResult,
      environment: {
        CardResultEnvironment(mainQueue: $0.mainQueue, diaryService: $0.diaryService, dreamService: $0.dreamService)
      }
    )
  as Reducer<WithSharedState<SearchResultDetailState>, SearchResultDetailAction, SearchResultDetailEnvironment>,
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.saveSuccessAlertModal,
      action: /SearchResultDetailAction.saveSuccessAlertModal,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    ) as Reducer<WithSharedState<SearchResultDetailState>, SearchResultDetailAction, SearchResultDetailEnvironment>,
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.requestLoginAlertModal,
      action: /SearchResultDetailAction.requestLoginAlertModal,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    ) as Reducer<WithSharedState<SearchResultDetailState>, SearchResultDetailAction, SearchResultDetailEnvironment>,

  loginReducer
    .optional()
    .pullback(
      state: \.login,
      action: /SearchResultDetailAction.login,
      environment: {
        LoginEnvironment(
          kakaoLoginService: $0.kakaoLoginService,
          userService: $0.userService,
          signUpService: $0.signUpService,
          mainQueue: $0.mainQueue
        )
      }
    ) as Reducer<WithSharedState<SearchResultDetailState>, SearchResultDetailAction, SearchResultDetailEnvironment>,
  Reducer<WithSharedState<SearchResultDetailState>, SearchResultDetailAction, SearchResultDetailEnvironment> {
    state, action, env in
    switch action {
    case .onAppear:
      return env.dreamService.getSearchResultDetail(id: state.local.searchResult.id)
        .catchToEffect()
        .flatMapLatest({ result -> Effect<SearchResultDetailAction, Never> in
          switch result {
          case let .success(searchResultDetail):
            return Effect(value: .setSearchResultDetail(searchResultDetail))
          case .failure(let error):
            return Effect.merge([
              Effect(value: .backButtonTapped),
              Effect(value: .presentToast("해몽을 조회하지 못했어요. 잠시 후 다시 시도해 주세요."))
            ])
          }
        })
        .eraseToEffect()

    case let .setSearchResultDetail(searchResultDetail):
      state.local.searchResultDetail = searchResultDetail
      return .none

    case .backButtonTapped:
      return .none

    case .moveToStorage:
      return .none

    case .cardResult(.saveDream):
      return Effect(value: .saveDream)

    case let .setLoginPushed(pushed):
      state.local.isLoginPushed = pushed
      if pushed {
        state.local.login = .init()
      }
      return .none

    case .saveDream:
      let isLogined: Bool = UserDefaults.standard.bool(forKey: "isLogined")

      if !isLogined {
        return setRequestLoginAlertModal(
          state: &state.local.requestLoginAlertModal,
          titleText: "로그인이 필요한 기능이에요!",
          bodyText: "꿈 일기를 쓰려면 로그인을 해주세요.",
          secondaryButtonTitle: "돌아가기",
          primaryButtonTitle: "로그인하기"
        )
      }

      guard let userID = state.shared.userID else { return .none }
      guard let dreamID = state.local.searchResultDetail?.id else { return .none }

      return env.userDreamListService.saveUserDream(userID: userID, dreamID: dreamID)
        .catchToEffect()
        .map(SearchResultDetailAction.saveDreamResult)
        .eraseToEffect()

    case let .saveDreamResult(result):
      switch result {
      case let .success(searchResultDetail):
        return setSaveSuccessAlertModal(
          state: &state.local.saveSuccessAlertModal,
          titleText: "해몽을 저장했어요!",
          bodyText: "저장된 해몽은 언제든지 보관함에서\n꺼내볼 수 잇어요.",
          secondaryButtonTitle: "보관함 가기",
          secondaryButtonHierachy: .secondary,
          primaryButtonTitle: "닫기",
          primaryButtonHierachy: .primary
        )
      case .failure:
        return Effect(value: .presentToast("이미 저장된 해몽입니다."))
      }

    case .saveSuccessAlertModal(.secondaryButtonTapped):
      return Effect(value: .moveToStorage)

    case .saveSuccessAlertModal(.primaryButtonTapped):
      state.local.saveSuccessAlertModal = nil
      return .none

    case .requestLoginAlertModal(.primaryButtonTapped):
      state.local.requestLoginAlertModal = nil
      return Effect(value: .setLoginPushed(true))

    case .requestLoginAlertModal(.secondaryButtonTapped):
      state.local.requestLoginAlertModal = nil
      return .none

    case .login(.backButtonTapped):
      return Effect(value: .setLoginPushed(false))

    case .login(.loginCompleted):
      return Effect(value: .setLoginPushed(false))

    case .cardResult:
      return .none

    case .saveSuccessAlertModal:
      return .none

    case .requestLoginAlertModal:
      return .none

    case .login:
      return .none

    case .presentToast:
      return .none
    }
  }
])

private func setSaveSuccessAlertModal(
  state: inout AlertDoubleButtonState?,
  titleText: String? = nil,
  bodyText: String,
  secondaryButtonTitle: String,
  secondaryButtonHierachy: AlertButton.Hierarchy = .secondary,
  primaryButtonTitle: String,
  primaryButtonHierachy: AlertButton.Hierarchy = .primary
) -> Effect<SearchResultDetailAction, Never> {
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

private func setRequestLoginAlertModal(
  state: inout AlertDoubleButtonState?,
  titleText: String? = nil,
  bodyText: String,
  secondaryButtonTitle: String,
  secondaryButtonHierachy: AlertButton.Hierarchy = .secondary,
  primaryButtonTitle: String,
  primaryButtonHierachy: AlertButton.Hierarchy = .primary
) -> Effect<SearchResultDetailAction, Never> {
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
