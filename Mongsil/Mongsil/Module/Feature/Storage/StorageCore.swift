//
//  storageCore.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import Combine
import ComposableArchitecture

struct StorageState: Equatable {
}

enum StorageAction: Equatable {
  
}

struct StorageEnvironment {
  
}

let storageReducer = Reducer<WithSharedState<StorageState>, StorageAction, StorageEnvironment> {
  state, action, env in
  switch action {
  }
}
