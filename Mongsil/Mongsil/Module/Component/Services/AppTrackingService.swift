//
//  AppTrackingService.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/03.
//

import AppTrackingTransparency
import Combine
import CombineExt

public class AppTrackingService {
  public init() {}

  public func getTrackingAuthorizationStatus() -> AnyPublisher<Bool, Never> {
    return Publishers.Create<Bool, Never>(factory: { subscriber -> Cancellable in
      subscriber.send(ATTrackingManager.trackingAuthorizationStatus == .notDetermined)
      subscriber.send(completion: .finished)
      return AnyCancellable({})
    })
    .eraseToAnyPublisher()
  }

  public func requestAppTrackingAuthorization() -> AnyPublisher<Void, Never> {
    return Publishers.Create<Void, Never>(factory: { subscribers -> Cancellable in
      subscribers.send(
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
      )
      subscribers.send(completion: .finished)
      return AnyCancellable({})
    })
    .eraseToAnyPublisher()
  }
}

