//
//  Apis+Login.swift
//  fantoo
//
//  Created by mkapps on 2022/07/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisLogin {
    case Login(clientId:String, loginId:String, loginPw:String, loginType:String, responseType:String)
    case SnsLogin(clientId:String, loginId:String, loginType:String, responseType:String)
    case IssueToken(clientId:String, clientSecret:String, grantType:String, state:String, authCode:String)
    case RefreshToken(clientId:String, clientSecret:String, grantType:String, refresh_token:String)
    
    case EmailJoin(adAgreeChoice:String, ageAgree:String, countryIsoTwo:String, email:String, loginPw:String, serviceAgree:String, teenagerAgree:String, useReferralCode:String, userInfoAgree:String, userNick:String)
    case SnsJoin(adAgreeChoice:String, ageAgree:String, countryIsoTwo:String, loginId:String, loginType:String, serviceAgree:String, teenagerAgree:String, useReferralCode:String, userInfoAgree:String, userNick:String)
    
    case JoinCheck(loginId: String, loginType: String)
    case CheckNickName(nickName: String)
    case SendEmail(loginId: String)
    case SendEmailNumberCheck(authCode: String, loginId: String)
    case TempPassword(loginId: String)

}

extension ApisLogin: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .Login: fallthrough
        case .SnsLogin: fallthrough
        case .IssueToken: fallthrough
        case .RefreshToken:
            return URL(string: DefineUrl.Domain.Login)!
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .Login:
            return "oauth2.0/authorize"
        case .SnsLogin:
            return "oauth2.0/authorize"
        case .IssueToken:
            return "oauth2.0/token"
        case .RefreshToken:
            return "oauth2.0/token"
            
        case .EmailJoin:
            return "user/email/join"
        case .SnsJoin:
            return "user/sns/join"
            
        case .JoinCheck:
            return "user/join/check"
        case .CheckNickName:
            return "user/check/nickname"
        case .SendEmail:
            return "user/join/email/send"
        case .SendEmailNumberCheck:
            return "user/join/email/auth/check"
        case .TempPassword:
            return "user/email/pass/temp"
    
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Login:
            return .post
        case .SnsLogin:
            return .post
        case .IssueToken:
            return .post
        case .RefreshToken:
            return .post
            
        case .EmailJoin:
            return .post
        case .SnsJoin:
            return .post

        case .JoinCheck:
            return .get
        case .CheckNickName:
            return .get
        case .SendEmail:
            return .get
        case .SendEmailNumberCheck:
            return .get
        case .TempPassword:
            return .get

        }
    }
    
    var task: Task {
        switch self {

        case .Login(let clientId, let loginId, let loginPw, let loginType, let responseType):
            var params = defultParams
            params[DefineKey.clientId] = clientId
            params[DefineKey.loginId] = loginId
            params[DefineKey.loginPw] = loginPw
            params[DefineKey.loginType] = loginType
            params[DefineKey.responseType] = responseType

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .SnsLogin(let clientId, let loginId, let loginType, let responseType):
            var params = defultParams
            params[DefineKey.clientId] = clientId
            params[DefineKey.loginId] = loginId
            params[DefineKey.loginType] = loginType
            params[DefineKey.responseType] = responseType

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .IssueToken(let clientId, let clientSecret, let grantType, let state, let authCode):
            var params = defultParams
            params[DefineKey.clientId] = clientId
            params[DefineKey.clientSecret] = clientSecret
            params[DefineKey.grantType] = grantType
            params[DefineKey.state] = state
            params[DefineKey.authCode] = authCode

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .RefreshToken(let clientId, let clientSecret, let grantType, let refresh_token):
            var params = defultParams
            params[DefineKey.clientId] = clientId
            params[DefineKey.clientSecret] = clientSecret
            params[DefineKey.grantType] = grantType
            params[DefineKey.refresh_token] = refresh_token

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .EmailJoin(let adAgreeChoice, let ageAgree, let countryIsoTwo, let email, let loginPw, let serviceAgree, let teenagerAgree, let useReferralCode, let userInfoAgree, let userNick):
            var params = defultParams
            params[DefineKey.adAgreeChoice] = adAgreeChoice
            params[DefineKey.ageAgree] = ageAgree
            params[DefineKey.countryIsoTwo] = countryIsoTwo
            params[DefineKey.email] = email
            params[DefineKey.loginPw] = loginPw
            
            params[DefineKey.serviceAgree] = serviceAgree
            params[DefineKey.teenagerAgree] = teenagerAgree
            
            if useReferralCode.count > 0 {
                params[DefineKey.useReferralCode] = useReferralCode
            }
            
            params[DefineKey.userInfoAgree] = userInfoAgree
            params[DefineKey.userNick] = userNick

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .SnsJoin(let adAgreeChoice, let ageAgree, let countryIsoTwo, let loginId, let loginType, let serviceAgree, let teenagerAgree, let useReferralCode, let userInfoAgree, let userNick):
            var params = defultParams
            params[DefineKey.adAgreeChoice] = adAgreeChoice
            params[DefineKey.ageAgree] = ageAgree
            params[DefineKey.countryIsoTwo] = countryIsoTwo
            params[DefineKey.loginId] = loginId
            params[DefineKey.loginType] = loginType
            
            params[DefineKey.serviceAgree] = serviceAgree
            params[DefineKey.teenagerAgree] = teenagerAgree
            
            if useReferralCode.count > 0 {
                params[DefineKey.useReferralCode] = useReferralCode
            }
            
            params[DefineKey.userInfoAgree] = userInfoAgree
            params[DefineKey.userNick] = userNick

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .JoinCheck(let loginId, let loginType):
            var params = defultParams
            params[DefineKey.loginId] = loginId
            params[DefineKey.loginType] = loginType

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CheckNickName(let nickName):
            var params = defultParams
            params[DefineKey.nickname] = nickName

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        
        case .SendEmail(let loginId):
            var params = defultParams
            params[DefineKey.loginId] = loginId

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .SendEmailNumberCheck(let authCode, let loginId):
            var params = defultParams
            params[DefineKey.authCode] = authCode
            params[DefineKey.loginId] = loginId
            
            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .TempPassword(let loginId):
            var params = defultParams
            params[DefineKey.loginId] = loginId

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        
            
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
            
        default:
            //header["Content-Type"] = "binary/octet-stream"
            //            header["Content-Type"] = "application/x-www-form-urlencoded"
            header["Content-Type"] = "application/json"
        }
        
        return header
    }
    
    
    var defultParams: [String : Any] {
        return CommonFunction.defaultParams()
    }
    
    func log(params: [String: Any]) {
        if self.isApiLogOn() {
            print("\n--- API : \(baseURL)/\(path) -----------------------------------------------------------\n\(params)\n------------------------------------------------------------------------------------------------------------------------------\n")
        }
    }
}

extension ApisLogin {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisLogin {
    func isAlLogOn() -> Bool {
        return true
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .Login:
            return [true, true]
        case .SnsLogin:
            return [true, true]
        case .IssueToken:
            return [true, true]
        case .RefreshToken:
            return [true, true]
        case .EmailJoin:
            return [true, true]
        case .SnsJoin:
            return [true, true]
        case .JoinCheck:
            return [true, true]
        case .CheckNickName:
            return [true, true]
        case .SendEmail:
            return [true, true]
        case .SendEmailNumberCheck:
            return [true, true]
        case .TempPassword:
            return [true, true]
        }
    }
    
    func isApiLogOn() -> Bool {
        if self.isAlLogOn(), self.isLogOn()[0] {
            return true
        }
        
        return false
    }
    
    func isResponseLog() -> Bool {
        if self.isAlLogOn(), self.isLogOn()[1] {
            return true
        }
        
        return false
    }
}


//MARK: - Check Token or not
extension ApisLogin {
    func isCheckToken() -> Bool {
        switch self {
        case .Login:
            return false
        case .SnsLogin:
            return false
        case .IssueToken:
            return false
        case .RefreshToken:
            return false
        case .EmailJoin:
            return false
        case .SnsJoin:
            return false
        case .JoinCheck:
            return false
        case .CheckNickName:
            return false
        case .SendEmail:
            return false
        case .SendEmailNumberCheck:
            return false
        case .TempPassword:
            return false
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisLogin {
    func dataCachingTime() -> Int {
        switch self {
        case .Login:
            return DataCachingTime.None.rawValue
        case .SnsLogin:
            return DataCachingTime.None.rawValue
        case .IssueToken:
            return DataCachingTime.None.rawValue
        case .RefreshToken:
            return DataCachingTime.None.rawValue
        case .EmailJoin:
            return DataCachingTime.None.rawValue
        case .SnsJoin:
            return DataCachingTime.None.rawValue
        case .JoinCheck:
            return DataCachingTime.None.rawValue
        case .CheckNickName:
            return DataCachingTime.None.rawValue
        case .SendEmail:
            return DataCachingTime.None.rawValue
        case .SendEmailNumberCheck:
            return DataCachingTime.None.rawValue
        case .TempPassword:
            return DataCachingTime.None.rawValue
        }
    }
}
