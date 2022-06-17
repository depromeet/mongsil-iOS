//
//  DiaryService.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/06/08.
//

import Alamofire
import Combine
import CombineExt

public class DiaryService {
  public typealias ErrorFactory = DiaryServiceErrorFactory

  public let alamofireSession: Session

  public init(alamofireSession: Session) {
    self.alamofireSession = alamofireSession
  }

  public func editDiary(
    cardID: String,
    title: String,
    description: String,
    categories: [String]
  ) -> AnyPublisher<Unit, Error> {
    let url = "http://3.34.46.139:80\(URLHost.diary)"
    let body = EditDiaryRequestDto(
      cardID: cardID,
      title: title,
      description: description,
      categories: categories
    )

    return alamofireSession.request(
      url,
      method: .put,
      parameters: body,
      encoder: JSONParameterEncoder.default
    )
    .validate(statusCode: 200..<300)
    .publishData()
    .tryMap({ dataResponse -> CommonResponseDto.NotExistData in
      switch dataResponse.result {
      case let .success(data):
        do {
          return try JSONDecoder().decode(CommonResponseDto.NotExistData.self, from: data)
        } catch {
          throw ErrorFactory.decodeFailed(
            url: url,
            data: data,
            underlying: error
          )
        }
      case let .failure(error):
        throw ErrorFactory.editDiaryFailed(
          url: url,
          cardID: cardID,
          title: title,
          description: description,
          categories: categories,
          underlying: error
        )
      }
    })
    .tryMap({ response -> CommonResponseDto.NotExistData in
      if response.statusCode == 200 {
        return response
      } else {
        throw ErrorFactory.editDiaryFailed(
          url: url,
          cardID: cardID,
          title: title,
          description: description,
          categories: categories,
          underlying: nil
        )
      }
    })
    .mapTo(Unit())
    .eraseToAnyPublisher()
  }

  public func deleteDiary(idList: [String]) -> AnyPublisher<Unit, Error> {
    let url = "http://3.34.46.139:80\(URLHost.diary)"
    let body = DeleteDiaryRequestDto(idList: idList)

    return alamofireSession.request(
      url,
      method: .delete,
      parameters: body,
      encoder: JSONParameterEncoder.default
    )
    .validate(statusCode: 200..<300)
    .publishData()
    .tryMap({ dataResponse -> CommonResponseDto.NotExistData in
      switch dataResponse.result {
      case let .success(data):
        do {
          return try JSONDecoder().decode(CommonResponseDto.NotExistData.self, from: data)
        } catch {
          throw ErrorFactory.decodeFailed(
            url: url,
            data: data,
            underlying: error
          )
        }
      case let .failure(error):
        throw ErrorFactory.deleteDiaryFailed(
          url: url,
          idList: idList,
          underlying: error
        )
      }
    })
    .tryMap({ response -> CommonResponseDto.NotExistData in
      if response.statusCode == 200 {
        return response
      } else {
        throw ErrorFactory.deleteDiaryFailed(
          url: url,
          statusCode: response.statusCode,
          idList: idList,
          underlying: nil
        )
      }
    })
    .mapTo(Unit())
    .eraseToAnyPublisher()
  }

  public func getDiaryList(userID: String) -> AnyPublisher<DiaryList, Error> {
    let url = "http://3.34.46.139:80\(URLHost.diaryList)"
    let body = GetDiaryListRequestDto(userID: userID)

    return alamofireSession.request(
      url,
      method: .post,
      parameters: body,
      encoder: JSONParameterEncoder.default
    )
    .validate(statusCode: 200..<300)
    .publishData()
    .tryMap({ dataResponse -> CommonResponseDto.ExistData<DiaryList> in
      switch dataResponse.result {
      case let .success(data):
        do {
          return try JSONDecoder().decode(CommonResponseDto.ExistData<DiaryList>.self, from: data)
        } catch {
          throw ErrorFactory.decodeFailed(
            url: url,
            data: data,
            underlying: error
          )
        }
      case let .failure(error):
        throw ErrorFactory.getDiaryListFailed(
          url: url,
          userID: userID,
          underlying: error
        )
      }
    })
    .tryMap({ response -> CommonResponseDto.ExistData<DiaryList> in
      if response.statusCode == 200 {
        return response
      } else {
        throw ErrorFactory.getDiaryListFailed(
          url: url,
          statusCode: response.statusCode,
          userID: userID,
          underlying: nil
        )
      }
    })
    .compactMap { $0.data }
    .eraseToAnyPublisher()
  }

  public func getDiary(diaryID: String) -> AnyPublisher<Diary, Error> {
    let url = "http://3.34.46.139:80\(URLHost.diary)/\(diaryID)"

    return alamofireSession.request(
        url,
        method: .get,
        encoding: JSONEncoding.default
      )
    .validate(statusCode: 200..<300)
    .publishData()
    .tryMap({ dataResponse -> CommonResponseDto.ExistData<GetDiaryResponseDto> in
      switch dataResponse.result {
      case let .success(data):
        do {
          return try JSONDecoder().decode(CommonResponseDto.ExistData<GetDiaryResponseDto>.self, from: data)
        } catch {
          throw ErrorFactory.decodeFailed(
            url: url,
            data: data,
            underlying: error
          )
        }
      case let .failure(error):
        throw ErrorFactory.getDiaryFailed(
          url: url,
          underlying: error
        )
      }
    })
    .tryMap({ response -> CommonResponseDto.ExistData<GetDiaryResponseDto> in
      if response.statusCode == 200 {
        return response
      } else {
        throw ErrorFactory.getDiaryFailed(
          url: url,
          statusCode: response.statusCode,
          underlying: nil
        )
      }
    })
    .compactMap { $0.data }
    .map { $0.cardList }
    .compactMap { $0.first }
    .eraseToAnyPublisher()
  }

  public func saveDiary(
    userID: String,
    title: String,
    description: String,
    registerDate: Date,
    categories: [String]
  ) -> AnyPublisher<SaveDiaryResponseDto, Error> {
    let url = "http://3.34.46.139:80\(URLHost.diary)"
    let body = SaveDiaryRequestDto(
      userID: userID,
      title: title,
      description: description,
      registerDate: registerDate,
      categories: categories
    )

    let encoder = JSONParameterEncoder()
    encoder.encoder.dateEncodingStrategy = .formatted(DateFormatter.dateFormatter)

    return alamofireSession.request(
      url,
      method: .post,
      parameters: body,
      encoder: encoder
    )
    .validate(statusCode: 200..<300)
    .publishData()
    .tryMap({ dataResponse -> CommonResponseDto.ExistData<SaveDiaryResponseDto> in
      switch dataResponse.result {
      case let .success(data):
        do {
          return try JSONDecoder().decode(CommonResponseDto.ExistData<SaveDiaryResponseDto>.self, from: data)
        } catch {
          throw ErrorFactory.decodeFailed(
            url: url,
            data: data,
            underlying: error
          )
        }
      case let .failure(error):
        throw ErrorFactory.saveDiaryFailed(
          url: url,
          userID: userID,
          title: title,
          description: description,
          categories: categories,
          underlying: error
        )
      }
    })
    .tryMap({ response -> CommonResponseDto.ExistData<SaveDiaryResponseDto> in
      if response.statusCode == 200 {
        return response
      } else {
        throw ErrorFactory.saveDiaryFailed(
          url: url,
          userID: userID,
          title: title,
          description: description,
          categories: categories,
          underlying: nil
        )
      }
    })
    .compactMap { $0.data }
    .eraseToAnyPublisher()
  }
}

public enum DiaryServiceErrorFactory: ErrorFactory {
  public enum Code: Int {
    case decodeFailed = 1
    case editDiaryFailed = 2
    case deleteDiaryFailed = 3
    case getDiaryListFailed = 4
    case getDiaryFailed = 5
    case saveDiaryFailed = 6
  }

  public static func decodeFailed(
    url: String,
    data: Data,
    underlying: Error
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.decodeFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.decodeFailed),
        "url": url,
        "data": data,
        NSUnderlyingErrorKey: underlying
      ]
    )
  }

  public static func editDiaryFailed(
    url: String,
    statusCode: Int? = nil,
    cardID: String,
    title: String,
    description: String,
    categories: [String],
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.editDiaryFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.editDiaryFailed),
        "url": url,
        "statusCode": statusCode as Any,
        "cardID": cardID,
        "title": title,
        "description": description,
        "categories": categories,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }

  public static func deleteDiaryFailed(
    url: String,
    statusCode: Int? = nil,
    idList: [String],
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.deleteDiaryFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.deleteDiaryFailed),
        "url": url,
        "statusCode": statusCode as Any,
        "idList": idList,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }

  public static func getDiaryListFailed(
    url: String,
    statusCode: Int? = nil,
    userID: String,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.getDiaryListFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.getDiaryListFailed),
        "url": url,
        "statusCode": statusCode as Any,
        "userID": userID,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }

  public static func getDiaryFailed(
    url: String,
    statusCode: Int? = nil,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.getDiaryFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.getDiaryFailed),
        "url": url,
        "statusCode": statusCode as Any,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }

  public static func saveDiaryFailed(
    url: String,
    statusCode: Int? = nil,
    userID: String,
    title: String,
    description: String,
    categories: [String],
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.saveDiaryFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.saveDiaryFailed),
        "url": url,
        "statusCode": statusCode as Any,
        "userID": userID,
        "title": title,
        "description": description,
        "categories": categories,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }
}
