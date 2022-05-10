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
        DreamCountView(store: store)
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

private struct DreamCountView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    HStack {
      WithViewStore(store.scope(state: \.local.dreamCount)) { dreamCountViewStore in
        Text("이번달에는 꿈을 \(dreamCountViewStore.state)번 꿨어요.")
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
        ScrollView(showsIndicators: false) {
          VStack {
            ForEach(diaryList, id: \.self) { diary in
              DiaryView(
                store: store,
                title: diary.title,
                description: diary.description,
                date: diary.date
              )
              .padding(.top, 16)
              .padding(.horizontal, 20)
            }
          }
        }
        .frame(maxWidth: .infinity)
      } else {
        EmptyDiaryOrDreamView(description: "아직 기록된 꿈일기가 없어요.")
      }
    }
  }
}

private struct DiaryView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>
  var title: String
  var description: String
  var date: String
  var firstImage: Image
  var secondImage: Image

  init(
    store: Store<WithSharedState<StorageState>, StorageAction>,
    title: String,
    description: String,
    date: String,
    firstImage: Image = R.CustomImage.homeDisabledIcon.image,
    secondImage: Image = R.CustomImage.homeActiveIcon.image
  ) {
    self.store = store
    self.title = title
    self.description = description
    self.date = date
    self.firstImage = firstImage
    self.secondImage = secondImage
  }

  var body: some View {
    Button(action: { ViewStore(store).send(.dreamTapped) }) {
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
          ScrollView(showsIndicators: false) {
            let columns: [GridItem] = [
              GridItem(.fixed((geometry.width / 2) - 24.5)),
              GridItem(.fixed((geometry.width / 2) - 24.5))
            ]
            LazyVGrid(
              columns: columns,
              spacing: 9
            ) {
              ForEach(dreamList, id: \.self) { dream in
                DreamView(
                  store: store,
                  title: dream.title,
                  description: dream.description
                )
                .padding(.top, 7)
              }
            }
            .padding(.horizontal, 20)
          }
          .frame(maxWidth: .infinity)
        } else {
          EmptyDiaryOrDreamView(description: "아직 저장된 해몽이 없어요.")
        }
      }
      .padding(.top, 15)
    }
  }
}

private struct DreamView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>
  var title: String
  var description: String
  var firstImage: Image
  var secondImage: Image

  init(
    store: Store<WithSharedState<StorageState>, StorageAction>,
    title: String,
    description: String,
    firstImage: Image = R.CustomImage.homeDisabledIcon.image,
    secondImage: Image = R.CustomImage.homeActiveIcon.image
  ) {
    self.store = store
    self.title = title
    self.description = description
    self.firstImage = firstImage
    self.secondImage = secondImage
  }

  var body: some View {
    Button(action: { ViewStore(store).send(.dreamTapped) }) {
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
