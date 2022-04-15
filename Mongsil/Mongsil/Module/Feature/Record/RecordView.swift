//
//  recordView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import SwiftUI
import ComposableArchitecture

struct RecordView: View {
    private let store: Store<WithSharedState<RecordState>, RecordAction>
    
    init(store: Store<WithSharedState<RecordState>, RecordAction>) {
        self.store = store
    }
    var body: some View {
        WithViewStore(store) { viewStore in
                MSNavigationBar(
                    titleText: "기록",
                    backButtonAction: { ViewStore(store).send(.backButtonTapped) }
                )
                NavigationView{
                    Text("recordView")
                }
                .navigationBarHidden(true)
            }
        }
    }
