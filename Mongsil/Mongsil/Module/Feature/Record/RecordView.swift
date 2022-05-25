//
//  RecordView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import SwiftUI
import ComposableArchitecture
import Introspect

struct RecordView: View {
  private let store: Store<WithSharedState<RecordState>, RecordAction>

  init(store: Store<WithSharedState<RecordState>, RecordAction>) {
    self.store = store
  }

  var body: some View {
    VStack {
      MSNavigationView(store: store)
        .padding(.horizontal, 20)
      TitleTextView(store: store)
        .padding(.init(top: 16, leading: 28, bottom: 16, trailing: 28))
      Divider()
        .padding(.horizontal, 28)
        .foregroundColor(.gray9)
      MainTextView(store: store)
        .foregroundColor(.gray8)
        .padding(.init(top: 16, leading: 28, bottom: 28, trailing: 34))
      CountTextView(store: store)
        .font(.caption2)
        .foregroundColor(.gray6)
        .padding(.bottom, 16)
        .frame(alignment: .center)
    }
    .alertDoubleButton(
      store: store.scope(
        state: \.local.cancelRecordAlertModal,
        action: RecordAction.cancelRecordAlertModal
      )
    )
    .selectDateSheet(store: store)
    .navigationTitle("")
    .navigationBarHidden(true)
  }
}

private struct MSNavigationView: View {
  private let store: Store<WithSharedState<RecordState>, RecordAction>

  init(store: Store<WithSharedState<RecordState>, RecordAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.selectedDateToStr)) { selectedDateToStrViewStore in
      WithViewStore(store.scope(state: \.local.isNextButtonAbled)) { isNextButtonAbledViewStore in
        MSNavigationBar(
          backButtonImage: R.CustomImage.cancelIcon.image,
          backButtonAction: { ViewStore(store).send(.isCloseButtonTapped(true)) },
          titleText: selectedDateToStrViewStore.state,
          titleSubImage: R.CustomImage.arrowDownIcon.image,
          isButtonTitle: true,
          titleButtonAction: {
            ViewStore(store).send(.navigationBarDateButtonTapped)
            hideKeyboard()
          },
          rightButtonText: "다음",
          rightButtonAction: { ViewStore(store).send(.setRecordKeywordPushed(true)) },
          rightButtonAbled: isNextButtonAbledViewStore.binding(
            get: { $0 },
            send: RecordAction.setNextButtonAbled(true)
          )
        )
      }
      WithViewStore(store.scope(state: \.local.isRecordKeywordPushed)) { isRecordKeywordPushedViewStore in
        NavigationLink(
          destination: IfLetStore(
            store.scope(
              state: \.recordKeyword,
              action: RecordAction.recordKeyword
            ),
            then: RecordKeywordView.init(store: )
          ),
          isActive: isRecordKeywordPushedViewStore.binding(
            send: RecordAction.setRecordKeywordPushed
          ),
          label: {
            EmptyView()
          }
        )
        .isDetailLink(true)
      }
    }
  }
}

private struct TitleTextView: View {
  private let store: Store<WithSharedState<RecordState>, RecordAction>

  init(store: Store<WithSharedState<RecordState>, RecordAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.titleText)) { titleTextViewStore in
      TextField(
        text: titleTextViewStore.binding(
          get: { $0 },
          send: { RecordAction.titletextFieldChanged($0) }
        ), label: {}
      )
      .introspectTextField { textField in
        textField.becomeFirstResponder()
      }
      .foregroundColor(.gray2)
      .placeholder(when: titleTextViewStore.isEmpty, placeholder: {
        Text("제목 (최대 20자)")
          .foregroundColor(.gray8)
      })
      .font(.title3)
      .onTapGesture {
        hideKeyboard()
      }
    }
  }
}

private struct MainTextView: View {
  private let store: Store<WithSharedState<RecordState>, RecordAction>
  @State var placeholederText: String = "오늘은 어떤 꿈을 꾸셨나요?"

  init(store: Store<WithSharedState<RecordState>, RecordAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.mainText)) { mainTextViewStore in
      ZStack {
        if mainTextViewStore.state.isEmpty {
          TextEditor(text: $placeholederText)
            .foregroundColor(.gray8)
            .font(.body2)
            .disabled(true)
        }
        TextEditor(text: mainTextViewStore.binding(
          get: { $0 },
          send: { RecordAction.mainTextFieldChanged($0) }
        ))
        .foregroundColor(.gray3)
        .font(.body2)
        .opacity(mainTextViewStore.state.isEmpty ? 0.25 : 1)
        .onTapGesture {
          hideKeyboard()
        }
      }
      .adaptsToKeyboard()
    }
  }
}

private struct CountTextView: View {
  private let store: Store<WithSharedState<RecordState>, RecordAction>
  @State var keyboardYOffset: CGFloat = 0

  init(store: Store<WithSharedState<RecordState>, RecordAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.mainText)) { mainTextViewStore in
      let text = mainTextViewStore.state.count == 0 ? "nnnn" : "\(mainTextViewStore.state.count)"
      Text(text + "/2000")
        .onKeyboard($keyboardYOffset)
    }
    .frame(minWidth: 61, maxHeight: 16, alignment: .center)
  }
}

extension View {
  fileprivate func selectDateSheet(
    store: Store<WithSharedState<RecordState>, RecordAction>
  ) -> some View {
    let viewStore = ViewStore(store.scope(state: \.local))

    return self.apply(content: { view in
      WithViewStore(store.scope(state: \.local.isSelectDateSheetPresented)) { _ in
        view.bottomSheet(
          title: "",
          isPresented: viewStore.binding(
            get: \.isSelectDateSheetPresented,
            send: RecordAction.setSelectDateSheetPresented
          ),
          content: {
            WithViewStore(store.scope(state: \.local.currentDate)) { selectedDateViewStore in
              HStack(spacing: 0) {
                DatePicker(
                  "",
                  selection: selectedDateViewStore.binding(
                    get: { $0 },
                    send: RecordAction.setSelectedDate
                  ),
                  displayedComponents: .date
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
              }
            }
          },
          bottomArea: {
            Button(action: { ViewStore(store).send(.confirmDateButtonTapped) }) {
              HStack {
                Spacer()
                Text("확인")
                  .font(.button)
                  .foregroundColor(.gray10)
                  .padding(.vertical, 12)
                Spacer()
              }
            }
            .background(Color.gray1)
            .cornerRadius(8)
          }
        )
      }
    })
  }
}
