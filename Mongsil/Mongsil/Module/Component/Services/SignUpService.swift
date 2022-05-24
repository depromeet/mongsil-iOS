//
//  SignUpService.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/06.
//

import Alamofire
import Combine
import CombineExt

public class SignUpService {
  public typealias ErrorFactory = SignUpServiceErrorFactory

  public let alamofireSession: Session

  public init(alamofireSession: Session) {
    self.alamofireSession = alamofireSession
  }

  public func singUp(name: String, with email: String) -> AnyPublisher<SignUpUserResponseDto, Error> {
    let url = "http://3.34.46.139:80\(URLHost.signUp)"
    let body = SignUpUserRequestDto(userEmail: email, userName: name)

    return alamofireSession
      .request(
        url,
        method: .post,
        parameters: body,
        encoder: JSONParameterEncoder.default
      )
      .validate(statusCode: 200..<300)
      .publishData()
      .tryMap({ dataResponse -> CommonResponseDto.ExistData<SignUpUserResponseDto> in
        switch dataResponse.result {
        case let .success(data):
          do {
            return try JSONDecoder().decode(CommonResponseDto.ExistData<SignUpUserResponseDto>.self, from: data)
          } catch {
            throw ErrorFactory.decodeFailed(
              url: url,
              data: data,
              underlying: error
            )
          }
        case let .failure(error):
          throw ErrorFactory.signUpFailed(url: url, underlying: error)
        }
      })
      .tryMap({ response -> CommonResponseDto.ExistData<SignUpUserResponseDto> in
        if response.statusCode == 200 {
          return response
        } else {
          throw ErrorFactory.signUpFailed(
            url: url,
            statusCode: response.statusCode,
            underlying: nil
          )
        }
      })
      .compactMap { $0.data }
      .eraseToAnyPublisher()
  }
}

public enum SignUpServiceErrorFactory: ErrorFactory {
  public enum Code: Int {
    case decodeFailed = 1
    case signUpFailed = 2
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

  public static func signUpFailed(
    url: String,
    statusCode: Int? = nil,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.signUpFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.signUpFailed),
        "url": url,
        "statusCode": statusCode as Any,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }
}
