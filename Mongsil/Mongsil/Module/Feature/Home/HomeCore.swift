//
//  HomeCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import Combine
import ComposableArchitecture

struct HomeState: Equatable {
    public var isBackToHomePushed: Bool = false
}

enum HomeAction: Equatable {
  
}

struct HomeEnvironment {
    
}

let homeReducer = Reducer<HomeState, HomeAction, HomeEnvironment> {
    state, action, env in
    switch action {
        
    }
}
