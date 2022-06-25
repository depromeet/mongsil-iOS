//
//  SearchResultView.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/21.
//

import SwiftUI
import NukeUI
import ComposableArchitecture

struct SearchResultView: View {
  private let store: Store<WithSharedState<SearchResultState>, SearchResultAction>

  init(store: Store<WithSharedState<SearchResultState>, SearchResultAction>) {
    self.store = store
  }

  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        MSNavigationView(store: store)
        WithViewStore(store.scope(state: \.local.isExitSearchResult)) { isExitSearchResultViewStore in
          WithViewStore(store.scope(state: \.local.isSearched)) { isSearchedViewStore in
            switch (isExitSearchResultViewStore.state, isSearchedViewStore.state) {
              case (_, false):
                Spacer()
              case (true, _):
                ExistSearchResult(store: store)
              case (false, _):
                NotExistSearchResult(store: store)
            }
          }
        }
      }
      .navigationTitle("")
      .navigationBarHidden(true)
      .selectFilterSheet(
        store: store.scope(
          state: \.local.selectFilterSheet,
          action: SearchResultAction.selectFilterSheet),
        height: (geometry.height / 2)
      )
    }
  }
}

private struct MSNavigationView: View {
  private let store: Store<WithSharedState<SearchResultState>, SearchResultAction>

  init(store: Store<WithSharedState<SearchResultState>, SearchResultAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      SearchBar(
        text: viewStore.binding(
          get: \.local.searchKeyword,
          send: SearchResultAction.searchTextFieldChanged
        ),
        isSearched: viewStore.state.local.isSearched,
        backbuttonAction: { ViewStore(store).send(.backButtonTapped) },
        removeButtonAction: { ViewStore(store).send(.removeButtonTapped) },
        searchButtonAction: { ViewStore(store).send(.searchButtonTapped) }
      )
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
        .height(44)
    }
  }
}

private struct NotExistSearchResult: View {
  private let store: Store<WithSharedState<SearchResultState>, SearchResultAction>

  init(store: Store<WithSharedState<SearchResultState>, SearchResultAction>) {
    self.store = store
  }

  var body: some View {
    VStack(spacing: 0) {
      header
      Rectangle()
        .height(9)
        .foregroundColor(.gray9)
      KeywordView(
        store: store.scope(
          state: \.local.keyword,
          action: SearchResultAction.keyword
        )
      )
    }
    .onAppear { ViewStore(store).send(.fetchKeyword) }
  }

  var header: some View {
    VStack(spacing: 16) {
      WithViewStore(store.scope(state: \.local.searchedKeyword)) { searchedKeywordViewStore in
        Text("'\(searchedKeywordViewStore.state)'에 대한\n검색 결과가 없습니다.")
          .font(.body)
          .foregroundColor(.gray2)
          .align(.center)
      }
      Text("아래에서 원하는 해몽을 직접 찾아보세요!")
        .font(.caption2)
        .foregroundColor(.gray6)
        .align(.center)
    }
    .padding(.top, 36)
    .padding(.bottom, 50)
    .padding(.horizontal, 20)
  }
}

private struct DiaryLinkView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isDiaryPushed)) { isDiaryPushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.diary,
            action: StorageAction.diary
          ),
          then: DiaryView.init(store: )
        ),
        isActive: isDiaryPushedViewStore.binding(
          send: { StorageAction.setDiaryPushed($0) }
        ),
        label: {
          EmptyView()
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct ExistSearchResult: View {
  private let store: Store<WithSharedState<SearchResultState>, SearchResultAction>

  init(store: Store<WithSharedState<SearchResultState>, SearchResultAction>) {
    self.store = store
  }

  var body: some View {
    VStack(spacing: 8) {
      header
      resultList
    }.padding(.horizontal, 20)
  }

  var resultList: some View {
    WithViewStore(store.scope(state: \.local.searchResult)) { searchResultViewStore in
      ScrollView {
        VStack(spacing: 8) {
          ForEach(searchResultViewStore.state, id: \.id) { searchResult in
            WithViewStore(store.scope(state: \.local.isSearchResultDetailPushed)) { isSearchResultDetailPushedViewStore in
              NavigationLink(
                destination: IfLetStore(
                  store.scope(
                    state: \.searchResultDetail,
                    action: SearchResultAction.searchResultDetail
                  ),
                  then: SearchResultDetailView.init(store:)
                ),
                isActive: isSearchResultDetailPushedViewStore.binding(
                  send: { SearchResultAction.setSearchResultDetailPushed($0, searchResult) }
                ),
                label: {
                  SearchResultItem(searchResult: searchResult)
                }
              )
              .isDetailLink(false)
            }
          }
          Spacer()
        }
      }
    }
  }

  var header: some View {
    VStack(spacing: 0) {
      filterButton
      resultCountView
    }
  }

  var filterButton: some View {
    HStack(spacing: 8) {
      WithViewStore(store.scope(state: \.local.selectFilterSheet.isAppliedCategories)) { isAppliedCategoriesViewStore in
        Button(action: { ViewStore(store).send(.filterButtonTapped) }) {
          R.CustomImage.filterIcon.image
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
        }
        .backgroundColor(isAppliedCategoriesViewStore.state ? .gray8 : .gray9)
        .cornerRadius(8)
      }

      WithViewStore(store.scope(state: \.local.selectFilterSheet.appliedCategories)) { appliedCategoriesViewStore in
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(appliedCategoriesViewStore.state) { category in
              KeywordClibView(category.name) {
                ViewStore(store).send(.removeCategoryButtonTapped(category))
              }.id(category.id)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
    }
    .padding(.top, 16)
  }

  var resultCountView: some View {
    HStack(spacing: 2) {
      Text("검색결과")
      Text("·")
      WithViewStore(store.scope(state: \.local.searchResultCount)) { searchResultCountViewStore in
        Text("\(searchResultCountViewStore.state)건")
      }
      Spacer()
    }.font(.caption2)
      .foregroundColor(.gray2)
      .padding(.top, 24)
  }
}

private struct SearchResultItem: View {
  private let searchResult: SearchResult

  init(searchResult: SearchResult) {
    self.searchResult = searchResult
  }

  var body: some View {
    ZStack {
      HStack(spacing: 16) {
        titleView
        Spacer()
        imageView
      }
      .padding(.all, 20)
    }
    .backgroundColor(.gray10)
    .cornerRadius(8)
    .height(106)
  }

  var titleView: some View {
    VStack(alignment: .leading) {
      Spacer()
      Text(searchResult.title)
        .align(.leading)
        .font(.subTitle)
        .foregroundColor(.gray2)
      Spacer()
    }
  }

  var imageView: some View {
    HStack {
      ForEach(searchResult.image, id: \.self) { image in
        LazyImage(url: image) { state in
          if let image = state.image {
            image
              .resizingMode(.fill)
              .clipShape(RoundedRectangle.init(8))
          } else {
            R.CustomImage.cardResultDefaultImage.image
              .resizable()
          }
        }
        .frame(width: 36, height: 36)
      }
    }
  }
}
