//
//  collectionView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import SwiftUI
import ComposableArchitecture

struct StoreView: View {
    private let store: Store<WithSharedState<StoreState>, StoreAction>
    
    init(store: Store<WithSharedState<StoreState>, StoreAction>) {
        self.store = store
    }
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                Text("StoreView")
                    .navigationBarTitle("보관함", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                    }, label: {
                        Image(systemName:"gearshape")
                            .foregroundColor(.black)
                    }))
            }
           
        }
    }
}
