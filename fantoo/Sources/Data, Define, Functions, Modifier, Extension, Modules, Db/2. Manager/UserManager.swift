//
//  UserManager.swift
//  fantoo
//
//  Created by mkapps on 2022/04/23.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @AppStorage(DefineKey.isFirstLaunching) var isFirstLaunching: Bool = true       //permission, login
    
    
    //MARK: - Variables : State
    @Published var isLogin: Bool = false
    @Published var showLoginView = false
    @Published var showLoginAlert = false
    @Published var showAlertAuthError = false
    @Published var showSettingAuth = false
    @Published var deletePostAlert = false
    @Published var reportPostAlert = false
    @Published var certNumberAlert = false
    @Published var delegateCancelCompleteAlert = false
    
    @Published var isCheckingToken = false
    
    @Published var showInitialViewState = Date()    //로그아웃 후 초기상태를 보여줘야 한다.
    @Published var isGuest: Bool = false            // 로그인 화면에서 '둘러보기'로 들어온 경우
    
    //MARK: - Variables : Login
    @AppStorage(DefineKey.accessToken) var accessToken: String = ""
    @AppStorage(DefineKey.refreshToken) var refreshToken: String = ""
    @AppStorage(DefineKey.uid) var uid: String = ""
    @AppStorage(DefineKey.expiredTime) var expiredTime: Int = 0
    @AppStorage(DefineKey.integUid) var regDate: Date = Date()
    
    @AppStorage(DefineKey.account) var account: String = ""
    @AppStorage(DefineKey.password) var password: String = ""
    @AppStorage(DefineKey.loginType) var loginType: String = ""

    @AppStorage(DefineKey.oldLoginType) var oldLoginType: String = ""
    
    @AppStorage(DefineKey.authorizedAlbum) var authorizedAlbum = false

    var canclelables = Set<AnyCancellable>()
    
    //MARK: - Method
    //앱 실행 시 로그인상태 및 로그인뷰 띄워야할지 체크한다.
    func start() {
        //첫 실행하는데 로그인이 되어 있지 않다.
        //permission이 끝나면 로그인페이지를 띄운다.
        if isFirstLaunching {
            isLogin = false
            showLoginView = false
        }
        else {
            if checkValidate() {
                isLogin = true
                showLoginView = false
            }
            else {
                isLogin = false
                showLoginView = true
            }
        }
    }
    
    func checkLogin() {
        isLogin = checkValidate()
    }
    
    func setLoginData(
        account:String, password:String, loginType:String,
        accessToken:String, refreshToken:String, uid:String,
        expiredTime:Int)
    {
        self.account = account
        self.password = password
        self.loginType = loginType
        self.oldLoginType = loginType
        
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.uid = uid
        
        self.expiredTime = expiredTime
        self.regDate = Date()
        
        let _ = self.checkValidate()
    }
    
    func logout() {
        reset()
        
        isLogin = false
        showInitialViewState = Date()
        showLoginView = true
    }
    
    func reset() {
        print("\n--- logout ----------------\n")
        
        self.account = ""
        self.password = ""
        self.loginType = ""
        //self.oldLoginType = ""        //이전 로그인 정보는 계속 써야되서 초기화 하지 않는다.ㅏ
        
        self.accessToken = ""
        self.refreshToken = ""
        self.uid = ""
        
        self.expiredTime = 0
        self.regDate = Date()
        
        let _ = self.checkValidate()
    }
    
    
    //MARK: - Method : Check
    func refreshToken(result:@escaping((_ success:Bool) -> Void)) {
        UserManager.shared.isCheckingToken = true
        
        ApiControl.refreshToken()
            .sink { error in

                //finished error가 들어와서 막는다. 왜 여기만 들어오는지 의문임.
                guard case .failure(_) = error else { return }

                //갱신 실패시 로그인알럿 띄우자
                result(false)
                StatusManager.shared.stopAllLoading()
                self.showAlertAuthError = true
                self.isCheckingToken = false
            } receiveValue: { value in
                let access_token = value.access_token
                let expires_in = value.expires_in

                //success
                if access_token.count > 0, expires_in > 0 {

                    print("\n--- refresh token Result ---------------------------------\naccess_token : \(access_token)\nexpires_in : \(expires_in)\n")

                    self.accessToken = access_token
                    self.expiredTime = expires_in
                    self.regDate = Date()
                    
                    self.isCheckingToken = false

                    result(true)
                }
                else {
                    //갱신 실패시 로그인알럿 띄우자
                    result(false)
                    StatusManager.shared.stopAllLoading()
                    self.showAlertAuthError = true
                    self.isCheckingToken = false
                }
            }
            .store(in: &canclelables)
    }
    
//    func checkTokenAndRenewal(isCheck:Bool, result:@escaping((_ success:Bool) -> Void)) {
//        if !isCheck {
//            result(true)
//            return
//        }
//        
//        if !isLogin {
//            result(true)
//            return
//        }
//        
//        if checkExpiredToken() {
//            result(true)
//        }
//        else {
//            ApiControl.refreshToken()
//                .sink { error in
//
//                    //finished error가 들어와서 막는다. 왜 여기만 들어오는지 의문임.
//                    guard case .failure(_) = error else { return }
//
//                    //갱신 실패시 로그인알럿 띄우자
//                    result(false)
//                    StatusManager.shared.stopAllLoading()
//                    UserManager.shared.showAlertAuthError = true
//                } receiveValue: { value in
//                    let access_token = value.access_token
//                    let expires_in = value.expires_in
//
//                    //success
//                    if access_token.count > 0, expires_in > 0 {
//
//                        print("\n--- refresh token Result ---------------------------------\naccess_token : \(access_token)\nexpires_in : \(expires_in)\n")
//
//                        self.accessToken = access_token
//                        self.expiredTime = expires_in
//
//                        result(true)
//                    }
//                    else {
//                        //갱신 실패시 로그인알럿 띄우자
//                        result(false)
//                        StatusManager.shared.stopAllLoading()
//                        UserManager.shared.showAlertAuthError = true
//                    }
//                }
//                .store(in: &canclelables)
//        }
//    }
    
    func checkExpiredToken() -> Bool {
//        return false
        if checkValidate() {
            //종료날짜를 계산
            let expiredDate = regDate.addingTimeInterval(TimeInterval(expiredTime))
            
            //종료날짜에서 현재시간을 뺀다.
            let duration = expiredDate - Date()
            
            //30분이상 차이가 나면 아직 토큰이 유효한걸로 판단.
            let checkMinutes: Double = 60 * 30
            
            print("\n--- check expired token -------------------------------\nregDate : \(regDate)\nexpiredTime : \(expiredTime)\nexpiredDate : \(expiredDate)\ncheckMinutes : \(checkMinutes)\nduration : \(duration)\n\n")
            
            if duration > checkMinutes {
                return true
            }
        }
        
        return false
    }
    
    func checkValidate() -> Bool {
        //print("\n--- checkValidate login ----------------------\naccessToken : \(accessToken)\nrefreshToken : \(refreshToken)\nuid : \(uid)\naccount : \(account)\npassword : \(password)\nloginType : \(loginType)\nexpiredTime : \(expiredTime)\n")
        
        if loginType == LoginType.email.rawValue {
            if accessToken.count > 0, refreshToken.count > 0, uid.count > 0, account.count > 0, password.count > 0, loginType.count > 0, expiredTime > 0 {
                return true
            }
        }
        else {
            if accessToken.count > 0, refreshToken.count > 0, uid.count > 0, account.count > 0, loginType.count > 0, expiredTime > 0 {
                return true
            }
        }
        
        
        
        return false
    }
    
}
