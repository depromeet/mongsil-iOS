//
//  AppInfoView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/21.
//

import ComposableArchitecture
import SwiftUI

struct AppInfoView: View {
  private let store: Store<WithSharedState<AppInfoState>, AppInfoAction>

  init(store: Store<WithSharedState<AppInfoState>, AppInfoAction>) {
    self.store = store
  }

  var body: some View {
    MSNavigationBar(
      backButtonImage: R.CustomImage.backIcon.image,
      backButtonAction: { ViewStore(store).send(.backButtonTapped) },
      titleText: "정보"
    )
    .padding(.horizontal, 20)
    .padding(.bottom, 24)
    VStack(spacing: 0) {
      TermsLink(store: store)
        .padding(.vertical, 15)
      Divider()
        .background(Color.gray8)
      PersonalInfoPolicyLink(store: store)
        .padding(.vertical, 15)
      Divider()
        .background(Color.gray8)
      OpenSourceLink(store: store)
        .padding(.vertical, 15)
      Divider()
        .background(Color.gray8)
      MakersLinkView(store: store)
        .padding(.vertical, 15)
      Divider()
        .background(Color.gray8)
      Spacer()
    }
    .padding(.horizontal, 20)
    .navigationBarHidden(true)
  }
}

private struct TermsLink: View {
  private let store: Store<WithSharedState<AppInfoState>, AppInfoAction>

  init(store: Store<WithSharedState<AppInfoState>, AppInfoAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isTermsPushed)) { isTermsPushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.terms,
            action: AppInfoAction.terms
          ),
          then: TermsView.init(store:)
        ),
        isActive: isTermsPushedViewStore.binding(
          send: AppInfoAction.setTermsPushed
        ),
        label: {
          HStack {
            Text("이용약관")
              .font(.body2)
              .foregroundColor(.gray2)
            Spacer()
            R.CustomImage.arrowRightIcon.image
          }
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct PersonalInfoPolicyLink: View {
  private let store: Store<WithSharedState<AppInfoState>, AppInfoAction>

  init(store: Store<WithSharedState<AppInfoState>, AppInfoAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isPersonalInfoPolicyPushed)) { isPersonalInfoPolicyPushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.personalInfoPolicy,
            action: AppInfoAction.personalInfoPolicy
          ),
          then: PersonalInfoPolicyView.init(store:)
        ),
        isActive: isPersonalInfoPolicyPushedViewStore.binding(
          send: AppInfoAction.setPersonalInfoPolicyPushed
        ),
        label: {
          HStack {
            Text("개인정보 정책")
              .font(.body2)
              .foregroundColor(.gray2)
            Spacer()
            R.CustomImage.arrowRightIcon.image
          }
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct OpenSourceLink: View {
  private let store: Store<WithSharedState<AppInfoState>, AppInfoAction>

  init(store: Store<WithSharedState<AppInfoState>, AppInfoAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isOpenSourcePushed)) { isOpenSourcePushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.openSource,
            action: AppInfoAction.openSource
          ),
          then: OpenSourceView.init(store:)
        ),
        isActive: isOpenSourcePushedViewStore.binding(
          send: AppInfoAction.setOpenSourcePushed
        ),
        label: {
          HStack {
            Text("오픈소스")
              .font(.body2)
              .foregroundColor(.gray2)
            Spacer()
            R.CustomImage.arrowRightIcon.image
          }
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct MakersLinkView: View {
  private let store: Store<WithSharedState<AppInfoState>, AppInfoAction>

  init(store: Store<WithSharedState<AppInfoState>, AppInfoAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isMakersPushed)) { isMakersPushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.makers,
            action: AppInfoAction.makers
          ),
          then: MakersView.init(store:)
        ),
        isActive: isMakersPushedViewStore.binding(
          send: AppInfoAction.setMakersPushed
        ),
        label: {
          HStack {
            Text("만든 사람들")
              .font(.body2)
              .foregroundColor(.gray2)
            Spacer()
            R.CustomImage.arrowRightIcon.image
          }
        }
      )
      .isDetailLink(true)
    }
  }
}
