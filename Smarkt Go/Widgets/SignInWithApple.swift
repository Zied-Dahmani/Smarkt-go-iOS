//
//  SignInWithApple.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 7/3/2023.
//

import SwiftUI
import AuthenticationServices

// 1
final class SignInWithApple: UIViewRepresentable {
  // 2
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    // 3
    return ASAuthorizationAppleIDButton()
  }
  
  // 4
  func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
  }
}
