//
//  CardResultView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/21.
//

import ComposableArchitecture
import SwiftUI
import NukeUI

public struct CardResultView: View {
  public let store: Store<WithSharedState<CardResultState>, CardResultAction>
  public var recordDate: String = ""
  public var imageURLs: [String] = []
  public var displayMultipleCardImage: Bool {
    imageURLs.count >= 2 ? true : false
  }
  public var title: String
  public var keywords: [String]
  public var description: String
  public var cardResult: CardResult
  public var backButtonAction: () -> Void = {}

  public init(
    store: Store<WithSharedState<CardResultState>, CardResultAction>,
    recordDate: String = "",
    imageURLs: [String] = [],
    title: String,
    keywords: [String],
    description: String,
    cardResult: CardResult,
    backButtonAction: @escaping () -> Void = {}
  ) {
    self.store = store
    self.recordDate = recordDate
    self.imageURLs = imageURLs
    self.title = title
    self.keywords = keywords
    self.description = description
    self.cardResult = cardResult
    self.backButtonAction = backButtonAction
  }

  public var body: some View {
    WithViewStore(store.scope(state: \.local.totalImage)) { totalImageViewStore in
      GeometryReader { geometry in
        VStack {
          MSNavigationBar(
            backButtonImage: R.CustomImage.cancelIcon.image,
            backButtonAction: backButtonAction,
            titleText: recordDate
          )
          ScrollView(showsIndicators: false) {
            if displayMultipleCardImage {
              MultipleCardImageView(
                firstImageURL: imageURLs.first ?? "",
                secondImageURL: imageURLs[safe: 1] ?? ""
              )
              .frame(height: abs((geometry.width - 40) / 2))
              .padding(.top, 40)
            } else {
              SingleCardImageView(imageURL: imageURLs.first ?? "")
                .frame(
                  width: (geometry.width - 40) / 2,
                  height: (geometry.width - 40) / 2
                )
                .padding(.top, 40)
            }
            CardDescriptionView(
              title: title,
              keywords: keywords,
              description: description
            )
            .background(Color.gray10)
            .cornerRadius(10)
            .padding(.top, 30)
          }
          Spacer()
            .frame(height: 36)
          BottomView(
            store: store,
            cardResult: cardResult,
            width: geometry.width
          )
          .padding(.horizontal, -20)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .padding(.horizontal, 20)
        .navigationBarHidden(true)
        .background(
          R.CustomImage.resultBackgroundImage.image
            .resizable()
            .ignoresSafeArea(.all)
        )
      }
      .onAppear(perform: { ViewStore(store).send(.onAppear) })
      .modifyAndDeleteSheet(store: store)
      .shareViewSheet(
        store: store,
        image: totalImageViewStore.state
      )
    }
  }
}

private struct SingleCardImageView: View {
  var imageURL: String

  init(
    imageURL: String
  ) {
    self.imageURL = imageURL
  }

  var body: some View {
    HStack(spacing: 0) {
      LazyImage(source: imageURL) { state in
        if let image = state.image {
          image
            .resizingMode(.fill)
            .clipShape(RoundedRectangle.init(8))
        } else {
          R.CustomImage.cardResultDefaultImage.image
            .resizable()
        }
      }
    }
  }
}

private struct MultipleCardImageView: View {
  var firstImageURL: String
  var secondImageURL: String

  init(
    firstImageURL: String,
    secondImageURL: String
  ) {
    self.firstImageURL = firstImageURL
    self.secondImageURL = secondImageURL
  }

  var body: some View {
    HStack(spacing: 0) {
      LazyImage(source: firstImageURL) { state in
        if let image = state.image {
          image
            .resizingMode(.fill)
            .clipShape(RoundedRectangle.init(8))
        } else {
          R.CustomImage.cardResultDefaultImage.image
            .resizable()
        }
      }
      Spacer()
        .frame(width: 16)
      LazyImage(source: secondImageURL) { state in
        if let image = state.image {
          image
            .resizingMode(.fill)
            .clipShape(RoundedRectangle.init(8))
        } else {
          R.CustomImage.cardResultDefaultImage.image
            .resizable()
        }
      }
    }
  }
}

private struct CardDescriptionView: View {
  var title: String
  var keywords: [String]
  var description: String

  init(
    title: String,
    keywords: [String],
    description: String
  ) {
    self.title = title
    self.keywords = keywords
    self.description = description
  }

  var body: some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 32)
      HStack(spacing: 0) {
        Spacer()
          .frame(width: 20)
        ResultTitleView(title: title)
        Spacer()
          .frame(width: 20)
      }
      HStack(spacing: 0) {
        Spacer()
          .frame(width: 20)
        if let firstKeyword = keywords.first {
          ResultKeywordBadgeView(keyword: firstKeyword)
        }
        if keywords.first != keywords.last {
          if let secondKeyword = keywords.last {
            ResultKeywordBadgeView(keyword: secondKeyword)
              .padding(.leading, 8)
          }
        }
        Spacer()
      }
      .padding(.top, 12)
      Divider()
        .background(Color.gray9)
        .frame(height: 1)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
      HStack(spacing: 0) {
        Spacer()
          .frame(width: 20)
        ResultDescriptionView(description: description)
        Spacer()
          .frame(width: 20)
      }
      Spacer()
        .frame(height: 32)
    }
  }
}

private struct ResultTitleView: View {
  var title: String

  init(title: String) {
    self.title = title
  }

  var body: some View {
    HStack(spacing: 0) {
      Text(title)
        .font(.title3)
        .foregroundColor(.gray2)
        .lineLimit(1)
      Spacer()
    }
  }
}

private struct ResultKeywordBadgeView: View {
  var keyword: String

  init(keyword: String) {
    self.keyword = keyword
  }

  var body: some View {
    Text(keyword)
      .font(.caption2)
      .foregroundColor(.gray5)
      .padding(.vertical, 4)
      .padding(.horizontal, 14)
      .background(Color.gray9)
      .cornerRadius(13)
  }
}

private struct ResultDescriptionView: View {
  var description: String

  init(description: String) {
    self.description = description
  }

  var body: some View {
    VStack(spacing: 0) {
      Text(description)
        .font(.body2)
        .foregroundColor(.gray3)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
      Spacer()
    }
    .frame(minHeight: 232)
  }
}

private struct BottomView: View {
  let store: Store<WithSharedState<CardResultState>, CardResultAction>
  var cardResult: CardResult
  var width: CGFloat

  init(
    store: Store<WithSharedState<CardResultState>, CardResultAction>,
    cardResult: CardResult,
    width: CGFloat
  ) {
    self.store = store
    self.cardResult = cardResult
    self.width = width
  }

  var body: some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 8)
      HStack(spacing: 0) {
        Spacer()
          .frame(width: 20)
        Button(action: { ViewStore(store).send(.bottomImageButtonTapped(cardResult)) }) {
          cardResult.buttonImage.image
        }
        Button(action: { ViewStore(store).send(.bottomTitleButtonTapped(cardResult)) }) {
          HStack(spacing: 0) {
            Spacer()
            Text(cardResult.description)
              .font(.button)
              .foregroundColor(.gray10)
              .padding(.vertical, 12)
            Spacer()
          }
          .background(Color.gray1)
          .cornerRadius(8)
        }
        .padding(.leading, 14)
        Spacer()
          .frame(width: 20)
      }
      Spacer()
        .frame(height: 34)
    }
    .cornerRadius(30)
    .overlay(
      RoundedRectangle(30)
        .stroke(Color.gray8, lineWidth: 1)
        .frame(width: width + 1, height: 91)
    )
  }
}

extension View {
  fileprivate func modifyAndDeleteSheet(
    store: Store<WithSharedState<CardResultState>, CardResultAction>
  ) -> some View {
    let viewStore = ViewStore(store.scope(state: \.local))

    return self.apply(content: { view in
      WithViewStore(store.scope(state: \.local.isModifyAndDeleteSheetPresented)) { _ in
        view.bottomSheet(
          title: "설정",
          isPresented: viewStore.binding(
            get: \.isModifyAndDeleteSheetPresented,
            send: CardResultAction.setModifyAndDeleteSheetPresented
          ),
          content: {
            VStack(spacing: 0) {
              HStack {
                Spacer()
                  .frame(width: 20)
                Button(action: { ViewStore(store).send(.modifyDiaryButtonTapped) }) {
                  Text("수정하기")
                    .font(.body2)
                    .foregroundColor(.gray2)
                    .padding(.vertical, 15)
                }
                Spacer()
              }
              HStack {
                Spacer()
                  .frame(width: 20)
                Button(action: { ViewStore(store).send(.removeDiaryButtonTapped) }) {
                  Text("삭제하기")
                    .font(.body2)
                    .foregroundColor(.gray2)
                    .padding(.vertical, 15)
                }
                Spacer()
              }
            }
          },
          bottomArea: { }
        )
      }
    })
  }

  fileprivate func shareViewSheet(
    store: Store<WithSharedState<CardResultState>, CardResultAction>,
    image: UIImage?
  ) -> some View {
    let viewStore = ViewStore(store.scope(state: \.local))

    return self.apply(
      content: { view in
        WithViewStore(store.scope(state: \.local.isShareViewPresented)) { _ in
          view.background(
            ActivityView(
              isPresented: viewStore.binding(
                get: \.isShareViewPresented,
                send: CardResultAction.setShareViewPresented
              ),
              image: image
            )
          )
        }
      }
    )
  }
}
