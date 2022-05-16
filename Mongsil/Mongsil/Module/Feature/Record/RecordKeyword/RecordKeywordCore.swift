//
//  RecordKeywordCore.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/15.
//

import Combine
import ComposableArchitecture

struct RecordKeywordState: Equatable {
  public var isStroeButtonAbled: Bool = false
  public var currentDate: Date = Date()
  public var selectedDateToStr: String {
    return  convertDateToString(currentDate)
  }
  public var isDisplayDatePicker: Bool = true
  public var isSelectDateSheetPresented: Bool = false
}

enum RecordKeywordAction {
  case backButtonTapped
  case setNextButtonAbled(Bool)
  case navigationBarDateButtonTapped
  case setSelectDateSheetPresented(Bool)
  case setSelectedDate(Date)
  case confirmDateButtonTapped
}

struct RecordKeywordEnvironment {
}

let recordKeywordReducer = Reducer<WithSharedState<RecordKeywordState>, RecordKeywordAction, RecordKeywordEnvironment> {
  state, action, _ in
  switch action {
  case .backButtonTapped:
    return .none
    
  case .setNextButtonAbled:
    return .none
    
  case .navigationBarDateButtonTapped:
    return Effect(value: .setSelectDateSheetPresented(true))
    
  case let .setSelectDateSheetPresented(presented):
    state.local.isSelectDateSheetPresented = presented
    return .none
    
  case let .setSelectedDate(date):
    state.local.currentDate = date
    return .none
    
  case .confirmDateButtonTapped:
    return Effect(value: .setSelectDateSheetPresented(false))
  }
}
