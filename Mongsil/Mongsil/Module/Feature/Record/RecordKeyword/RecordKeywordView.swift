//
//  RecordKeywordView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/15.
//

import SwiftUI
import ComposableArchitecture

struct RecordKeywordView: View {
  private let store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>

  init(store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>) {
    self.store = store
  }

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(store: store)
      HeaderView(store: store)

      WithViewStore(store.scope(state: \.local.isNotPreference)) { isNotPreferenceViewStore in
        KeywordView(
          store: store.scope(
            state: \.local.keyword,
            action: RecordKeywordAction.keyword
          )
        )
        .disabled(isNotPreferenceViewStore.state)
        .opacity(isNotPreferenceViewStore.state ? 0.3 : 1)
        .apply(content: { view in
          WithViewStore(store.scope(state: \.local.toastText)) { toastTextViewStore in
            view.toast(
              text: toastTextViewStore.state,
              isBottomPosition: ViewStore(store).shared.isToastBottomPosition
            )
          }
        })
      }
    }
    .navigationTitle("")
    .navigationBarHidden(true)
    .frame(alignment: .center)
    .onAppear { ViewStore(store).send(.onAppear) }

    BottomView(store: store.scope(state: \.local.selectedCategories))
  }
}

private struct NavigationBar: View {
  private let store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>

  init(store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isStroeButtonAbled)) { isStroeButtonAbledViewStore in
      WithViewStore(store.scope(state: \.local.selectedDateToStr)) { selectedDateToStrViewStore in
        MSNavigationBar(
          backButtonImage: R.CustomImage.backIcon.image,
          backButtonAction: { ViewStore(store).send(.backButtonTapped) },
          titleText: selectedDateToStrViewStore.state, rightButtonText: "저장",
          rightButtonAction: { ViewStore(store).send(.saveBtnTapped) },
          rightButtonAbled: isStroeButtonAbledViewStore.binding(
            get: { $0 },
            send: RecordKeywordAction.setNextButtonAbled
          )
        ).padding(.horizontal, 20)
      }
    }
  }
}

private struct HeaderView: View {
  private let store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>

  init(store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>) {
    self.store = store
  }

  var body: some View {
    VStack(spacing: 8) {
      Text("이 꿈의 키워드를 선택해 주세요")
        .foregroundColor(.msWhite)
        .font(.title2)
        .frame(maxWidth: .infinity, alignment: .leading)
      Text("두 개까지만 선택할 수 있어요!")
        .foregroundColor(.gray6)
        .font(.body2)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.top, 24)
    .padding(.leading, 20)

    WithViewStore(store.scope(state: \.local)) { viewStore in
      RadioButton(
        "원하는 키워드가 없어요",
        isActive: viewStore.binding(
          get: \.isNotPreference,
          send: RecordKeywordAction.setIsNotPreference
        )
      )
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 24)
        .padding(.leading, 20)
    }
  }
}

private struct BottomView: View {
  private let store: Store<[Category], RecordKeywordAction>

  init(store: Store<[Category], RecordKeywordAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      if viewStore.state.isNotEmpty {
        VStack(spacing: 0) {
          Divider()
            .background(Color.gray8)
            .frame(height: 1)

          HStack(spacing: 10) {
            ForEach(viewStore.state) { category in
              KeywordClibView(category.name) {
                viewStore.send(.removeCategoriesButton(category))
              }
            }
          }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 11)
            .padding(.horizontal, 20)
        }
      }
    }
  }
}
