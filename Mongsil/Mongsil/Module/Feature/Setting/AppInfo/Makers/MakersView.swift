//
//  MakersView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/21.
//

import ComposableArchitecture
import SwiftUI

struct MakersView: View {
  private let store: Store<WithSharedState<MakersState>, MakersAction>

  init(store: Store<WithSharedState<MakersState>, MakersAction>) {
    self.store = store
  }

  var body: some View {
    VStack {
      MSNavigationBar(
        backButtonImage: R.CustomImage.backIcon.image,
        backButtonAction: { ViewStore(store).send(.backButtonTapped) },
        titleText: "만든 사람들"
      )
      .padding(.horizontal, 20)
      .padding(.bottom, 24)
      MakersWelcomeView()
      MakersCardListView(store: store)
      Spacer()
    }
    .navigationTitle("")
    .navigationBarHidden(true)
    .onAppear(perform: { ViewStore(store).send(.onAppear) })
  }
}

private struct MakersWelcomeView: View {
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("안녕하세요\n좋은 꿈 꾸셨나요?")
          .foregroundColor(.msWhite)
          .font(.title1)
          .lineSpacing(1)
        Spacer()
      }
      .padding(.bottom, 16)
      Text("팀 벽력일삼⚡️을 소개할게요.")
        .foregroundColor(.gray6)
        .font(.body2)
        .padding(.bottom, 24)
    }
    .padding(.leading, 20)
  }
}

private struct MakersCardListView: View {
  private let store: Store<WithSharedState<MakersState>, MakersAction>

  init(store: Store<WithSharedState<MakersState>, MakersAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.makersList)) { makersListViewStore in
      if let makersList = makersListViewStore.state {
        ScrollView {
          VStack {
            ForEach(makersList, id: \.self) { makers in
              MakersCardView(
                store: store,
                makers: makers
              )
              .padding(.horizontal, 20)
            }
          }
        }
      }
    }
  }
}

private struct MakersCardView: View {
  private let store: Store<WithSharedState<MakersState>, MakersAction>
  var makers: Makers
  var name: String
  var position: String
  var firstImage: Image
  var secondImage: Image
  var makersURL: URL

  init(
    store: Store<WithSharedState<MakersState>, MakersAction>,
    makers: Makers,
    firstImage: Image = R.CustomImage.homeDisabledIcon.image,
    secondImage: Image = R.CustomImage.homeActiveIcon.image
  ) {
    self.store = store
    self.makers = makers
    self.name = makers.name
    self.position = makers.position
    self.firstImage = makers.firstImage
    self.secondImage = makers.secondImage
    self.makersURL = makers.makersURL
  }

  var body: some View {
    Button(action: { ViewStore(store).send(.makersCardTapped(makersURL)) }) {
      HStack(spacing: 0) {
        VStack(alignment: .leading, spacing: 0) {
          Spacer()
            .frame(height: 18)
          Text(name)
            .font(.subTitle)
            .foregroundColor(.gray2)
            .padding(.bottom, 2)
            .padding(.leading, 20)
          Text(position)
            .font(.caption1)
            .foregroundColor(.gray3)
            .padding(.leading, 20)
          Spacer()
            .frame(height: 18)
        }
        Spacer()
        HStack {
          firstImage
          secondImage
        }
        Spacer()
          .frame(width: 20)
      }
    }
    .background(Color.gray10)
    .cornerRadius(8)
    .padding(.bottom, 16)
  }
}
