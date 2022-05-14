//
//  RecordView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import SwiftUI
import ComposableArchitecture

struct RecordView: View {
  private let store: Store<WithSharedState<RecordState>, RecordAction>
  
  init(store: Store<WithSharedState<RecordState>, RecordAction>) {
    self.store = store
  }
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView {
        VStack {
          MsNavigationView(store: store)
            .overlay {
              DateTitle(store: store)
            }
          TitleTextView(store: store)
            .frame(width: 375, height: 56, alignment: .trailing)
            .padding(.top, 8)
            .foregroundColor(.gray2)
          Divider()
            .frame(width: 375, alignment: .trailing)
            .padding(.bottom, 16)
          MainTextView(store: store)
            .frame(height: 644, alignment: .center)
            .padding(.leading, 28)
            .padding(.trailing, 28)
            .foregroundColor(.gray8)
            .alertDoubleButton(
              store: store.scope(
                state: \.local.closeButtonAlertModal,
                action: RecordAction.closeButtonAlertModal
              )
            )
          Spacer()
          CountTextView(store: store)
            .font(.caption2)
            .foregroundColor(.gray6)
            .padding(.bottom, 10)
            .frame(minWidth: 61, maxHeight: 16, alignment: .center)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        
        .padding(.horizontal, 20)
        .selectDateSheet(
          store: store,
          height: geometry.height / 2.5
        )
      }
    }
  }
}

private struct MsNavigationView: View {
  private let store: Store<WithSharedState<RecordState>, RecordAction>
  
  init(store: Store<WithSharedState<RecordState>, RecordAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store.scope(state: \.local.isNextButtonAbled)) { isNextButtonAbledViewStore in
      MSNavigationBar(
        backButtonImage: R.CustomImage.cancelIcon.image,
        backButtonAction: {ViewStore(store).send(.isCloseButtonTapped(true))},
        rightButtonText: "다음",
        rightButtonAction: {},
        rightButtonAbled: isNextButtonAbledViewStore.binding(
          get: { $0 },
          send: RecordAction.setNextButtonAbled
        )
      )
    }
  }
}

private struct DateTitle: View {
  private let store: Store<WithSharedState<RecordState>, RecordAction>
  
  init(store: Store<WithSharedState<RecordState>, RecordAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store.scope(state: \.local.selectedDateToStr)) { selectedDateToStrViewStore in
      HStack{
        Button(action: { ViewStore(store).send(.navigationBarDateButtonTapped) }) {
          Text("\(selectedDateToStrViewStore.state)")
          R.CustomImage.arrowDownIcon.image
        }
        .foregroundColor(.gray2)
        .padding(.top ,10)
        .padding(.bottom, 10)
        .frame(minWidth: 84, minHeight: 24, alignment: .center)
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
        "",
        text: titleTextViewStore.binding(
          get: { $0 },
          send: { RecordAction.titletextFieldChanged($0) }
        )
      )
      .placeholder(when: titleTextViewStore.state.isEmpty) {
        Text("제목 (최대 40자)")
          .font(.title3)
          .foregroundColor(.gray8)
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
            .font(.body2)
            .disabled(true)
        }
        TextEditor(text: mainTextViewStore.binding(
          get: { $0 },
          send: { RecordAction.mainTextFieldChanged($0) }
        ))
        .foregroundColor(.gray3)
        .opacity(mainTextViewStore.state.isEmpty ? 0.3 : 1)
        .onTapGesture {
          hideKeyboard()
        }
      }
    }
  }
}

private struct CountTextView: View {
  private let store: Store<WithSharedState<RecordState>, RecordAction>
  
  init(store: Store<WithSharedState<RecordState>, RecordAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store.scope(state: \.local.mainText)) { mainTextViewStore in
      if mainTextViewStore.state.count == 0 {
        Text("nnnn/2000")
      }
      else {
        let num = mainTextViewStore.state.count
        Text("\(num)/2000")
      }
    }
  }
}

extension View {
  fileprivate func selectDateSheet(
    store: Store<WithSharedState<RecordState>, RecordAction>,
    height: CGFloat
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
                .frame(height: height)
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

extension View {
  fileprivate func hideKeyboard() {
    let resign = #selector(UIResponder.resignFirstResponder)
    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
  }
}
