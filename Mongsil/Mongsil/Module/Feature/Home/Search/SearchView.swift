//
//  SearchView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/09.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
  private let store: Store<WithSharedState<SearchState>, SearchAction>

  init(store: Store<WithSharedState<SearchState>, SearchAction>) {
    self.store = store
  }

  var body: some View {
    VStack(spacing: 0) {
      MSNavigationView(store: store)
      HotKeywordView(store: store)
      Rectangle()
        .height(9)
        .foregroundColor(.gray9)
      KeywordView(
        store: store.scope(
          state: \.local.keyword,
          action: SearchAction.keyword
        )
      )
    }.navigationTitle("")
      .navigationBarHidden(true)
      .onAppear {
        ViewStore(store).send(.onAppear)
      }
      .onTapGesture {
        hideKeyboard()
      }
  }
}

private struct MSNavigationView: View {
  private let store: Store<WithSharedState<SearchState>, SearchAction>

  init(store: Store<WithSharedState<SearchState>, SearchAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      SearchBar(
        text: viewStore.binding(
          get: \.local.searchKeyword,
          send: SearchAction.searchTextFieldChanged
        ),
        isSearched: false,
        backbuttonAction: { ViewStore(store).send(.backButtonTapped) },
        removeButtonAction: { ViewStore(store).send(.removeButtonTapped) },
        searchButtonAction: {
          hideKeyboard()
          ViewStore(store).send(.searchButtonTapped)
        }
      )
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
        .height(44)
    }

    WithViewStore(store.scope(state: \.local.isSearchResultViewPushed)) { isSearchResultViewPushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.searchResult,
            action: SearchAction.searchResult
          ),
          then: SearchResultView.init(store:)
        ),
        isActive: isSearchResultViewPushedViewStore.binding(
          send: SearchAction.setSearchResultViewPushed
        ),
        label: {
          EmptyView()
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct HotKeywordView: View {
  private let store: Store<WithSharedState<SearchState>, SearchAction>

  init(store: Store<WithSharedState<SearchState>, SearchAction>) {
    self.store = store
  }

  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Text("인기 해몽 키워드")
          .font(.caption1)
          .foregroundColor(.gray6)
        Spacer()
      }
      HotKeywordBadgesView(store: store)
    }
    .padding(.vertical, 24)
    .padding(.horizontal, 20)
  }
}

private struct HotKeywordBadgesView: View {
  private let store: Store<WithSharedState<SearchState>, SearchAction>

  init(store: Store<WithSharedState<SearchState>, SearchAction>) {
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
