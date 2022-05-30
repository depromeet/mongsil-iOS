//
//  CardResult.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/21.
//

public enum CardResult {
  case diary
  case dreamForDelete
  case dreamForSave

  var description: String {
    switch self {
    case .diary:
      return "해몽 보러가기"
    case .dreamForDelete:
      return "해몽 삭제하기"
    case .dreamForSave:
      return "해몽 저장하기"
    }
  }

  var buttonImage: ImageAsset {
    self == .diary ? R.CustomImage.moreIcon : R.CustomImage.shareIcon
  }
}
