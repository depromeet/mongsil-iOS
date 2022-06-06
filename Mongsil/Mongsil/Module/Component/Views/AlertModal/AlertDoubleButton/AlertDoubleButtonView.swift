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
        VStack(alignment: .center, spacing: 0) {
          VStack {
            TitleView(store: store)
            BodyView(store: store)
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 24)
          Divider()
            .background(Color.gray7)
            .frame(height: 1)
          HStack(spacing: 0) {
            SecondaryButtonView(store: store)
              .frame(width: (geometry.width - 120) / 2 )
            Divider()
              .background(Color.gray7)
              .frame(height: 56)
            PrimaryButtonView(store: store)
              .frame(width: (geometry.width - 120) / 2 )
          }
        }
        .frame(maxWidth: .infinity)
        .border(Color.gray9)
        .cornerRadius(8)
        .background(
          Color.gray9
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.3), x: 8, y: 8, blur: 8, spread: 2)
        )
        .offset(y: geometry.size.height / 4.5)

        Spacer()
      }
      .padding(.horizontal, 48)
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
          .font(.subTitle)
          .foregroundColor(.gray2)
          .multilineTextAlignment(.center)
        Spacer().height(10)
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
        .font(.body2)
        .foregroundColor(.gray5)
        .multilineTextAlignment(.center)
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
      WithViewStore(store.scope(state: \.primaryButtonHierachy)) { primaryButtonHierachyViewStore in
        AlertButton(
          title: primaryButtonTitleViewStore.state,
          hierarchy: primaryButtonHierachyViewStore.state
        ) {
          ViewStore(store).send(.primaryButtonTapped)
        }
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
      WithViewStore(store.scope(state: \.secondaryButtonHierachy)) { secondaryButtonHierachyViewStore in
        AlertButton(
          title: secondaryButtonTitleViewStore.state,
          hierarchy: secondaryButtonHierachyViewStore.state
        ) {
          ViewStore(store).send(.secondaryButtonTapped)
        }
      }
    }
  }
}

extension View {
  public func alertDoubleButton(store: Store<AlertDoubleButtonState?, AlertDoubleButtonAction>) -> some View {
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
