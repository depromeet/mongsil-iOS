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

  public var description: String {
    switch self {
    case .healthCheck:
      return "/test"
    case .checkUser:
      return "/user/checkUser"
    case .signUp:
      return "/user/signUp"
    case .dropout:
      return "/user/expire"
    }
  }
}
