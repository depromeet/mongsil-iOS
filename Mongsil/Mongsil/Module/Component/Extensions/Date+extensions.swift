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
