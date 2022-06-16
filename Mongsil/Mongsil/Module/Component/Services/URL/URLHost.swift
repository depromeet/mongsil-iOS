//
//  URLHost.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/06.
//

public enum URLHost: CustomStringConvertible {
  case healthCheck
  case checkUser
  case signUp
  case dropout
  case dreamList
  case saveDream
  case dreamFilter
  case dreamFilterCount
  case dreamFilterResult
  case selectDream
  case dreamSearch
  case hotKeyword
  case diary
  case diaryList

  public var description: String {
    switch self {
    case .healthCheck:
      return "/test"
    case .checkUser:
      return "/user/check"
    case .signUp:
      return "/user"
    case .dropout:
      return "/user"
    case .dreamList:
      return "/user/dream-list"
    case .saveDream:
      return "/user/dream"
    case .dreamFilter:
      return "/api/dream/filter"
    case .dreamFilterCount:
      return "/api/dream/filter/count"
    case .dreamFilterResult:
      return "/api/dream/filter/result"
    case .selectDream:
      return "/api/dream/result"
    case .dreamSearch:
      return "/api/dream/search"
    case .hotKeyword:
      return "/api/dream/popularity"
    case .diary:
      return "/diary"
    case .diaryList:
      return "/diary/list"
    }
  }
}
