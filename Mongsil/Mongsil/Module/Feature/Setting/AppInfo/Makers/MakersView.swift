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
        .padding(.leading, 20)
      //      MakersCardView(store: store, makers: makers)
      Spacer()
    }
    .navigationTitle("")
    .navigationBarHidden(true)
  }
}

private struct MakersWelcomeView: View {
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("안녕하세요\n좋은 꿈 꾸셨나요?")
          .foregroundColor(.msWhite)
          .font(.title1)
          .lineSpacing(10)
        Spacer()
      }
      .padding(.bottom, 16)
      Text("팀 벽력일삼⚡️을 소개할게요.")
        .foregroundColor(.gray6)
        .font(.body2)
        .padding(.bottom, 24)
    }
  }
}

private struct makersListView: View {
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
              MakersCardListView(
                store: store,
                makers: makers
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
      }
    }
  }
}

private struct MakersCardListView: View {
  private let store: Store<WithSharedState<MakersState>, MakersAction>
  var makers: Makers
  var name: String
  var description: String
  var firstImage: Image
  var secondImage: Image
  
  init(
    store: Store<WithSharedState<MakersState>, MakersAction>,
    makers: Makers,
    firstImage: Image = R.CustomImage.homeDisabledIcon.image,
    secondImage: Image = R.CustomImage.homeActiveIcon.image
  ) {
    self.store = store
    self.makers = makers
    self.name = makers.name
    self.description = makers.position
    self.firstImage = firstImage
    self.secondImage = secondImage
  }
  
  var body: some View {
    
    VStack(alignment: .leading) {
      Spacer()
        .frame(height: 18)
      Text(name)
        .font(.subTitle)
        .foregroundColor(.gray2)
        .lineLimit(1)
        .padding(.bottom, 2)
      Text(description)
        .font(.caption1)
        .foregroundColor(.gray3)
        .lineLimit(1)
        .padding(.bottom, 10)
      Text(description)
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
  }
}


//    ScrollView {
//      Button(action:{openURL(URL(string: "https://github.com/MoSonLee")!)}) {
//        HStack {
//          VStack(alignment: .leading) {
//            Spacer()
//              .frame(height: 18)
//            Text("박종호")
//              .font(.subTitle)
//              .foregroundColor(.gray2)
//              .padding(.bottom, 2)
//              .padding(.leading, 20)
//            Text("PM")
//              .font(.caption1)
//              .foregroundColor(.gray3)
//              .padding(.bottom, 18)
//              .padding(.leading, 20)
//            Spacer()
//              .frame(height: 16)
//          }
//          Spacer()
//          HStack {
//            firstImage
//            secondImage
//          }
//          Spacer()
//            .frame(width: 20)
//        }
//      }
//      .background(Color.gray10)
//      .cornerRadius(8)
//      .padding(.bottom, 16)
//      Button(action:{openURL(URL(string: "https://github.com/MoSonLee")!)}) {
//        HStack {
//          VStack(alignment: .leading) {
//            Spacer()
//              .frame(height: 18)
//            Text("이건웅")
//              .font(.subTitle)
//              .foregroundColor(.gray2)
//              .padding(.bottom, 2)
//              .padding(.leading, 20)
//            Text("Backend Developer")
//              .font(.caption1)
//              .foregroundColor(.gray3)
//              .padding(.bottom, 18)
//              .padding(.leading, 20)
//            Spacer()
//              .frame(height: 16)
//          }
//          Spacer()
//          HStack {
//            firstImage
//            secondImage
//          }
//          Spacer()
//            .frame(width: 20)
//        }
//      }
//      .background(Color.gray10)
//      .cornerRadius(8)
//      .padding(.bottom, 16)
//      Button(action:{openURL(URL(string: "https://github.com/MoSonLee")!)}) {
//        HStack {
//          VStack(alignment: .leading) {
//            Spacer()
//              .frame(height: 18)
//            Text("이석호")
//              .font(.subTitle)
//              .foregroundColor(.gray2)
//              .padding(.bottom, 2)
//              .padding(.leading, 20)
//            Text("Backend Developer")
//              .font(.caption1)
//              .foregroundColor(.gray3)
//              .padding(.bottom, 18)
//              .padding(.leading, 20)
//            Spacer()
//              .frame(height: 16)
//          }
//          Spacer()
//          HStack {
//            firstImage
//            secondImage
//          }
//          Spacer()
//            .frame(width: 20)
//        }
//      }
//      .background(Color.gray10)
//      .cornerRadius(8)
//      .padding(.bottom, 16)
//      Button(action:{openURL(URL(string: "https://github.com/MoSonLee")!)}) {
//        HStack {
//          VStack(alignment: .leading) {
//            Spacer()
//              .frame(height: 18)
//            Text("조찬우")
//              .font(.subTitle)
//              .foregroundColor(.gray2)
//              .padding(.bottom, 2)
//              .padding(.leading, 20)
//            Text("iOS Developer")
//              .font(.caption1)
//              .foregroundColor(.gray3)
//              .padding(.bottom, 18)
//              .padding(.leading, 20)
//            Spacer()
//              .frame(height: 16)
//          }
//          Spacer()
//          HStack {
//            firstImage
//            secondImage
//          }
//          Spacer()
//            .frame(width: 20)
//        }
//      }
//      .background(Color.gray10)
//      .cornerRadius(8)
//      .padding(.bottom, 16)
//      Button(action:{openURL(URL(string: "https://github.com/MoSonLee")!)}) {
//        HStack {
//          VStack(alignment: .leading) {
//            Spacer()
//              .frame(height: 18)
//            Text("이승후")
//              .font(.subTitle)
//              .foregroundColor(.gray2)
//              .padding(.bottom, 2)
//              .padding(.leading, 20)
//            Text("iOS Developer")
//              .font(.caption1)
//              .foregroundColor(.gray3)
//              .padding(.bottom, 18)
//              .padding(.leading, 20)
//            Spacer()
//              .frame(height: 16)
//          }
//          Spacer()
//          HStack {
//            firstImage
//            secondImage
//          }
//          Spacer()
//            .frame(width: 20)
//        }
//      }
//      .background(Color.gray10)
//      .cornerRadius(8)
//      .padding(.bottom, 16)
//      Button(action:{openURL(URL(string: "https://github.com/MoSonLee")!)}) {
//        HStack {
//          VStack(alignment: .leading) {
//            Spacer()
//              .frame(height: 18)
//            Text("이영은")
//              .font(.subTitle)
//              .foregroundColor(.gray2)
//              .padding(.bottom, 2)
//              .padding(.leading, 20)
//            Text("iOS Developer")
//              .font(.caption1)
//              .foregroundColor(.gray3)
//              .padding(.bottom, 18)
//              .padding(.leading, 20)
//            Spacer()
//              .frame(height: 16)
//          }
//          Spacer()
//          HStack {
//            firstImage
//            secondImage
//          }
//          Spacer()
//            .frame(width: 20)
//        }
//      }
//      .background(Color.gray10)
//      .cornerRadius(8)
//      .padding(.bottom, 16)
//      Button(action:{openURL(URL(string: "https://github.com/MoSonLee")!)}) {
//        HStack {
//          VStack(alignment: .leading) {
//            Spacer()
//              .frame(height: 18)
//            Text("정진아")
//              .font(.subTitle)
//              .foregroundColor(.gray2)
//              .padding(.bottom, 2)
//              .padding(.leading, 20)
//            Text("Designer")
//              .font(.caption1)
//              .foregroundColor(.gray3)
//              .padding(.bottom, 18)
//              .padding(.leading, 20)
//            Spacer()
//              .frame(height: 16)
//          }
//          Spacer()
//          HStack {
//            firstImage
//            secondImage
//          }
//          Spacer()
//            .frame(width: 20)
//        }
//      }
//      .background(Color.gray10)
//      .cornerRadius(8)
//      .padding(.bottom, 16)
//      Button(action:{openURL(URL(string: "https://github.com/MoSonLee")!)}) {
//        HStack {
//          VStack(alignment: .leading) {
//            Spacer()
//              .frame(height: 18)
//            Text("김나영")
//              .font(.subTitle)
//              .foregroundColor(.gray2)
//              .padding(.bottom, 2)
//              .padding(.leading, 20)
//            Text("Designer")
//              .font(.caption1)
//              .foregroundColor(.gray3)
//              .padding(.bottom, 18)
//              .padding(.leading, 20)
//            Spacer()
//              .frame(height: 16)
//          }
//          Spacer()
//          HStack {
//            firstImage
//            secondImage
//          }
//          Spacer()
//            .frame(width: 20)
//        }
//      }
//      .background(Color.gray10)
//      .cornerRadius(8)
//      .padding(.bottom, 16)
//      Button(action:{openURL(URL(string: "https://github.com/MoSonLee")!)}) {
//        HStack {
//          VStack(alignment: .leading) {
//            Spacer()
//              .frame(height: 18)
//            Text("이영희")
//              .font(.subTitle)
//              .foregroundColor(.gray2)
//              .padding(.bottom, 2)
//              .padding(.leading, 20)
//            Text("Designer")
//              .font(.caption1)
//              .foregroundColor(.gray3)
//              .padding(.bottom, 18)
//              .padding(.leading, 20)
//            Spacer()
//              .frame(height: 16)
//          }
//          Spacer()
//          HStack {
//            firstImage
//            secondImage
//          }
//          Spacer()
//            .frame(width: 20)
//        }
//      }
//      .background(Color.gray10)
//      .cornerRadius(8)
//    }
