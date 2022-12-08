//
//  SocialLogin.swift
//  fantoo
//
//  Created by fns on 2022/06/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//



/*

import AuthenticationServices
import Combine
import Foundation
import FirebaseAuth
import Firebase
import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import LineSDK
import SwiftUI

class SocialSignupViewModel: NSObject, ObservableObject {
    
    var currentNonce: String?
    var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?
    var provider = OAuthProvider(providerID: "twitter.com")
    let loginManager = LoginManager()
    
    var googlePublisher = PassthroughSubject<(), Never>()
    var applePublisher = PassthroughSubject<(), Never>()
    var kakaoPublisher = PassthroughSubject<(), Never>()
    var linePublisher = PassthroughSubject<(), Never>()
    var facebookPublisher = PassthroughSubject<(), Never>()
    var twitterPublisher = PassthroughSubject<(), Never>()
    
    @Published var googleJoincheck: Bool = false
    @Published var appleJoincheck: Bool = false
    @Published var kakaoJoincheck: Bool = false
    @Published var lineJoincheck: Bool = false
    @Published var facebookJoincheck: Bool = false
    @Published var twitterJoincheck: Bool = false
    
    @Published var googleUserKey: String = ""
    @Published var appleUserKey: String = ""
    @Published var kakaoUserKey: String = ""
    @Published var lineUserKey: String = ""
    @Published var facebookUserKey: String = ""
    @Published var twitterUserKey: String = ""
    
    @Published var isLogin: Bool = false
    
    @ObservedObject var loginVM = LoginVM()
    
    func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self.presentationContextProvider
        authorizationController.performRequests()
    }
    
    //    private func randomNonceString(length: Int = 32) -> String {
    //        precondition(length > 0)
    //        let charset: Array<Character> =
    //        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    //        var result = ""
    //        var remainingLength = length
    //
    //        while remainingLength > 0 {
    //            let randoms: [UInt8] = (0 ..< 16).map { _ in
    //                var random: UInt8 = 0
    //                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
    //                if errorCode != errSecSuccess {
    //                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
    //                }
    //                return random
    //            }
    //
    //            randoms.forEach { random in
    //                if remainingLength == 0 {
    //                    return
    //                }
    //
    //                if random < charset.count {
    //                    result.append(charset[Int(random)])
    //                    remainingLength -= 1
    //                }
    //            }
    //        }
    //
    //        return result
    //    }
    
    //안됨
    func facebookLogin() {
        loginManager.logIn(permissions: ["public_profile"], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.facebookJoincheck = true
                self.facebookPublisher.send()
                print("Logged in! \(grantedPermissions) \(declinedPermissions) \(accessToken)")
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name"])
                
            }
        }
    }
    
    func googleLogin() {
        
        guard let clientId = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientId)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: GoogleApplicationUtility.rootViewController) {
            [self] user, err in
            
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
                    
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                guard let user = GIDSignIn.sharedInstance.currentUser else { return }
                guard let email = result?.user.email else { return }
                self.googleJoincheck = true
                self.googleUserKey = user.userID ?? ""
                print("snsGoogleUserKey\(self.googleUserKey)")
                googlePublisher.send()
                print("민희2\(user.userID ?? "Success!")")
                
//                self.callOnResponseLoginData(type: .google, id: user.userID ?? "", email: email)
            }
        }
    }
    
    func kakaoLogin() {
        //카카오톡이 설치되어 있는지 확인하는 함수
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                print("oauthToken\(oauthToken)")
                print("error\(error)")
            }
        } else {
            //카카오 계정으로 로그인하는 함수
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                print("oauthToken\(oauthToken)")
                print("error\(error)")
            }
        }
        UserApi.shared.me { [self] User, Error in
            if let name = User?.kakaoAccount?.profile?.nickname {
                print("name\(name)")
            }
            if let mail = User?.kakaoAccount?.email {
                print("mail\(mail)")
            }
            if let profile = User?.kakaoAccount?.profile?.profileImageUrl {
                print("profile\(profile)")
            }
            if let userId = User?.id {
                print("userId\(userId)")
                let id = String(describing: userId)
                self.kakaoJoincheck = true
                self.kakaoUserKey = id
                print("snsKakaoUserKey\(self.kakaoUserKey)")
                self.kakaoPublisher.send()
            }
        }
    }
    
    //안됨
    func lineLogin() {
        LoginManager.shared.login(permissions: [.openID, .email, .profile]) {
            result in
            switch result {
            case .success(let loginResult):
                print("성공\(loginResult.accessToken.value)")
                self.lineJoincheck = true
                self.linePublisher.send()
                // Do other things you need with the login result
            case .failure(let error):
                print("실패\(error)")
            }
        }
    }
    
    func twittweLogin() {
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                return
            }
            
            if credential != nil {
                Auth.auth().signIn(with: credential!) { authResult, error in
                    if error != nil {
                        // Handle error.
                        return
                    }
                    
                    // 사용 예시
                    if let credential = authResult?.credential as? OAuthCredential,
                       let _ = credential.accessToken,
                       let _ = credential.secret {
                        
                        let user = Auth.auth().currentUser!.providerData.first
                        if let user = user {
                            let uid = user.uid
                            self.twitterJoincheck = true
                            self.twitterUserKey = uid
                            print("snsTwitterKey\(self.twitterUserKey)")
                            self.twitterPublisher.send()
                            
                            return
                        }
                        else {
                            return
                        }
                    }
                    else {
                        return
                    }
                }
            }
        }
    }
    
//    func callOnResponseLoginData (type: JoinVM.SimpleLoingType, id: String = "", email: String = "") {
//        var loginData : [String:String] = [:]
//        loginData["social_site"] = type.rawValue
//
//        if type == .google || type == .facebook || type == .kakao || type == .apple {
//            loginData["userid"] = email
//        }
//        //line, twitter
//        else {
//            loginData["userid"] = id
//        }
//
//        loginData["sns_id"] = id
//        loginData["sns_email"] = email
//        loginData["apple_login_key"] = ""
//        self.onResponseSocialLoginData(data: loginData)
//    }
    
    func onResponseSocialLoginData(data: [String : Any]) {
        print("\n---------------------------------\nLogin onResponseSocialLoginData\ntype : \(data["social_site"] ?? "")\nid : \(data["sns_id"] ?? "")\nemail : \(data["sns_email"] ?? "")")
        
        let userid = data["userid"] as? String ?? ""
        let social_site = data["social_site"] as? String ?? ""
        
        if userid.count > 0 {
            socialConnect(data: data)
        }
        else {
            //apple 일경우 userid(email) 없어도 진행한다.
//            if social_site == JoinVM.SimpleLoingType.apple.rawValue {
//                socialConnect(data: data)
//                return
//            }
        }
    }
    
    func socialConnect(data: [String: Any]){
        print("login socialConnect  ::\((data["type"],data["userid"], data["id"]))")
    }
}


extension SocialSignupViewModel: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: appleIDCredential.user) { [self]  (credentialState, error) in
                
                let authorizationCode = appleIDCredential.authorizationCode?.base64EncodedString()
                let token = appleIDCredential.identityToken?.base64EncodedString()
                let authorizedScopes = appleIDCredential.authorizedScopes.debugDescription
                
                // 키값가져온다 appleIDCredential.user
                print("\n--- apple info ----------------------------\nuser : \(appleIDCredential.user)\nauthorizationCode : \(authorizationCode ?? "")\ntoken : \(token ?? "")\nauthorizedScopes : \(authorizedScopes)\n")
                
                switch credentialState {
                case .authorized:
                    print("성공")
                    DispatchQueue.main.async {
                        self.appleJoincheck = true
                        self.appleUserKey = appleIDCredential.user
                        print("snsAppleUserKey\(self.appleUserKey)")
                        self.applePublisher.send()
                    }
                    break
                    
                case .revoked:
                    print("revoked")
                    
                    // The Apple ID credential is revoked.
                    //ToastView.show(text: "ServerErrorMsg".localized)
                    break
                case .notFound:
                    print("notFound")
                    
                    // No credential was found, so show the sign-in UI.
                    //ToastView.show(text: "ServerErrorMsg".localized)
                    break
                default:
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




*/
