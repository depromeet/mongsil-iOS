//
//  RecordKeywordView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/15.
//

import SwiftUI
import ComposableArchitecture

struct RecordKeywordView: View {
  private let store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>
  
  init(store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>) {
    self.store = store
  }
  
  var body: some View {
    VStack {
      ScrollView {
        RecordKeywordNavigationView(store: store)
          .overlay {
            DateTitle(store: store)
              .font(.subTitle)
              .padding(.top, 10)
              .padding(.bottom, 10)
              .frame(minWidth: 112, minHeight: 24, alignment: .center)
              .foregroundColor(.gray2)
          }
      }
      VStack {
        Text("꿈 키워드 뷰")
        Spacer()
      }
      .navigationTitle("")
      .navigationBarHidden(true)
    }
    .selectDateSheet(store: store)
    .frame(alignment: .center)
  }
}

struct RecordKeywordNavigationView: View {
  private let store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>
  
  init(store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store.scope(state: \.local.isStroeButtonAbled)) { isStroeButtonAbledViewStore in
      MSNavigationBar(
        backButtonImage: R.CustomImage.backIcon.image,
        backButtonAction: {
          ViewStore(store).send(.backButtonTapped)},
        rightButtonText: "다음",
        rightButtonAction: {},
        rightButtonAbled: isStroeButtonAbledViewStore.binding(
          get: { $0 },
          send: RecordKeywordAction.setNextButtonAbled(true)
        )
      )
    }
  }
}

private struct DateTitle: View {
  private let store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>
  
  init(store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>) {
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

extension View {
  fileprivate func selectDateSheet(
    store: Store<WithSharedState<RecordKeywordState>, RecordKeywordAction>
  ) -> some View {
    let viewStore = ViewStore(store.scope(state: \.local))
    
    return self.apply(content: { view in
      WithViewStore(store.scope(state: \.local.isSelectDateSheetPresented)) { _ in
        view.bottomSheet(
          title: "",
          isPresented: viewStore.binding(
            get: \.isSelectDateSheetPresented,
            send: RecordKeywordAction.setSelectDateSheetPresented
          ),
          content: {
            WithViewStore(store.scope(state: \.local.currentDate)) { selectedDateViewStore in
              HStack(spacing: 0) {
                DatePicker(
                  "",
                  selection: selectedDateViewStore.binding(
                    get: { $0 },
                    send: RecordKeywordAction.setSelectedDate
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
