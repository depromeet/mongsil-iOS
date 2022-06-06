//
//  HomeView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import ComposableArchitecture
import SwiftUI
import PureSwiftUI

struct HomeView: View {
  private let store: Store<WithSharedState<HomeState>, HomeAction>

  init(store: Store<WithSharedState<HomeState>, HomeAction>) {
    self.store = store
  }

  var body: some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 96)
      WelcomeView()
      SearchLink(store: store)
        .padding(.top, 19)
      HotKeywordTitleView()
        .padding(.top, 40)
      HotKeywordBadgesView(store: store)
        .padding(.top, 20)
      Spacer()
    }
    .padding(.horizontal, 20)
    .navigationTitle("")
    .navigationBarHidden(true)
    .onAppear(perform: { ViewStore(store).send(.onAppear) })
  }
}

private struct WelcomeView: View {
  var body: some View {
    HStack {
      Text("안녕하세요\n좋은 꿈 꾸셨나요?")
        .foregroundColor(.msWhite)
        .font(.title1)
        .lineSpacing(10)
      Spacer()
    }
  }
}

private struct SeachBarView: View {
  var body: some View {
    HStack {
      Text("궁금한 꿈의 키워드를 검색해보세요")
        .font(.caption1)
        .foregroundColor(.gray6)
        .padding(.leading, 16)
      Spacer()
      R.CustomImage.searchIcon.image
        .renderingMode(.template)
        .foregroundColor(.gray6)
        .padding(.trailing, 16)
    }
    .frame(height: 48)
    .background(Color.gray9)
    .clipShape(
      RoundedRectangle(
        cornerRadius: 8,
        style: .continuous
      )
    )
  }
}

private struct SearchLink: View {
  private let store: Store<WithSharedState<HomeState>, HomeAction>

  init(store: Store<WithSharedState<HomeState>, HomeAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isSearchPushed)) { isSearchPushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.search,
            action: HomeAction.search
          ),
          then: SearchView.init(store: )
        ),
        isActive: isSearchPushedViewStore.binding(
          send: HomeAction.setSearchPushed
        ),
        label: {
          SeachBarView()
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct HotKeywordTitleView: View {
  var body: some View {
    HStack {
      Text("인기 해몽 키워드")
        .font(.caption1)
        .foregroundColor(.gray1)
      Spacer()
    }
  }
}

private struct HotKeywordBadgesView: View {
  private let store: Store<WithSharedState<HomeState>, HomeAction>

  init(store: Store<WithSharedState<HomeState>, HomeAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.hotKeywords)) { hotKeywordsViewStore in

      if hotKeywordsViewStore.state.isNotEmpty {
        VStack(spacing: 12) {
          HStack(spacing: 8) {
            ForEach(hotKeywordsViewStore.state[0...3], id: \.self) { keyword in
              Button(
                action: {
                  ViewStore(store).send(.hotKeywordTapped(keyword))
                }
              ) {
                KeywordBadgeView(keyword)
              }
            }
            Spacer()
          }
          HStack(spacing: 8) {
            ForEach(hotKeywordsViewStore.state[4...7], id: \.self) { keyword in
              Button(
                action: {
                  ViewStore(store).send(.hotKeywordTapped(keyword))
                }
              ) {
                KeywordBadgeView(keyword)
              }
            }
            Spacer()
          }
        }
      }
    }
  }
}
