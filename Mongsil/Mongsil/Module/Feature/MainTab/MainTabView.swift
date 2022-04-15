//
//  TabView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/10.
//
import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    let store: Store<WithSharedState<TabState>, TabAction>
    
    init(store: Store<WithSharedState<TabState>, TabAction>) {
        self.store = store
        UITabBar.appearance().scrollEdgeAppearance = .init()
    }
    
    
    var body: some View {
        
        WithViewStore(store.scope(state: \.local.isRecordButtonTapped)) {isRecordViewPushedViewStore in
                GeometryReader { metrics in
                    VStack {
                        TabView {
                            HomeView(
                                store: store.scope(
                                    state: \.homeState,
                                    action: TabAction.homeAction
                                )
                            )
                            .tabItem {
                                Image(systemName: "square.fill")
                                    .font(.title)
                                Text("홈")
                            }
                            StoreView(
                                store: store.scope(
                                    state: \.storeState,
                                    action: TabAction.storeAction
                                )
                            )
                            .tabItem {
                                Image(systemName: "square.fill")
                                    .font(.title)
                                Text("보관함")
                            }
                        }
                        
                        Button(
                            action: { isRecordViewPushedViewStore.send(.moveToRecordViewButtonTapped(true))},
                            label: {
                                Image(systemName: "circle.fill")
                                    .font(.largeTitle)
                                    .frame(width: 48, height: 48, alignment: .center)
                                    .cornerRadius(28)
                            }
                        )
                        .foregroundColor(.gray)
                        .offset(x: metrics.size.width*0.005, y: -metrics.size.height*0.115)
                      
                        
                        NavigationLink(
                            destination: IfLetStore(
                                store.scope(
                                    state: \.recordState,
                                    action: TabAction.recordAction),
                                then: RecordView.init(store: )
                            ),
                            isActive: isRecordViewPushedViewStore.binding(
                                send: TabAction.moveToRecordViewButtonTapped
                            ),
                            label: {
                            }
                        )
                        .isDetailLink(true)
                    }
                }
            }
        }
    }
