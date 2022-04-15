//
//  recordCore.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct TabState: Equatable {
    public var isBackToHomePushed: Bool = false
    public var isRecordButtonTapped: Bool = false
    
    //Child state
    public  var homeState: HomeState = .init()
    public var recordState: RecordState?
    public var storeState: StoreState = .init()
    
    init(
        isBackToHomePushed: Bool = false
    ) {
        self.isBackToHomePushed = isBackToHomePushed
    }
}

enum TabAction: Equatable {
    case backButtonTapped
    case setBackToHome(Bool)
    case moveToRecordViewButtonTapped(Bool)
    
    // Child Action
    case homeAction(HomeAction)
    case recordAction(RecordAction)
    case storeAction(StoreAction)
    
}

struct TabEnvironment {
    var homeEnvironment: HomeEnvironment = .init()
    var recordEnvironment: RecordEnvironment = .init()
    var storeEnvironment: StoreEnvironment = .init()
}

let tabReducer = Reducer.combine(
    
    homeReducer.pullback(state: \.homeState,
                         action: /TabAction.homeAction,
                         environment: {_ in
                             HomeEnvironment (
                             )
                         }
                        ),
    recordReducer.optional().pullback(state: \.recordState,
                                      action: /TabAction.recordAction,
                                      environment: {_ in
                                          RecordEnvironment (
                                          )
                                      }
                                     ),
    storeReducer.pullback(state: \.storeState,
                          action: /TabAction.storeAction,
                          environment: {_ in
                              StoreEnvironment (
                              )
                          }
                         )
    as Reducer<TabState, TabAction, TabEnvironment>, Reducer<TabState, TabAction, TabEnvironment>   { state, action, env in
        switch action {
        case let .moveToRecordViewButtonTapped(isTapped):
            state.isRecordButtonTapped = isTapped
            if isTapped{
                state.recordState = .init()
            }
            return .none
            
        case let .setBackToHome(ispushed):
            state.isRecordButtonTapped = ispushed
            if ispushed {
                state.recordState = .init()
            }
            return .none
            
        case .backButtonTapped:
            return .none
            
        case .recordAction(.backButtonTapped):
            return Effect(value: .setBackToHome(false))
        
        case .homeAction:
            return .none
        case .recordAction:
            return .none
        }
    }
)
