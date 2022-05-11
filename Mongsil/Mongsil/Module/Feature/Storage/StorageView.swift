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
  }
}

private struct StorageNavigationView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    ZStack {
      MSNavigationBar(
        titleText: "보관함",
        isUseBackButton: false
      )
      HStack {
        Spacer()
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
              R.CustomImage.settingIcon.image
            }
          )
          .isDetailLink(true)
          .padding(.trailing, 20)
        }
      }
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
          .dream: "해몽"
        ],
        views: [
          .diary: DiaryListView(store: store)
          .eraseToAnyView(),
          .dream: DreamListView(store: store)
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

private struct DiaryListView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.diaryList)) { diaryListViewStore in
      if let diaryList = diaryListViewStore.state {
        ScrollView {
          VStack {
            ForEach(diaryList, id: \.self) { diary in
              DiaryCardView(
                store: store,
                diary: diary
              )
              .padding(.top, 16)
              .padding(.horizontal, 20)
            }
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
    Button(action: { ViewStore(store).send(.diaryTapped(diary)) }) {
      HStack {
        Spacer()
          .frame(width: 20)
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
      .background(Color.gray10)
    }
    .cornerRadius(8)
  }
}

private struct DreamListView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    GeometryReader { geometry in
      WithViewStore(store.scope(state: \.local.dreamList)) { dreamListViewStore in
        if let dreamList = dreamListViewStore.state {
          ScrollView {
            let columns: [GridItem] = [
              GridItem(.fixed((geometry.width / 2) - 24.5)),
              GridItem(.fixed((geometry.width / 2) - 24.5))
            ]
            LazyVGrid(
              columns: columns,
              spacing: 9
            ) {
              ForEach(dreamList, id: \.self) { dream in
                DreamCardView(
                  store: store,
                  dream: dream
                )
                .padding(.top, 7)
              }
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
  var dream: DreamInfo
  var title: String
  var description: String
  var firstImage: Image
  var secondImage: Image

  init(
    store: Store<WithSharedState<StorageState>, StorageAction>,
    dream: DreamInfo,
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
    Button(action: { ViewStore(store).send(.dreamTapped(dream)) }) {
      VStack(alignment: .leading) {
        HStack(spacing: 4) {
          firstImage
          secondImage
          Spacer()
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
      .background(Color.gray10)
    }
    .frame(height: 180)
    .cornerRadius(8)
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
