//
//  UserModel.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/28.
//
import Foundation

struct User: Codable {
  let userName: String?
  let userEmail: String?
  let userLogined: [isUserLogined]
}

struct userInfo: Codable {
  let userName: String?
  let userEmail: String?
  
  enum CodingKeys: String, CodingKey {
    case userName = "name"
    case userEmail = "email"
  }
}

struct isUserLogined: Codable {
  let userLogined: Bool
}
