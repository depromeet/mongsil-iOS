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
