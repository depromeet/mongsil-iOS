//
//  AppInfoView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import ComposableArchitecture
import SwiftUI

struct AppInfoView: View {
  private let store: Store<WithSharedState<AppInfoState>, AppInfoAction>

  init(store: Store<WithSharedState<AppInfoState>, AppInfoAction>) {
    self.store = store
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      MSNavigationBar(
        titleText: "정보",
        backButtonAction: { ViewStore(store).send(.backButtonTapped) }
      )

      TermsButtonView(store: store)
      PersonalInfoPolicyButtonView(store: store)
      OpenSourceButtonView(store: store)

      Spacer()
    }
    .navigationBarHidden(true)
  }
}

private struct TermsButtonView: View {
  private let store: Store<WithSharedState<AppInfoState>, AppInfoAction>

  init(store: Store<WithSharedState<AppInfoState>, AppInfoAction>) {
    self.store = store
  }

  var body: some View {
    ListItemWithTextIcon(
      content: { TermsLink(store: store) }
    )
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
          Text("이용약관")
            .font(.title2)
            .foregroundColor(.gray2)
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct PersonalInfoPolicyButtonView: View {
  private let store: Store<WithSharedState<AppInfoState>, AppInfoAction>

  init(store: Store<WithSharedState<AppInfoState>, AppInfoAction>) {
    self.store = store
  }

  var body: some View {
    ListItemWithTextIcon(
      content: { PersonalInfoPolicyLink(store: store) }
    )
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
          Text("개인정보 정책")
            .font(.title2)
            .foregroundColor(.gray2)
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct OpenSourceButtonView: View {
  private let store: Store<WithSharedState<AppInfoState>, AppInfoAction>

  init(store: Store<WithSharedState<AppInfoState>, AppInfoAction>) {
    self.store = store
  }

  var body: some View {
    ListItemWithTextIcon(
      content: { OpenSourceLink(store: store) }
    )
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
          Text("오픈소스")
            .font(.title2)
            .foregroundColor(.gray2)
        }
      )
      .isDetailLink(true)
    }
  }
}
