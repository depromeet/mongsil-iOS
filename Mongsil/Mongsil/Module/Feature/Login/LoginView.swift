//
//  LoginView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/19.
//

import ComposableArchitecture
import SwiftUI

struct LoginView: View {
  private let store: Store<WithSharedState<LoginState>, LoginAction>

  init(store: Store<WithSharedState<LoginState>, LoginAction>) {
    self.store = store
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      MSNavigationBar(
        titleText: "로그인",
        backButtonAction: { ViewStore(store).send(.backButtonTapped) }
      )
      WelcomeTitleView()
        .padding(.bottom, 10)
      OnboardingView(store: store)
        .padding(.bottom, 50)
      SocialLoginButtonView(store: store)
        .padding(.bottom, 50)
    }
    .navigationBarHidden(true)
  }
}

private struct WelcomeTitleView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("몽실에 오신 것을 환영해요!")
        .font(.title2)
        .foregroundColor(.white)
      Text("더 많은 서비스를 이용하시려면 로그인 해주세요.")
        .font(.subheadline)
        .foregroundColor(.gray4)
    }
    .padding(.leading, 20)
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
          }
        )
      }
      .background(Color.gray)
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
    HStack {
      Spacer()
      VStack(spacing: 10) {
        Button(action: { ViewStore(store).send(.kakaoLoginButtonTapped) }) {
          R.CustomImage.kakaoLoginButton.image
        }
        Button(action: { ViewStore(store).send(.appleLoginButtonTapped) }) {
          R.CustomImage.appleLoginButton.image
        }
      }
      Spacer()
    }
  }
}
