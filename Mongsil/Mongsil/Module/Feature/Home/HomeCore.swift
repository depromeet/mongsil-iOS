//
//  HomeCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import Combine
import ComposableArchitecture

struct HomeState: Equatable {
}

enum HomeAction {

}

struct HomeEnvironment {

}

let homeReducer = Reducer<WithSharedState<HomeState>, HomeAction, HomeEnvironment> {
  _, action, _ in
  switch action {

  }
}
