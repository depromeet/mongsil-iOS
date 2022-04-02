//
//  ForEachWithIndex.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//
//  Original Source: https://stackoverflow.com/a/61149111/12509847

import SwiftUI

public struct ForEachWithIndex<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
  public var data: Data
  public var content: (_ index: Data.Index, _ element: Data.Element, _ isLast: Bool) -> Content
  var id: KeyPath<Data.Element, ID>

  public init(
    _ data: Data,
    id: KeyPath<Data.Element, ID>,
    content: @escaping (_ index: Data.Index, _ element: Data.Element, _ isLast: Bool) -> Content
  ) {
    self.data = data
    self.id = id
    self.content = content
  }

  public var body: some View {
    ForEach(
      zip(self.data.indices, self.data).map { index, element in
        return IndexInfo(
          index: index,
          id: self.id,
          element: element,
          isLast: index == self.data.indices.last
        )
      },
      id: \.elementID
    ) { indexInfo in
      self.content(indexInfo.index, indexInfo.element, indexInfo.isLast)
    }
  }
}

extension ForEachWithIndex where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
  public init(
    _ data: Data,
    @ViewBuilder content: @escaping (_ index: Data.Index, _ element: Data.Element, _ isLast: Bool) -> Content
  ) {
    self.init(data, id: \.id, content: content)
  }
}

extension ForEachWithIndex: DynamicViewContent where Content: View {}

private struct IndexInfo<Index, Element, ID: Hashable>: Hashable {
  let index: Index
  let id: KeyPath<Element, ID>
  let element: Element
  let isLast: Bool

  var elementID: ID {
    self.element[keyPath: self.id]
  }

  static func == (_ lhs: IndexInfo, _ rhs: IndexInfo) -> Bool {
    lhs.elementID == rhs.elementID
  }

  func hash(into hasher: inout Hasher) {
    self.elementID.hash(into: &hasher)
  }
}

