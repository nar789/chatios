//
//  EmailLoginViewModel.swift
//  fantoo
//
//  Created by mkapps on 2022/07/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class EmailLoginViewModel: ObservableObject {
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private var canclelables = Set<AnyCancellable>()
    
    func login(loginId: String, loginPw: String) {
        ApiControl.login(loginId: loginId, loginPw: loginPw)
            .sink { error in
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
                
            } receiveValue: { value in
                let authCode = value.authCode
                let state = value.state
                
                //success login!
                if authCode.count > 0, state.count > 0 {
                    self.issueToken(authCode: authCode, state: state, loginId: loginId, loginPw: loginPw, loginType: LoginType.email.rawValue)
                }
                else {
                    self.alertTitle = ""
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                }
            }
            .store(in: &canclelables)
    }
    
    func issueToken(authCode: String, state: String, loginId: String, loginPw: String, loginType:String) {
        ApiControl.issueToken(authCode: authCode, state: state)
            .sink { error in
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                
                let access_token = value.access_token
                let refresh_token = value.refresh_token
                let integUid = value.integUid
                let token_type = value.token_type
                let expires_in = value.expires_in
                
                //success
                if access_token.count > 0, refresh_token.count > 0, integUid.count > 0, token_type.count > 0, expires_in > 0 {
                  
                    print("\n--- Email Login Result ---------------------------------\nauthCode : \(authCode)\nstate : \(state)\naccess_token : \(access_token)\nrefresh_token : \(refresh_token)\nintegUid : \(integUid)\ntoken_type : \(token_type)\nexpires_in : \(expires_in)\n")
                    
                    UserManager.shared.setLoginData(account: loginId, password: loginPw, loginType: loginType, accessToken: access_token, refreshToken: refresh_token, uid: integUid, expiredTime: expires_in)
                    UserManager.shared.checkLogin()
                    UserManager.shared.showLoginView = false
                }
                else {
                    //성공이 아니면 에러
                    self.alertTitle = ""
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                }
            }
            .store(in: &canclelables)

    }
}
