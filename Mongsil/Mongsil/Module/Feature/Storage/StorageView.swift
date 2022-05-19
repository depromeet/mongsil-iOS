//
//  StorageView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import SwiftUI
import ComposableArchitecture

struct StorageView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    GeometryReader { geometry in
      VStack {
        VStack {
          StorageNavigationView(store: store)
          IntroduceView(store: store)
            .padding(.top, 24)
          DiaryCountView(store: store)
            .padding(.top, 16)
        }
        .padding(.horizontal, 20)
        SegmentDiaryOrDreamView(store: store)
          .padding(.top, 24)
      }
      .navigationTitle("")
      .navigationBarHidden(true)
      .onAppear(perform: { ViewStore(store).send(.onAppear) })
      .selectDateSheet(
        store: store,
        width: geometry.width / 2
      )
    }
  }
}

private struct StorageNavigationView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.selectedDateToStr)) { selectedDateToStrViewStore in
      WithViewStore(store.scope(state: \.local.displayDeleteCardHeader)) { displayDeleteCardHeaderViewStore in
        WithViewStore(store.scope(state: \.local.displayNavigationTitle)) { displayNavigationTitleViewStore in
          MSNavigationBar(
            titleText: selectedDateToStrViewStore.state,
            titleSubImage: R.CustomImage.arrowDownIcon.image,
            isButtonTitle: !displayDeleteCardHeaderViewStore.state,
            titleButtonAction: { ViewStore(store).send(.navigationBarDateButtonTapped) },
            rightButtonImage: R.CustomImage.settingIcon.image,
            rightButtonAction: { ViewStore(store).send(.setSettingPushed(true)) },
            displayTitle: displayNavigationTitleViewStore.state
          )
        }
      }
    }
    WithViewStore(store.scope(state: \.local.isSettingPushed)) { isSettingPushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.setting,
            action: StorageAction.setting
          ),
          then: SettingView.init(store: )
        ),
        isActive: isSettingPushedViewStore.binding(
          send: StorageAction.setSettingPushed
        ),
        label: {
          EmptyView()
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct IntroduceView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    HStack {
      WithViewStore(store.scope(state: \.local.userName)) { userNameViewStore in
        Text("\(userNameViewStore.state)님의 꿈이\n차곡차곡 쌓이고 있어요.")
          .foregroundColor(.msWhite)
          .font(.title1)
          .lineSpacing(10)
      }
      Spacer()
    }
  }
}

private struct DiaryCountView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    HStack {
      WithViewStore(store.scope(state: \.local.diaryCount)) { diaryCountViewStore in
        Text("이번달에는 꿈을 \(diaryCountViewStore.state)번 꿨어요.")
          .foregroundColor(.gray6)
          .font(.body2)
      }
      Spacer()
    }
  }
}

private struct SegmentDiaryOrDreamView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.selectedTab)) { selectedTabViewStore in
      SegmentView<StorageState.Tab>(
        title: [
          .diary: "꿈일기",
          .dream: "해몽함"
        ],
        views: [
          .diary:
            VStack(spacing: 0) {
              WithViewStore(store.scope(state: \.local.displayDeleteCardHeader)) { displayDeleteCardHeaderViewStore in
                if displayDeleteCardHeaderViewStore.state {
                  DeleteCardHeaderView(
                    store: store,
                    completeAction: { ViewStore(store).send(.completeButtonTapped(.diary)) },
                    clearSelectionAction: { ViewStore(store).send(.clearSelectionButtonTapped(.diary)) },
                    deleteAction: { ViewStore(store).send(.deleteButtonTapped(.diary)) }
                  )
                  Spacer()
                    .frame(height: 4)
                }
              }
              DiaryListView(store: store)
            }
            .eraseToAnyView(),
          .dream:
            VStack(spacing: 0) {
              WithViewStore(store.scope(state: \.local.displayDeleteCardHeader)) { displayDeleteCardHeaderViewStore in
                if displayDeleteCardHeaderViewStore.state {
                  DeleteCardHeaderView(
                    store: store,
                    completeAction: { ViewStore(store).send(.completeButtonTapped(.dream)) },
                    clearSelectionAction: { ViewStore(store).send(.clearSelectionButtonTapped(.dream)) },
                    deleteAction: { ViewStore(store).send(.deleteButtonTapped(.dream)) }
                  )
                  Spacer()
                    .frame(height: 4)
                }
              }
              DreamListView(store: store)
            }
            .eraseToAnyView()
        ],
        selection: selectedTabViewStore.binding(
          get: { $0 },
          send: StorageAction.tabTapped
        )
      )
    }
  }
}

private struct DeleteCardHeaderView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>
  var completeAction: () -> Void = {}
  var clearSelectionAction: () -> Void = {}
  var deleteAction: () -> Void = {}

  init(
    store: Store<WithSharedState<StorageState>, StorageAction>,
    completeAction: @escaping () -> Void = {},
    clearSelectionAction: @escaping () -> Void = {},
    deleteAction: @escaping () -> Void = {}
  ) {
    self.store = store
    self.completeAction = completeAction
    self.clearSelectionAction = clearSelectionAction
    self.deleteAction = deleteAction
  }

  var body: some View {
    HStack(spacing: 0) {
      Button(action: completeAction) {
        Text("완료")
          .font(.button)
          .foregroundColor(.gray2)
      }
      Spacer()
      WithViewStore(store.scope(state: \.local.selectedDeleteCardCount)) { selectedDeleteCardCountViewStore in
        if selectedDeleteCardCountViewStore.state != 0 {
          Button(action: clearSelectionAction) {
            Text("선택해제 \(selectedDeleteCardCountViewStore.state)")
              .font(.button)
              .foregroundColor(.gray2)
          }
        }
        Spacer()
        Button(action: deleteAction) {
          Text("삭제")
            .font(.button)
            .foregroundColor(
              selectedDeleteCardCountViewStore.state == 0
              ? .gray8
              : .gray2
            )
        }
        .disabled(selectedDeleteCardCountViewStore.state == 0)
      }
    }
    .padding(.top, 14)
    .padding(.horizontal, 20)
  }
}

private struct DiaryListView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>
  @GestureState private var dragState = false

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.diaryListWithDate)) { diaryListViewStore in
      if let diaryList = diaryListViewStore.state,
         diaryList.isNotEmpty {
        ScrollView {
          VStack {
            ForEach(diaryList, id: \.self) { diary in
              DiaryCardView(
                store: store,
                diary: diary
              )
              .gesture(
                LongPressGesture(minimumDuration: 1.0)
                  .sequenced(before: DragGesture())
                  .updating($dragState) { _, _, _ in
                    withAnimation {
                      ViewStore(store).send(.setDisplayDeleteCardHeader(true))
                    }
                  }
              )
              .padding(.top, 16)
              .padding(.horizontal, 20)
            }
            Spacer()
              .frame(height: 100)
          }
        }
        .overlay(
          VStack {
            Spacer()
            Rectangle()
              .foregroundColor(.gray11)
              .opacity(0.8)
              .frame(maxWidth: .infinity, maxHeight: 90)
              .background {
                Color.gray11
                  .opacity(0.8)
                  .blur(radius: 0)
              }
          }
        )
        .frame(maxWidth: .infinity)
        DiaryLinkView(store: store)
      } else {
        EmptyDiaryOrDreamView(description: "아직 기록된 꿈일기가 없어요.")
      }
    }
  }
}

private struct DiaryCardView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>
  var diary: Diary
  var title: String
  var description: String
  var date: String
  var firstImage: Image
  var secondImage: Image

  init(
    store: Store<WithSharedState<StorageState>, StorageAction>,
    diary: Diary,
    firstImage: Image = R.CustomImage.homeDisabledIcon.image,
    secondImage: Image = R.CustomImage.homeActiveIcon.image
  ) {
    self.store = store
    self.diary = diary
    self.title = diary.title
    self.description = diary.description
    self.date = diary.date
    self.firstImage = firstImage
    self.secondImage = secondImage
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.displayDeleteCardHeader)) { displayDeleteCardHeaderViewStore in
      WithViewStore(store.scope(state: \.local.deleteDiaryList)) { deleteDiaryListViewStore in
        HStack {
          if displayDeleteCardHeaderViewStore.state {
            Spacer()
              .frame(width: 12)
            if deleteDiaryListViewStore.state.contains(self.diary) {
              R.CustomImage.checkIcon.image
            } else {
              R.CustomImage.nonCheckIcon.image
            }
          }
          Spacer()
            .frame(width: displayDeleteCardHeaderViewStore.state ? 12 : 20)
          VStack(alignment: .leading) {
            Spacer()
              .frame(height: 18)
            Text(title)
              .font(.subTitle)
              .foregroundColor(.gray2)
              .lineLimit(1)
              .padding(.bottom, 2)
            Text(description)
              .font(.caption1)
              .foregroundColor(.gray3)
              .lineLimit(1)
              .padding(.bottom, 10)
            Text(date)
              .font(.caption1)
              .foregroundColor(.gray6)
            Spacer()
              .frame(height: 16)
          }
          Spacer()
          HStack {
            firstImage
            secondImage
          }
          Spacer()
            .frame(width: 20)
        }
        .background(
          deleteDiaryListViewStore.state.contains(self.diary) && displayDeleteCardHeaderViewStore.state
          ? Color.gray8
          : Color.gray10
        )
        .gesture(
          TapGesture()
            .onEnded { _ in
              ViewStore(store).send(.diaryTapped(diary))
            }
        )
      }
    }
    .cornerRadius(8)
  }
}

private struct DreamListView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>
  @GestureState private var dragState = false

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    GeometryReader { geometry in
      WithViewStore(store.scope(state: \.local.userDreamList)) { userDreamListViewStore in
        if let userDreamList = userDreamListViewStore.state {
          ScrollView {
            let columns: [GridItem] = [
              GridItem(.fixed((geometry.width / 2) - 24.5)),
              GridItem(.fixed((geometry.width / 2) - 24.5))
            ]
            LazyVGrid(
              columns: columns,
              spacing: 9
            ) {
              ForEach(userDreamList, id: \.self) { dream in
                DreamCardView(
                  store: store,
                  dream: dream
                )
                .gesture(
                  LongPressGesture(minimumDuration: 1.0)
                    .sequenced(before: DragGesture())
                    .updating($dragState) { _, _, _ in
                      withAnimation {
                        ViewStore(store).send(.setDisplayDeleteCardHeader(true))
                      }
                    }
                )
                .padding(.top, 7)
              }
              Spacer()
                .frame(height: 100)
            }
            .padding(.horizontal, 20)
          }
          .overlay(
            VStack {
              Spacer()
              Rectangle()
                .foregroundColor(.gray11)
                .opacity(0.8)
                .frame(maxWidth: .infinity, maxHeight: 90)
                .background {
                  Color.gray11
                    .opacity(0.8)
                    .blur(radius: 0)
                }
            }
          )
          .frame(maxWidth: .infinity)
          DreamLinkView(store: store)
        } else {
          EmptyDiaryOrDreamView(description: "아직 저장된 해몽이 없어요.")
        }
      }
      .padding(.top, 15)
    }
  }
}

private struct DreamCardView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>
  var dream: UserDream
  var title: String
  var description: String
  var firstImage: Image
  var secondImage: Image

  init(
    store: Store<WithSharedState<StorageState>, StorageAction>,
    dream: UserDream,
    firstImage: Image = R.CustomImage.homeDisabledIcon.image,
    secondImage: Image = R.CustomImage.homeActiveIcon.image
  ) {
    self.store = store
    self.dream = dream
    self.title = dream.title
    self.description = dream.description
    self.firstImage = firstImage
    self.secondImage = secondImage
  }

  var body: some View {
      WithViewStore(store.scope(state: \.local.displayDeleteCardHeader)) { displayDeleteCardHeaderViewStore in
        WithViewStore(store.scope(state: \.local.deleteUserDreamList)) { deleteUserDreamListViewStore in
          VStack(alignment: .leading) {
            HStack(spacing: 4) {
              firstImage
              secondImage
              Spacer()
              if displayDeleteCardHeaderViewStore.state {
                if deleteUserDreamListViewStore.state.contains(self.dream) {
                  R.CustomImage.checkIcon.image
                } else {
                  R.CustomImage.nonCheckIcon.image
                }
              }
            }
            .padding(.top, 20)
            Text(title)
              .font(.subTitle)
              .foregroundColor(.msWhite)
              .multilineTextAlignment(.leading)
              .lineLimit(2)
              .padding(.top, 10)
            Text(description)
              .font(.caption1)
              .foregroundColor(.gray3)
              .multilineTextAlignment(.leading)
              .lineLimit(3)
              .padding(.top, 10)
            Spacer()
          }
          .padding(.horizontal, 14)
          .background(
            deleteUserDreamListViewStore.state.contains(self.dream) && displayDeleteCardHeaderViewStore.state
            ? Color.gray8
            : Color.gray10
          )
          .gesture(
            TapGesture()
              .onEnded { _ in
                ViewStore(store).send(.dreamTapped(dream))
              }
          )
          .frame(height: 180)
          .cornerRadius(8)
        }
      }
  }
}

private struct EmptyDiaryOrDreamView: View {
  let description: String

  init(description: String) {
    self.description = description
  }

  var body: some View {
    VStack {
      Spacer()
        .frame(height: 200)
      Text(description)
        .font(.body2)
        .foregroundColor(.gray6)
    }
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

private struct DreamLinkView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isDreamPushed)) { isDreamPushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.dream,
            action: StorageAction.dream
          ),
          then: DreamView.init(store: )
        ),
        isActive: isDreamPushedViewStore.binding(
          send: { StorageAction.setDreamPushed($0) }
        ),
        label: {
          EmptyView()
        }
      )
      .isDetailLink(true)
    }
  }
}

extension View {
  fileprivate func selectDateSheet(
    store: Store<WithSharedState<StorageState>, StorageAction>,
    width: CGFloat
  ) -> some View {
    let viewStore = ViewStore(store.scope(state: \.local))

    return self.apply(content: { view in
      WithViewStore(store.scope(state: \.local.isSelectDateSheetPresented)) { _ in
        view.bottomSheet(
          title: "월 선택",
          isPresented: viewStore.binding(
            get: \.isSelectDateSheetPresented,
            send: StorageAction.setSelectDateSheetPresented
          ),
          content: {
            HStack(spacing: 0) {
              YearPickerView(
                store: store,
                width: width
              )
              MonthPickerView(
                store: store,
                width: width
              )
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

private struct YearPickerView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>
  private let width: CGFloat
  private let years = Array(2000...2099).map( String.init )

  init(
    store: Store<WithSharedState<StorageState>, StorageAction>,
    width: CGFloat
  ) {
    self.store = store
    self.width = width
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.selectedYear)) { selectedYearViewStore in
      Picker(
        "",
        selection: selectedYearViewStore.binding(
          get: { $0 },
          send: StorageAction.setSelectedYear
        )
      ) {
        ForEach(years, id: \.self) { year in
          HStack(alignment: .center, spacing: 0) {
            Spacer()
              .frame(width: 30)
            Text(year)
              .foregroundColor(.gray2)
          }
        }
      }
      .frame(width: width)
      .clipped()
      .pickerStyle(InlinePickerStyle())
    }
  }
}

private struct MonthPickerView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>
  private let width: CGFloat
  private let months = Array(1...12).map({ String(format: "%02d", $0) })

  init(
    store: Store<WithSharedState<StorageState>, StorageAction>,
    width: CGFloat
  ) {
    self.store = store
    self.width = width
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.selectedMonth)) { selectedMonthViewStore in
      Picker(
        "",
        selection: selectedMonthViewStore.binding(
          get: { $0 },
          send: StorageAction.setSelectedMonth
        )
      ) {
        ForEach(months, id: \.self) { month in
          HStack(alignment: .center, spacing: 0) {
            Text(month)
              .foregroundColor(.gray2)
            Spacer()
              .frame(width: 30)
          }
        }
      }
      .frame(width: width)
      .clipped()
      .pickerStyle(InlinePickerStyle())
    }
  }
}
