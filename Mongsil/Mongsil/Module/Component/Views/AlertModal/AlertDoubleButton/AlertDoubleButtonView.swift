//
//  AlertDoubleButtonView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/18.
//

import Combine
import ComposableArchitecture
import SwiftUI

public struct AlertDoubleButtonView: View {
  private let store: Store<AlertDoubleButtonState, AlertDoubleButtonAction>

  public init(store: Store<AlertDoubleButtonState, AlertDoubleButtonAction>) {
    self.store = store
  }

  public var body: some View {
    GeometryReader { geometry in
      VStack {
        VStack(alignment: .center) {
          TitleView(store: store)
          BodyView(store: store)
          Spacer().height(40)
          HStack(alignment: .center, spacing: 5) {
            SecondaryButtonView(store: store)
            PrimaryButtonView(store: store)
          }
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
        .offset(y: geometry.size.height / 4.5)

        Spacer()
      }
      .padding(32)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.black.opacity(0.75))
    }
  }
}

private struct TitleView: View {
  private let store: Store<AlertDoubleButtonState, AlertDoubleButtonAction>

  init(store: Store<AlertDoubleButtonState, AlertDoubleButtonAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.title)) { titleTextViewStore in
      if let titleText = titleTextViewStore.state {
        Text(titleText)
          .font(.title2)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .multilineTextAlignment(.leading)

        Spacer().height(16)
      }
    }
  }
}

private struct BodyView: View {
  private let store: Store<AlertDoubleButtonState, AlertDoubleButtonAction>

  init(store: Store<AlertDoubleButtonState, AlertDoubleButtonAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.body)) { bodyTextViewStore in
      Text(bodyTextViewStore.state)
        .font(.title3)
        .foregroundColor(.gray4)
        .multilineTextAlignment(.leading)
    }
  }
}

private struct PrimaryButtonView: View {
  private let store: Store<AlertDoubleButtonState, AlertDoubleButtonAction>

  init(store: Store<AlertDoubleButtonState, AlertDoubleButtonAction>) {
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

private struct SecondaryButtonView: View {
  private let store: Store<AlertDoubleButtonState, AlertDoubleButtonAction>

  init(store: Store<AlertDoubleButtonState, AlertDoubleButtonAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.secondaryButtonTitle)) { secondaryButtonTitleViewStore in
      AlertButton(title: secondaryButtonTitleViewStore.state, hierarchy: .secondary) {
        ViewStore(store).send(.secondaryButtonTapped)
      }
    }
  }
}

extension View {
  public func AlertDoubleButton(store: Store<AlertDoubleButtonState?, AlertDoubleButtonAction>) -> some View {
    return self.overlay(
      IfLetStore(
        store,
        then: { store in
          AlertDoubleButtonView(store: store)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      )
      .animation(.easeInOut, value: 0.2)
      .ignoresSafeArea()
    )
  }
}
