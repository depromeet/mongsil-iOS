//
//  AppCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import Combine
import ComposableArchitecture

struct AppState: Equatable {
  var mainTab: MainTabState = .init()
}

enum AppAction {
  case onAppear
  case checkIsLogined
  case checkHasKakaoToken
  case checkHasAppleToken
  case setIsLogined(Bool)
  case searchUserID
  case setUserID(String?)
  case presentToast(String, Bool = true)
  case hideToast
  case noop

  // Child Action
  case mainTab(MainTabAction)
}

struct AppEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var kakaoLoginService: KakaoLoginService
  var appleLoginService: AppleLoginService
  var userService: UserService
  var signUpService: SignUpService
  var userDreamListService: UserDreamListService
  var dropoutService: DropoutService
  var dreamService: DreamService
  var diaryService: DiaryService

  init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    kakaoLoginService: KakaoLoginService,
    appleLoginService: AppleLoginService,
    userService: UserService,
    signUpService: SignUpService,
    userDreamListService: UserDreamListService,
    dropoutService: DropoutService,
    dreamService: DreamService,
    diaryService: DiaryService
  ) {
    self.mainQueue = mainQueue
    self.kakaoLoginService = kakaoLoginService
    self.appleLoginService = appleLoginService
    self.userService = userService
    self.signUpService = signUpService
    self.userDreamListService = userDreamListService
    self.dropoutService = dropoutService
    self.dreamService = dreamService
    self.diaryService = diaryService
  }
}

let appReducer = Reducer.combine([
  mainTabReducer.pullback(
    state: \.mainTab,
    action: /AppAction.mainTab,
    environment: {
      MainTabEnvironment(
        mainQueue: $0.mainQueue,
        kakaoLoginService: $0.kakaoLoginService,
        userService: $0.userService,
        signUpService: $0.signUpService,
        userDreamListService: $0.userDreamListService,
        dropoutService: $0.dropoutService,
        dreamService: $0.dreamService,
        diaryService: $0.diaryService
      )
    }
  ) as Reducer<WithSharedState<AppState>, AppAction, AppEnvironment>,
  Reducer<WithSharedState<AppState>, AppAction, AppEnvironment> {
    state, action, env in
    struct ToastCancelId: Hashable {}

    switch action {
    case .onAppear:
      return Effect.merge([
        Effect(value: .checkIsLogined),
        Effect(value: .searchUserID)
      ])

    case .checkIsLogined:
      let isKakao = UserDefaults.standard.bool(forKey: "isKakao")
      return env.userService.isLogined()
        .map({ isLogined -> AppAction in
          if isLogined {
            return isKakao ? .checkHasKakaoToken : .checkHasAppleToken
          }
          return .noop
        })
        .eraseToEffect()

    case .checkHasKakaoToken:
      return env.kakaoLoginService.hasKakaoToken()
        .catchToEffect()
        .flatMapLatest({ result -> Effect<AppAction, Never> in
          switch result {
          case let .success(hasKakaoToken):
            return Effect(value: .setIsLogined(hasKakaoToken))
          case .failure:
            return Effect(value: .presentToast("????????? ????????? ?????? ????????? ??????????????? ??????????????????."))
          }
        })
        .eraseToEffect()

    case .checkHasAppleToken:
      return env.appleLoginService.hasAppleToken()
        .map({ result -> AppAction in
          return .setIsLogined(result)
        })
        .eraseToEffect()

    case let .setIsLogined(isLogined):
      UserDefaults.standard.set(isLogined, forKey: "isLogined")
      return .none

    case .searchUserID:
      let isKakao = UserDefaults.standard.bool(forKey: "isKakao")
      var email = isKakao
      ? UserDefaults.standard.string(forKey: "kakaoEmail") ?? ""
      : UserDefaults.standard.string(forKey: "appleEmail") ?? ""
      if email.isEmpty {
        return .none
      }

      return env.userService.searchUserID(with: email)
        .catchToEffect()
        .map({ result in
          switch result {
          case let .success(response):
            if response.checkValue {
              guard let userID = response.userID else {
                return AppAction.presentToast("?????? ID??? ????????????.")
              }
              return AppAction.setUserID(userID)
            } else {
              return .noop
            }
          case let .failure(error):
            return AppAction.presentToast("?????? ????????? ?????????????????????.")
          }
        })

    case let .setUserID(userID):
      state.shared.userID = userID
      return .none

    case let .presentToast(toastText, isBottomPosition):
      state.shared.toastText = toastText
      state.shared.isToastBottomPosition = isBottomPosition
      return Effect<AppAction, Never>.concatenate([
        .cancel(id: ToastCancelId()),
        Effect<AppAction, Never>(value: .hideToast)
          .delay(for: 3, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: ToastCancelId(), cancelInFlight: true)
      ])

    case .hideToast:
      state.shared.toastText = nil
      return .none

    case let .mainTab(.login(.presentToast(text))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.login(.setUserID(userID))):
      return Effect(value: .setUserID(userID))

    case let .mainTab(.record(.presentToast(text))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.storage(.presentToast(text))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.storage(.diary(.presentToast(text)))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.storage(.dream(.presentToast(text)))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.storage(.diary(.cardResult(.record(.presentToast(text)))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.record(.recordKeyword(.keyword(.verbKeyword(.presentToast(text)))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.record(.recordKeyword(.keyword(.nounKeyword(.presentToast(text)))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.home(.search(.presentToast(text)))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.home(.search(.searchResult(.presentToast(text))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.home(.search(.searchResult(.searchResultDetail(.presentToast(text)))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.home(.search(.searchResult(.searchResultDetail(.login(.presentToast(text))))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.home(.search(.searchResult(.searchResultDetail(.login(.setUserID(userID))))))):
      return Effect(value: .setUserID(userID))

    case let .mainTab(.home(.searchResult(.presentToast(text)))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.home(.searchResult(.searchResultDetail(.presentToast(text))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.home(.searchResult(.searchResultDetail(.login(.presentToast(text)))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.home(.searchResult(.searchResultDetail(.login(.setUserID(userID)))))):
      return Effect(value: .setUserID(userID))

    case let .mainTab(.storage(.diary(.searchResult(.presentToast(text))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.storage(.diary(.searchResult(.searchResultDetail(.presentToast(text)))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.storage(.diary(.search(.presentToast(text))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.storage(.diary(.search(.searchResult(.presentToast(text)))))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.storage(.diary(.search(.searchResult(.searchResultDetail(.presentToast(text))))))):
      return Effect(value: .presentToast(text))

    case .mainTab(.storage(.setting(.profile(.logoutAlertModal(.primaryButtonTapped))))):
      return Effect(value: .mainTab(.tabTapped(.home)))

    case let .mainTab(.storage(.setting(.profile(.setUserID(userID))))):
      return Effect.concatenate([
        Effect(value: .setUserID(userID)),
        Effect(value: .mainTab(.tabTapped(.home)))
      ])

    case .mainTab(.storage(.dream(.requestSaveDreamAlertModal(.secondaryButtonTapped)))):
      return Effect(value: .mainTab(.tabTapped(.storage)))

    case .mainTab:
      return .none

    case .noop:
      return .none
    }
  }
])
