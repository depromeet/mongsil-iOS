//
//  S.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

extension View {
  func selectFilterSheet(
    store: Store<SelectFilterSheetState, SelectFilterSheetAction>,
    height: CGFloat
  ) -> some View {
    let viewStore = ViewStore(store)

    return self.apply(content: { view in
      WithViewStore(store.scope(state: \.isFilterSheetPresented)) { _ in
        view.bottomSheet(
          title: "필터",
          isPresented: viewStore.binding(
            get: \.isFilterSheetPresented,
            send: SelectFilterSheetAction.setFilterSheetPresented
          ),
          content: {
            VStack(spacing: 0) {
              KeywordView(
                store: store.scope(
                  state: \.keyword,
                  action: SelectFilterSheetAction.keyword
                )
              )
              .height(height)
              .onAppear {
                ViewStore(store).send(.onAppear)
              }
              SelectedFilterView(store: store)
            }
          },
          bottomArea: {
            HStack(spacing: 20) {
              Button(action: { ViewStore(store).send(.resetFilterButtonTapped) }) {
                Text("초기화")
                  .foregroundColor(.gray2)
                  .font(.button)
              }
              WithViewStore(store.scope(state: \.isConfirmFilterButtonAbled)) { isConfirmFilterButtonAbledViewStore in
                Button(action: { ViewStore(store).send(.confirmFilterButtonTapped) }) {
                  HStack {
                    Spacer()
                    WithViewStore(store.scope(state: \.searchResultCount)) { searchResultCountViewStore in
                      Text("\(searchResultCountViewStore.state)결과 보기")
                        .font(.button)
                        .foregroundColor(isConfirmFilterButtonAbledViewStore.state ? Color.gray10 : Color.gray7)
                        .padding(.vertical, 12)
                    }
                    Spacer()
                  }
                }
                .disabled(!isConfirmFilterButtonAbledViewStore.state)
                .background(isConfirmFilterButtonAbledViewStore.state ? Color.gray1 : Color.gray8)
                .cornerRadius(8)
              }
            }
          }
        )
      }
    })
  }
}

private struct SelectedFilterView: View {
  private let store: Store<SelectFilterSheetState, SelectFilterSheetAction>
  @ObservedObject var viewStore: ViewStore<SelectFilterSheetState, SelectFilterSheetAction>

  init(store: Store<SelectFilterSheetState, SelectFilterSheetAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  var body: some View {
    if viewStore.state.selectedCategories.isNotEmpty {
      VStack(spacing: 0) {
        Divider()
          .background(Color.gray8)
          .frame(height: 1)

        ScrollViewReader { render in
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
              ForEach(viewStore.state.selectedCategories) { category in
                KeywordClibView(category.name) {
                  viewStore.send(.removeCategoryButtonTapped(category))
                }.id(category.id)
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 11)
            .padding(.horizontal, 20)
            .onChange(of: viewStore.state.selectedCategories) { selectedCategories in
              withAnimation {
                render.scrollTo(selectedCategories.last?.id)
              }
            }
          }
        }
      }
    }
  }
}
