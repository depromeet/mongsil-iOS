//
//  CategoryListView.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/16.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import NukeUI

struct CategoryListItemView: View {
 private let store: Store<CategoryListItemState, CategoryListItemAction>

  init(store: Store<CategoryListItemState, CategoryListItemAction>) {
   self.store = store
 }

 var body: some View {
   Button(
       action: {
         let viewStore = ViewStore(store)
         viewStore.send(.tappedView(viewStore.state.category))
       },
       label: {
         WithViewStore(store.scope(state: \.type)) { typeViewStore in
           WithViewStore(store.scope(state: \.category)) { categoryViewStore in
             WithViewStore(store.scope(state: \.isSelected)) { isSelectedViewStore in
               switch typeViewStore.state {
               case .image:
                 CategoryItem(
                  image: categoryViewStore.state.image,
                  name: categoryViewStore.state.name,
                  isSelected: isSelectedViewStore.state
                 )
               case .badge:
                 KeywordBadgeView(
                  categoryViewStore.state.name,
                  isSelected: isSelectedViewStore.state
                 )
               }
             }
           }
         }
       }
     )
 }
}
