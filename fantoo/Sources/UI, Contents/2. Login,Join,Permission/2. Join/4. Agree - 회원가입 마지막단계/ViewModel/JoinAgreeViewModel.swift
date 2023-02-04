//
//  JoinAgreeViewModel.swift
//  fantoo
//
//  Created by mkapps on 2022/07/11.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class JoinAgreeViewModel: ObservableObject {
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var isNextStep: Bool = false
    
    @Published var showCountryList: Bool = false
    
    
    //show webview
    @Published var showWebPage: Bool = false
    @Published var showWebUrl: String = ""
    
    
    
    //join data
    @Published var isAllAgree: Bool = false
    @Published var isAdAgree: Bool = false
    @Published var countryCode: String = ""
    @Published var displayCountry: String = ""

    @Published var referralCode: String = ""
    @Published var nickName: String = ""
    
    @Published var checkNickNameWarning: String = ""
    
    @Published var nickNameCorrectStatus:CheckCorrectStatus = .Check
    @Published var referralCodeCorrectStatus:CheckCorrectStatus = .Check
    
    @Published var nickNameDidEnter: Bool = false
    @Published var referralCodeDidEnter: Bool = false
    
    //nicknameAlert
    
    @Published var showAlertCannotUse: Bool = false
    @Published var showAlertLength: Bool = false
    @Published var showAlertAlreadyUse: Bool = false
    @Published var showAlertUsable: Bool = false
    @Published var showAlertCannotChange: Bool = false
    @Published var rightItemsState: Bool = false

    
    private var canclelables = Set<AnyCancellable>()
    
    
    //MARK: - Request
    func requestEmailJoin(adAgreeChoice:String, countryIsoTwo:String, email:String, loginPw:String, useReferralCode:String, userNick:String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.emilJoin(adAgreeChoice: adAgreeChoice, countryIsoTwo: countryIsoTwo, email: email, loginPw: loginPw, useReferralCode: useReferralCode, userNick: userNick)
            .sink { error in
                self.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.requestLogin(loginId: email, loginPw: loginPw)
            }
            .store(in: &canclelables)
    }
    
    func requestSnsJoin(adAgreeChoice:String, countryIsoTwo:String, snsIdx:String, type:String, useReferralCode:String, userNick:String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.snsJoin(adAgreeChoice: adAgreeChoice, countryIsoTwo: countryIsoTwo, loginId: snsIdx, loginType: type, useReferralCode: useReferralCode, userNick: userNick)
            .sink { error in
                self.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                print("login value : \(value)")

                self.loadingStatus = .Close
                self.requestSnsLogin(idx: snsIdx, type: type)
            }
            .store(in: &canclelables)
    }
    
    func requestCheckNickName(nickName: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.checkNickName(nickName: nickName)
            .sink { error in
                self.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
                self.alertMessage = error.message
                self.showAlert = true
                self.showAlertAlreadyUse = true
            } receiveValue: { value in
                self.loadingStatus = .Close
                let isCheck = value.isCheck
                
                //중복이 아니면
                if !isCheck {
                    self.nickNameCorrectStatus = .Correct
                    self.checkNickNameWarning = "se_s_can_use_nickname".localized
                    self.showAlertUsable = true
                    self.rightItemsState = true
                }
                else {
                    self.nickNameCorrectStatus = .Wrong
                    self.checkNickNameWarning = "se_a_already_use_nickname".localized
                }
            }
            .store(in: &canclelables)
    }
    
    
    //MARK: - Request : Login
    func requestLogin(loginId: String, loginPw: String) {
        ApiControl.login(loginId: loginId, loginPw: loginPw)
            .sink { error in
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
                self.alertMessage = error.message
                self.showAlert = true
                
            } receiveValue: { value in
                let authCode = value.authCode
                let state = value.state
                
                //success login!
                if authCode.count > 0, state.count > 0 {
                    self.requestIssueToken(authCode: authCode, state: state, loginId: loginId, loginPw: loginPw, loginType: LoginType.email.rawValue)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                }
            }
            .store(in: &canclelables)
    }
    
    func requestSnsLogin(idx: String, type: String) {
        ApiControl.snsLogin(idx: idx, loginType: type)
            .sink { error in
                guard case let .failure(error) = error else { return }
                print("snsLogin error : \(error)")
                
                self.alertMessage = error.message
                self.showAlert = true
                
            } receiveValue: { value in
                let authCode = value.authCode
                let state = value.state
                
                //success login!
                if authCode.count > 0, state.count > 0 {
                    self.requestIssueToken(authCode: authCode, state: state, loginId: idx, loginPw: "", loginType: type)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                }
            }
            .store(in: &canclelables)
    }
    
    func requestIssueToken(authCode: String, state: String, loginId: String, loginPw: String, loginType:String) {
        ApiControl.issueToken(authCode: authCode, state: state)
            .sink { error in
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
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
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                }
            }
            .store(in: &canclelables)

    }
    
    
    //MARK: - Check
    func checkInvalidate() -> Bool {
//        let ios2 = countryData?.iso2 ?? ""
        if isAllAgree, countryCode.count > 0, nickName.count > 0, nickNameCorrectStatus == .Correct {
            return true
        }
        
        return false
    }
}
