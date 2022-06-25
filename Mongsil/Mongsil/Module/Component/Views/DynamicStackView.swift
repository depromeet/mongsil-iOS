//
//  DynamicStackView.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/21.
//

import SwiftUI
import ComposableArchitecture
import OrderedCollections

struct DynamicForEachStore<EachContent, EachState, EachAction, Data, ID, Content>: View
where Data: Collection, ID: Hashable, Content: View, EachState: Equatable, EachContent: View {
  let store: Store<IdentifiedArray<ID, EachState>, (ID, EachAction)>
  let content: (Store<EachState, EachAction>) -> EachContent
  let verticalSpacing: CGFloat
  let horizontalSpacing: CGFloat

  @State private var totalHeight = CGFloat.zero

  init(
    _ store: Store<IdentifiedArray<ID, EachState>, (ID, EachAction)>,
    verticalSpacing: CGFloat = 8,
    horizontalSpacing: CGFloat = 8,
    @ViewBuilder content: @escaping (Store<EachState, EachAction>) -> EachContent
  )
  where
  Data == IdentifiedArray<ID, EachState>,
  Content == WithViewStore<
    OrderedSet<ID>, (ID, EachAction), ForEach<OrderedSet<ID>, ID, EachContent>
  > {
    self.store = store
    self.verticalSpacing = verticalSpacing
    self.horizontalSpacing = horizontalSpacing
    self.content = content
  }

  public var body: some View {
    VStack {
      GeometryReader { geometry in
        self.generateContent(in: geometry)
      }
    }
    .frame(height: totalHeight)

  }
}

extension DynamicForEachStore {
  private func generateContent(in g: GeometryProxy) -> some View {
    var width = CGFloat.zero
    var height = CGFloat.zero

    return ZStack(alignment: .topLeading) {
      ForEachStore(store, content: { eachStore in
        self.content(eachStore)
          .alignmentGuide(.leading, computeValue: { d in
            if abs(width - d.width) > g.size.width {
              width = 0
              height -= d.height
              height -= verticalSpacing
            }
            let result = width

            if ViewStore(eachStore).state == ViewStore(self.store).state.last {
              width = 0 // last item
            } else {
              width -= d.width
              width -= horizontalSpacing
            }

            return result
          })
          .alignmentGuide(.top, computeValue: { _ in
            let result = height
            if ViewStore(eachStore).state == ViewStore(self.store).state.last! {
              height = 0 // last item
            }
            return result
          })
      })

    }.background(viewHeightReader($totalHeight))
  }

  private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
    return GeometryReader { geometry -> Color in
      let rect = geometry.frame(in: .local)
      DispatchQueue.main.async {
        binding.wrappedValue = rect.size.height
      }
      return .clear
    }
  }
}
