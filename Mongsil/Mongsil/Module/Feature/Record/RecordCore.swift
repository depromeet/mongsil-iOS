//
//  RecordCore.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import ComposableArchitecture

struct RecordState: Equatable {
  public var isRecordKeywordPushed: Bool = false
  public var titleText: String = ""
  public var mainText: String = ""
  public var currentDate: Date = Date()
  public var selectedDateToStr: String {
    convertDateToString(currentDate)
  }
  public var isSelectDateSheetPresented: Bool = false
  public var isNextButtonAbled: Bool = false
  
  // Child State
  public var recordKeyword: RecordKeywordState?
  public var cancelRecordAlertModal: AlertDoubleButtonState?
  
  init(
    cancelRecordAlertModal: AlertDoubleButtonState? = nil,
    recordKeyword: RecordKeywordState? = nil
  ) {
    self.cancelRecordAlertModal = cancelRecordAlertModal
    self.recordKeyword = recordKeyword
  }
}

enum RecordAction: ToastPresentableAction {
  case backButtonTapped
  case isCloseButtonTapped(Bool)
  case navigationBarDateButtonTapped
  case setSelectDateSheetPresented(Bool)
  case confirmDateButtonTapped
  case setSelectedDate(Date)
  case setNextButtonAbled(Bool)
  case setRecordKeywordPushed(Bool)
  case titletextFieldChanged(String)
  case mainTextFieldChanged(String)
  case presentToast(String)
  
  // Child Action
  case recordKeyword(RecordKeywordAction)
  case cancelRecordAlertModal(AlertDoubleButtonAction)
}

struct RecordEnvironment {
}

let recordReducer:
Reducer<WithSharedState<RecordState>, RecordAction, RecordEnvironment> =
Reducer.combine([
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.cancelRecordAlertModal,
      action: /RecordAction.cancelRecordAlertModal,
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
    state, action, _ in
    switch action {
    case .backButtonTapped:
      return .none
      
    case let .isCloseButtonTapped(tapped):
      if state.local.mainText.count == 0 && state.local.titleText.count == 0 {
        return Effect(value: .backButtonTapped)
      } else {
        return setAlertModal(
          state: &state.local.cancelRecordAlertModal,
          titleText: "작성을 취소할까요?",
          bodyText: "작성 중인 내용은 저장되지 않아요.",
          secondaryButtonTitle: "아니요",
          primaryButtonTitle: "취소하기",
          primaryButtonHierachy: .warning
        )
      }
      
    case .navigationBarDateButtonTapped:
      return Effect(value: .setSelectDateSheetPresented(true))
      
    case let .setSelectDateSheetPresented(presented):
      state.local.isSelectDateSheetPresented = presented
      return .none
      
    case .confirmDateButtonTapped:
      return Effect(value: .setSelectDateSheetPresented(false))
      
    case let .setSelectedDate(date):
      state.local.currentDate = date
      return .none
      
    case let .setNextButtonAbled(abled):
      state.local.isNextButtonAbled = abled
      return .none
      
    case let .setRecordKeywordPushed(pushed):
      state.local.isRecordKeywordPushed = pushed
      if pushed {
        state.local.recordKeyword = .init()
      }
      return .none
      
    case let .titletextFieldChanged(text):
      if checkTextCount(text: text, upper: 20) {
        state.local.titleText = text
        if checkTextFieldEmpty(state: &state) {
          return Effect(value: .setNextButtonAbled(true))
        }
        return Effect(value: .setNextButtonAbled(false))
      } else {
        state.local.titleText.removeLast()
        return Effect(value: .presentToast("제목은 최대 20자까지 입력할 수 있어요."))
      }
      
    case let .mainTextFieldChanged(text):
      if checkTextCount(text: text, upper: 2000) {
        state.local.mainText = text
        if checkTextFieldEmpty(state: &state) {
          return Effect(value: .setNextButtonAbled(true))
        }
        return Effect(value: .setNextButtonAbled(false))
      } else {
        state.local.mainText.removeLast()
        return Effect(value: .presentToast("꿈 일기는 최대 2000자까지 작성할 수 있어요."))
      }
      
    case .presentToast:
      return .none
      
    case .recordKeyword(.backButtonTapped):
      return Effect(value: .setRecordKeywordPushed(false))
      
    case .recordKeyword:
      return .none
      
    case .cancelRecordAlertModal(.secondaryButtonTapped):
      state.local.cancelRecordAlertModal = nil
      return .none
      
    case .cancelRecordAlertModal(.primaryButtonTapped):
      state.local.cancelRecordAlertModal = nil
      return Effect(value: .backButtonTapped)
    }
  }
])

private func checkTextCount(text: String, upper: Int) -> Bool {
  return text.count > upper ? false : true
}

private func checkTextFieldEmpty(state: inout WithSharedState<RecordState>) -> Bool {
  return state.local.titleText.count > 0 && state.local.mainText.count > 0
  ? true
  : false
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
