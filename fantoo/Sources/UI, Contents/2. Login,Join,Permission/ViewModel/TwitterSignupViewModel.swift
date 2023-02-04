//
//  TwitterSignupViewModel.swift
//  fantoo
//
//  Created by fns on 2022/04/29.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//




/*
import Foundation
import UIKit
import FirebaseAuth
import SwiftUI

// 파일 삭제 예정
class TwitterSignupViewModel: NSObject, ObservableObject {

    var provider = OAuthProvider(providerID: "twitter.com")

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
//                            let email = user.email ?? ""
//                            self.joinVM.socialJoin(adAgreeChoice: "Y", ageAgree: "Y", countryIsoTwo: "KR", loginId: uid, loginType: .twitter, serviceAgree: "Y", teenagerAgree: "Y", useReferralCode: "YDW034THIQ", userInfoAgree: "Y", userNick: "닝넴")
                            //let photoURL = user.photoURL
                              
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
    
//    func twitterLogin(delegate:SocialLoginDataDelegate, vc:UIViewController) {
        
//        provider.getCredentialWith(nil) { credential, error in
//            if error != nil {별
//                self.callOnResponseLoginData(type: .twitter)
//                return
//            }
//
//            if credential != nil {
//                Auth.auth().signIn(with: credential!) { authResult, error in
//                    if error != nil {
//                        // Handle error.
//                        self.callOnResponseLoginData(type: .twitter)
//                        return
//                    }
//
//                    // 사용 예시
//                    if let credential = authResult?.credential as? OAuthCredential,
//                       let _ = credential.accessToken,
//                       let _ = credential.secret {
//
//                        let user = Auth.auth().currentUser!.providerData.first
//                        if let user = user {
//                            let uid = user.uid
//                            let email = user.email ?? ""
//                            //let photoURL = user.photoURL
//
//                            self.callOnResponseLoginData(type: .twitter, id: uid, email: email)
//                            return
//                        }
//                        else {
//                            self.callOnResponseLoginData(type: .twitter)
//                            return
//                        }
//                    }
//                    else {
//                        self.callOnResponseLoginData(type: .twitter)
//                        return
//                    }
//                }
//            }
//        }
//}
}


*/
