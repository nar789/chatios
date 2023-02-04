//
//  SignupViewModel.swift
//  fantoo
//
//  Created by fns on 2022/04/26.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//



/*

import SwiftUI
import Firebase
import GoogleSignIn

// 파일 삭제 예정
class GoogleSignupViewModel: ObservableObject {
    
    @Published var isLogin: Bool = false

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
                print("민희2\(user.userID ?? "Success!")")
                
//                self.callOnResponseLoginData(type: .google, id: user.userID ?? "", email: email)
                
//                joinVM.socialJoin(adAgreeChoice: "Y", ageAgree: "Y", countryIsoTwo: "KR", loginId: user.userID ?? "", loginType: .google, serviceAgree: "Y", teenagerAgree: "Y", useReferralCode: "YDW034THIQ", userInfoAgree: "Y", userNick: "닝넴")
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




*/
