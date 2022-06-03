//
//  LoginView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/19.
//

import AuthenticationServices
import ComposableArchitecture
import SwiftUI

struct LoginView: View {
  private let store: Store<WithSharedState<LoginState>, LoginAction>

  init(store: Store<WithSharedState<LoginState>, LoginAction>) {
    self.store = store
  }

  var body: some View {
    VStack(spacing: 0) {
      MSNavigationBar(
        backButtonImage: R.CustomImage.backIcon.image,
        backButtonAction: { ViewStore(store).send(.backButtonTapped) }
      )
      .padding(.leading, 20)
      .padding(.bottom, 14)
      OnboardingView(store: store)
      SocialLoginButtonView(store: store)
        .padding(.bottom, 32)
    }
    .background(
      Rectangle()
        .foregroundColor(.gray11)
        .ignoresSafeArea(.all)
    )
    .navigationTitle("")
    .navigationBarHidden(true)
  }
}

private struct OnboardingView: View {
  private let store: Store<WithSharedState<LoginState>, LoginAction>

  init(store: Store<WithSharedState<LoginState>, LoginAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.onboardingImage)) { onboardingImageStore in
      TabView {
        ForEachWithIndex(
          onboardingImageStore.state,
          content: { _, onboardingImage, _ in
            onboardingImage.image
              .resizedToFit()
              .padding(.bottom, 55)
              .aspectRatio(contentMode: .fit)
          }
        )
      }
      .tabViewStyle(.page)
      .indexViewStyle(.page(backgroundDisplayMode: .automatic))
    }
  }
}

private struct SocialLoginButtonView: View {
  private let store: Store<WithSharedState<LoginState>, LoginAction>

  init(store: Store<WithSharedState<LoginState>, LoginAction>) {
    self.store = store
  }

  var body: some View {
    HStack(spacing: 0) {
      Spacer()
      VStack(alignment: .leading, spacing: 0) {
        KakaoLoginButtonView(store: store)
          .frame(width: 335, height: 56, alignment: .center)
          .padding(.bottom, 16)
        AppleLoginButtonView(store: store)
          .frame(width: 335, height: 56, alignment: .center)
      }
      Spacer()
    }
  }
}

private struct KakaoLoginButtonView: View {
  private let store: Store<WithSharedState<LoginState>, LoginAction>

  init(store: Store<WithSharedState<LoginState>, LoginAction>) {
    self.store = store
  }

  var body: some View {
    Button(action: { ViewStore(store).send(.kakaoLoginButtonTapped) }) {
      R.CustomImage.kakaoLoginButton.image
    }
  }
}

private struct AppleLoginButtonView: View {
  private let store: Store<WithSharedState<LoginState>, LoginAction>

  init(store: Store<WithSharedState<LoginState>, LoginAction>) {
    self.store = store
  }

  var body: some View {
    SignInWithAppleButton(
      .signIn,
      onRequest: { request in
        request.requestedScopes = [.fullName, .email]
      },
      onCompletion: { result in
        switch result {
        case .success(let authorization):
          if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let nickName = appleIDCredential.fullName?.nickname
            let email = appleIDCredential.email
            let userID = appleIDCredential.user
            ViewStore(store).send(.appleLoginCompleted(
              nickName ?? "",
              email ?? "",
              userID
            ))
          }
        case .failure:
          ViewStore(store).send(.appleLoginNotCompleted)
        }
      }
    )
    .signInWithAppleButtonStyle(.white)
  }
}
