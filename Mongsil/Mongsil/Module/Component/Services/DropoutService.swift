//
//  DropoutService.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/06.
//

import Alamofire
import Combine
import CombineExt

public class DropoutService {
  public typealias ErrorFactory = DropoutServiceErrorFactory
  
  public let alamofireSession: Session
  
  public init(alamofireSession: Session) {
    self.alamofireSession = alamofireSession
  }
  
  public func dropout(id: String) -> AnyPublisher<Unit, Error> {
    let url = "http://3.34.46.139:80\(URLHost.dropout)"
    let body = DropoutRequestDto(userId: id)
    
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
        throw ErrorFactory.dropoutFailed(url: url, underlying: error)
      }
    })
    .tryMap({ response -> CommonResponseDto.NotExistData in
      if response.statusCode == 200 {
        return response
      } else {
        throw ErrorFactory.dropoutFailed(
          url: url,
          statusCode: String(response.statusCode),
          underlying: nil
        )
      }
    })
    .mapTo(Unit())
    .eraseToAnyPublisher()
  }
}

public enum DropoutServiceErrorFactory: ErrorFactory {
  public enum Code: Int {
    case decodeFailed = 1
    case dropoutFailed = 2
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
  
  public static func dropoutFailed(
    url: String,
    statusCode: String? = nil,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.dropoutFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.dropoutFailed),
        "url": url,
        "statusCode": statusCode as Any,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }
}
