//
//  RecordCore.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import SwiftUI
import ComposableArchitecture

struct RecordState: Equatable {
  public var isRecordKeywordPushed: Bool = false
  public var closeButtonAlertModal: AlertDoubleButtonState?
  public var titleText: String = ""
  public var mainText: String = ""
  public var currentDate: Date = Date()
  public var selectedDateToStr: String {
    return  convertDateToString(currentDate)
  }
  public var isDisplayDatePicker: Bool = true
  public var isSelectDateSheetPresented: Bool = false
  public var isNextButtonAbled: Bool = false
  public var closeButtonTapped: Bool = false
  
  // Child State
  public var recordKeyword: RecordKeywordState?
  
  init(
    closeButtonAlertModel: AlertDoubleButtonState? = nil,
    recordKeyword: RecordKeywordState? = nil
  ) {
    self.closeButtonAlertModal = closeButtonAlertModel
    self.recordKeyword = recordKeyword
  }
}

enum RecordAction: ToastPresentableAction {
  case setRecordKeywordPushed(Bool)
  case textTyped(Bool)
  case presentToast(String)
  case backButtonTapped
  case navigationBarDateButtonTapped
  case setSelectDateSheetPresented(Bool)
  case setSelectedDate(Date)
  case titletextFieldChanged(String)
  case mainTextFieldChanged(String)
  case confirmDateButtonTapped
  case isCloseButtonTapped(Bool)
  case setNextButtonAbled(Bool)
  
  //Child Action
  case recordKeyword(RecordKeywordAction)
  case closeButtonAlertModal(AlertDoubleButtonAction)
}

struct RecordEnvironment {
}

let recordReducer:
Reducer<WithSharedState<RecordState>, RecordAction, RecordEnvironment> =
Reducer.combine([
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.closeButtonAlertModal,
      action: /RecordAction.closeButtonAlertModal,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    )
  as Reducer<WithSharedState<RecordState>, RecordAction, RecordEnvironment>,
  recordKeywordReducer
    .optional()
    .pullback(
      state: \.recordKeyword,
      action: /RecordAction.recordKeyword,
      environment: { _ in
        RecordKeywordEnvironment()
      }
    ) as Reducer<WithSharedState<RecordState>, RecordAction, RecordEnvironment>,
  Reducer<WithSharedState<RecordState>, RecordAction, RecordEnvironment> {
    state, action, env in
    switch action {
    case .backButtonTapped:
      return .none
      
    case let .isCloseButtonTapped(tapped):
      if state.local.mainText.count == 0 && state.local.titleText.count == 0
      {
        return Effect(value: .backButtonTapped)
      }
      else {
        return setAlertModal(
          state: &state.local.closeButtonAlertModal,
          titleText: "작성을 취소할까요?",
          bodyText: "작성 중인 내용은 저장되지 않아요.",
          secondaryButtonTitle: "아니요",
          primaryButtonTitle: "취소하기",
          primaryButtonHierachy: .warning
        )
      }
      
    case let .setNextButtonAbled(abled):
      if abled == true {
      state.local.isNextButtonAbled = true
      }
      else {
        state.local.isNextButtonAbled = false
      }
      return .none
      
    case let .textTyped(typed):
      if state.local.titleText.count > 0 && state.local.mainText.count > 0 {
        return Effect(value: .setNextButtonAbled(true))
      }
      else {
        return Effect(value: .setNextButtonAbled(false))
      }
      
    case .closeButtonAlertModal(.secondaryButtonTapped):
      state.local.closeButtonAlertModal = nil
      return .none
      
    case .closeButtonAlertModal(.primaryButtonTapped):
      state.local.closeButtonAlertModal = nil
      return Effect(value: .backButtonTapped)
      
    case let .titletextFieldChanged(text):
      if checkTextCount(text: text, upper: 25) {
        state.local.titleText = text
        if state.local.titleText.count > 0 && state.local.mainText.count > 0 {
          return Effect(value: .setNextButtonAbled(true))
        }
        else {
          return Effect(value: .setNextButtonAbled(false))
        }
      }
      else {
        state.local.titleText.removeLast()
        return Effect(value: .presentToast("제목은 최대 20자까지 입력할 수 있어요."))
      }
      
    case let .mainTextFieldChanged(text):
      if checkTextCount(text: text, upper: 2000) {
        state.local.mainText = text
        if state.local.titleText.count > 0 && state.local.mainText.count > 0 {
          return Effect(value: .setNextButtonAbled(true))
        }
        else {
          return Effect(value: .setNextButtonAbled(false))
        }
      }
      else {
        state.local.mainText.removeLast()
        return Effect(value: .presentToast("꿈일기는 최대 2000자까지 작성할 수 있어요."))
      }
      
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
      
    case .presentToast:
      return .none
      
    case let .setRecordKeywordPushed(pushed):
      state.local.isRecordKeywordPushed = pushed
      if pushed {
        state.local.recordKeyword = .init()
      }
      return .none
      
    case .recordKeyword(.backButtonTapped):
      return Effect(value: .setRecordKeywordPushed(false))
      
    case .recordKeyword:
      return .none
    }
  }
])

private func checkTextCount(text: String, upper: Int) -> Bool {
  if text.count > upper {
    return false
  }
  else {
    return true
  }
}

private func setAlertModal(
  state: inout AlertDoubleButtonState?,
  titleText: String? = nil,
  bodyText: String,
  secondaryButtonTitle: String,
  primaryButtonTitle: String,
  primaryButtonHierachy: AlertButton.Hierarchy
) -> Effect<RecordAction, Never> {
  state = .init(
    title: titleText,
    body: bodyText,
    secondaryButtonTitle: secondaryButtonTitle,
    primaryButtonTitle: primaryButtonTitle,
    primaryButtonHierachy: primaryButtonHierachy
  )
  return .none
}
