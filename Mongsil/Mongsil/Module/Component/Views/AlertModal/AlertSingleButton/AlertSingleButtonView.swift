//
//  AlertSingleButtonView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/18.
//

import Combine
import ComposableArchitecture
import SwiftUI

public struct AlertSingleButtonView: View {
  private let store: Store<AlertSingleButtonState, AlertSingleButtonAction>

  public init(store: Store<AlertSingleButtonState, AlertSingleButtonAction>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      Spacer()
      VStack(alignment: .center) {
        TitleView(store: store)
        BodyView(store: store)
        Spacer().height(40)
        PrimaryButtonView(store: store)
      }
      .padding(16)
      .frame(maxWidth: .infinity)
      .border(Color.gray11)
      .cornerRadius(8)
      .background(
        Color.gray8
          .cornerRadius(8)
          .shadow(color: Color.black.opacity(0.3), x: 8, y: 8, blur: 8, spread: 2)
      )
      Spacer()
    }
    .padding(32)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black.opacity(0.75))
  }
}

private struct TitleView: View {
  private let store: Store<AlertSingleButtonState, AlertSingleButtonAction>

  init(store: Store<AlertSingleButtonState, AlertSingleButtonAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.title)) { titleTextViewStore in
      if let titleText = titleTextViewStore.state {
        Text(titleText)
          .font(.title2)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .multilineTextAlignment(.center)

        Spacer().height(16)
      }
    }
  }
}

private struct BodyView: View {
  private let store: Store<AlertSingleButtonState, AlertSingleButtonAction>

  init(store: Store<AlertSingleButtonState, AlertSingleButtonAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.body)) { bodyTextViewStore in
      Text(bodyTextViewStore.state)
        .font(.title)
        .foregroundColor(.gray4)
        .multilineTextAlignment(.center)
    }
  }
}

private struct PrimaryButtonView: View {
  private let store: Store<AlertSingleButtonState, AlertSingleButtonAction>

  init(store: Store<AlertSingleButtonState, AlertSingleButtonAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.primaryButtonTitle)) { primaryButtonTitleViewStore in
      AlertButton(title: primaryButtonTitleViewStore.state) {
        ViewStore(store).send(.primaryButtonTapped)
      }
    }
  }
}

extension View {
  public func alertSingleButton(store: Store<AlertSingleButtonState?, AlertSingleButtonAction>) -> some View {
    return self.overlay(
      IfLetStore(
        store,
        then: { store in
          AlertSingleButtonView(store: store)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      )
      .animation(.easeInOut, value: 0.2)
      .ignoresSafeArea()
    )
  }
}
