//
//  SnsLoginControl.swift
//  fantoo
//
//  Created by mkapps on 2022/07/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

import AuthenticationServices
import JWTDecode

import FacebookLogin
import FacebookCore

import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

import FirebaseAuth
import Firebase
import GoogleSignIn

import LineSDK

class SnsLoginControl: NSObject, ObservableObject {
    
    var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?
    var provider = OAuthProvider(providerID: "twitter.com")
    
    var loginAppleResultSubject = PassthroughSubject<(Bool, String), Never>()
    var loginFacebookResultSubject = PassthroughSubject<(Bool, String), Never>()
    var loginKakaoResultSubject = PassthroughSubject<(Bool, String), Never>()
    var loginLineResultSubject = PassthroughSubject<(Bool, String), Never>()
    var loginTwitterResultSubject = PassthroughSubject<(Bool, String), Never>()
    var loginGoogleResultSubject = PassthroughSubject<(Bool, String), Never>()
    
    
    //MARK: - Method
    func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self.presentationContextProvider
        authorizationController.performRequests()
    }
    
    func facebookLogin() {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil){ LoginResult in
            // 로그인 성공 유무에 따른 판단
            switch LoginResult {
            case .failed(_):
                self.loginFacebookResultSubject.send((false, ""))
                
            case .cancelled:
                self.loginFacebookResultSubject.send((false, ""))
                
            case .success(_, _, _):
                
                GraphRequest(graphPath: "me", parameters: ["fields": "id"]).start { connection, result, error in
                    if error != nil {
                        self.loginFacebookResultSubject.send((false, ""))
                        return
                    }
                    
                    guard let facebook = result as? [String: AnyObject] else {
                        self.loginFacebookResultSubject.send((false, ""))
                        return
                    }
                    
                    let idx = facebook["id"] as? String ?? ""
                    self.loginFacebookResultSubject.send((true, idx))
                }
            }
        }
    }
    
    func kakaoLogin() {
        
        //카카오톡이 설치되어 있는지 확인하는 함수
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if error != nil {
                    self.loginKakaoResultSubject.send((false, ""))
                    return
                }
                
                UserApi.shared.me { user, error in
                    let idx = user?.id ?? 0
                    if idx == 0 {
                        self.loginKakaoResultSubject.send((false, ""))
                    }
                    else {
                        self.loginKakaoResultSubject.send((true, String(idx)))
                    }
                }
            }
        }
        else {
            //카카오 계정으로 로그인하는 함수
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if error != nil {
                    self.loginKakaoResultSubject.send((false, ""))
                    return
                }
                
                UserApi.shared.me { user, error in
                    let idx = user?.id ?? 0
                    if idx == 0 {
                        self.loginKakaoResultSubject.send((false, ""))
                    }
                    else {
                        self.loginKakaoResultSubject.send((true, String(idx)))
                    }
                }
            }
        }
    }
    
    func lineLogin() {
        LoginManager.shared.login(permissions: [.openID, .email, .profile]) {
            result in
            switch result {
            case .success(let loginResult):
                //print("loginResult : \(loginResult)")
                //print("성공\(loginResult.accessToken.value)")
                
                if let profile = loginResult.userProfile {
                    //print("User ID: \(profile.userID)")
                    //print("User Display Name: \(profile.displayName)")
                    //print("User Icon: \(String(describing: profile.pictureURL))")
                    
                    self.loginLineResultSubject.send((true, profile.userID))
                }
            case .failure(let error):
                print("실패\(error)")
                self.loginLineResultSubject.send((false, ""))
            }
        }
    }
    
    func twitterLogin() {
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                self.loginTwitterResultSubject.send((false, ""))
                return
            }
            
            if credential != nil {
                Auth.auth().signIn(with: credential!) { authResult, error in
                    if error != nil {
                        // Handle error.
                        self.loginTwitterResultSubject.send((false, ""))
                        return
                    }
                    
                    // 사용 예시
                    if let credential = authResult?.credential as? OAuthCredential,
                       let _ = credential.accessToken,
                       let _ = credential.secret {
                        
                        let user = Auth.auth().currentUser!.providerData.first
                        if let user = user {
                            let uid = user.uid
                            
                            if uid.count > 0 {
                                self.loginTwitterResultSubject.send((true, uid))
                                return
                            }
                            
                            self.loginTwitterResultSubject.send((false, ""))
                            return
                        }
                        else {
                            self.loginTwitterResultSubject.send((false, ""))
                            return
                        }
                    }
                    else {
                        self.loginTwitterResultSubject.send((false, ""))
                        return
                    }
                }
            }
        }
    }
    
    func googleLogin() {
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            self.loginGoogleResultSubject.send((false, ""))
            return
        }
        
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: SnsLoginControl.rootViewController!) { user, err in
            
            if let _ = err {
                self.loginGoogleResultSubject.send((false, ""))
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                self.loginGoogleResultSubject.send((false, ""))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let _ = error {
                    self.loginGoogleResultSubject.send((false, ""))
                    return
                }
                guard let user = GIDSignIn.sharedInstance.currentUser else {
                    self.loginGoogleResultSubject.send((false, ""))
                    return
                }
                
                let idx = user.userID ?? ""
                if idx.count > 0 {
                    self.loginGoogleResultSubject.send((true, idx))
                }
                else {
                    self.loginGoogleResultSubject.send((false, ""))
                }
            }
        }
    }
    
    
    static var rootViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        else {
            return nil
        }
        
        /*
         guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
             return .init()
         }
         
         guard let root = screen.windows.first?.rootViewController else {
             return .init()
         }
         return root
         */
    }
}



//MARK: - Apple
extension SnsLoginControl: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: appleIDCredential.user) { credentialState, error in
                
                let authorizationCode = appleIDCredential.authorizationCode?.base64EncodedString()
                let token = appleIDCredential.identityToken?.base64EncodedString()
                let authorizedScopes = appleIDCredential.authorizedScopes.debugDescription
                
                print("\n--- apple info ----------------------------\nuser : \(appleIDCredential.user)\nauthorizationCode : \(authorizationCode ?? "")\ntoken : \(token ?? "")\nauthorizedScopes : \(authorizedScopes)\n")
                
                switch credentialState {
                case .authorized:
                    
                    //appleIDCredential.user
                    //UserManager().userAppleName = (appleIDCredential.fullName?.nickname != nil) ? appleIDCredential.fullName?.nickname : ""
                    
                    let userid = appleIDCredential.user
                    if userid.count > 0 {
                        UserManager.shared.isGuest = false
                        
                        self.loginAppleResultSubject.send((true, userid))
                    }
                    else {
                        self.loginAppleResultSubject.send((false, ""))
                    }
                    //                     var email = ""
                    //
                    //                    let tokenString = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                    //                    let jwt = try! decode(jwt: tokenString!)
                    //
                    //                    let claim = jwt.claim(name: "email")
                    //                    if let appleEmail = claim.string, !email.contains("appleid.com") {
                    //                        email = appleEmail
                    //                    }
                    
                    break
                    
                case .revoked:
                    self.loginAppleResultSubject.send((false, ""))
                    break
                    
                case .notFound:
                    self.loginAppleResultSubject.send((false, ""))
                    break
                    
                default:
                    self.loginAppleResultSubject.send((false, ""))
                    break
                }
            }
        }
    }
    
    // apple login 실패 시
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\(error.localizedDescription)")
    }
}
