//
//  Date+extensions.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/10.
//

import Foundation

public func convertDateToString(_ date: Date) -> String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "YYYY.MM.dd"
  return dateFormatter.string(from: date)
}

public func convertYearAndMonthDateToString(_ date: Date) -> String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "YYYY.MM"
  return dateFormatter.string(from: date)
}

public func convertYearDateToString(_ date: Date) -> String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "YYYY"
  return dateFormatter.string(from: date)
}

public func convertMonthDateToString(_ date: Date) -> String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "MM"
  return dateFormatter.string(from: date)
}

public func convertDateFormatter(_ date: String) -> String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
  dateFormatter.locale = Locale(identifier: "ko_KR")

  let convertedDate = dateFormatter.date(from: date)

  guard dateFormatter.date(from: date) != nil else {
    assert(false, "no date from string")
    return ""
  }
  dateFormatter.dateFormat = "yyyy.MM.dd"
  let convertedCurrentDate = dateFormatter.string(from: convertedDate!)

  return convertedCurrentDate
}
