//
//  AppleLoginService.swift
//  Mongsil
//
//  Created by Chuljin Hwang on 2022/04/12.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
  @Environment(\.colorScheme) var colorScheme
  @AppStorage("userId") var userId: String = ""
  var body: some View {
    NavigationView{
      VStack{
        if !userId.isEmpty {
          SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.email, .fullName]
          } onCompletion: { result in
            switch result{
            case .success(let auth):
              print(auth)
              
              switch auth.credential{
              case let credential as ASAuthorizationAppleIDCredential :
                let userId = credential.user
                let email = credential.email
                let firstName = credential.fullName?.givenName
                let lastName = credential.fullName?.familyName
                //                self.email = email ?? ""
                //                self.userId = userId
                //                self.firstName = firstName ?? ""
                //                self.lastName = lastName ?? ""
                print("hello")
                print("Email \(email ?? "")")
                print("UserID \(userId)")
                print("firstName \(firstName ?? "")")
                print("lastName \(lastName ?? "")")
              default:
                break
              }
            case .failure(let error):
              print(error)
            }
          }
          .signInWithAppleButtonStyle(
            colorScheme == .dark ? .white : .black
          )
          .frame(height:50)
          .padding()
          .cornerRadius(8)
          
        } else {
          Text("welcome")
          Text(userId)
        }
      }
      .navigationTitle("sign in")
    }
  }
}

struct AppleLoginView_Previews: PreviewProvider {
  static var previews: some View {
    AppleLoginView()
  }
}

