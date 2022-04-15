//
//  ContentView.swift
//  KaKaoLogin
//
//  Created by Chuljin Hwang on 2022/04/09.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDK

struct ContentView: View {
  @State var kakaoUserNickName : String = ""
  @State var kakaoUserMail : String = ""
  @State var appleUserNickName : String = ""
  @State var appleUserMail : String = ""
  
  var body: some View {
    VStack {
      Button {
        if (UserApi.isKakaoTalkLoginAvailable()) {
          UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
              print(error)
            }
            else {
              print("loginWithKakaoTalk() success.")
              getKaKaoUserInfo()
            }
          }
        }
      } label : {
        Text("Kakao login button")
          .frame(width : UIScreen.main.bounds.width * 0.9)
      }
      Text("Kakao nickname : \(kakaoUserNickName)")
        .padding()
      Text("Kakao userMail : \(kakaoUserMail)")
    }
    .padding()
    
    VStack{
      Button {
        showAppleLogin()
      } label : {
        Text("Apple login button")
          .frame(width : UIScreen.main.bounds.width * 0.9)
      }
      Text("Apple nickname : \(appleUserNickName)")
        .padding()
      Text("Apple userMail : \(appleUserMail)")
    }
  }
  
  func getKaKaoUserInfo(){
    UserApi.shared.me { User, error in
      if let nickName = User?.kakaoAccount?.profile?.nickname{
        kakaoUserNickName = nickName
      }
      if let mail = User?.kakaoAccount?.email{
        kakaoUserMail = mail
      }
    }
  }
  private func showAppleLogin() {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.email, .fullName]
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.performRequests()
  }
  
}

