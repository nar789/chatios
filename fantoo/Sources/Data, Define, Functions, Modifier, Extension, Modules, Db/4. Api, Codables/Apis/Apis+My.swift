//
//  Apis+My.swift
//  fantoo
//
//  Created by fns on 2022/09/20.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisMy {
    case UserInfo(integUid: String)
    case InterestCategoryList(integUid: String, access_token: String)
    case UserInfoUpdate(userInfoType: String, birthDay: String, countryIsoTwo: String, genderType: String, interestList: Array<String>, userNick: String, userPhoto: String, integUid: String)
    case MyReferral(integUid: String, referralCode: String)
    case MyReferralCreate(integUid: String)
    case UserWithdrawal(integUid: String)
    case CheckUserPassword(integUid: String, loginPw: String)
    case ChangePassword(integUid: String, loginPw: String)
    case UserWallet(integUid: String)
    case UserWalletType(integUid: String, nextId: Int, size: Int, walletListType: String, walletType: String, yearMonth: String)
    case UserMenuStorage(integUid: String)
    case UserCommunityStorageReply(integUid: String, nextId: Int, size: Int)
    case UserCommunityStoragePost(integUid: String, nextId: Int, size: Int)
    case UserCommunityStorageBookmark(integUid: String, nextId: Int, size: Int)
}

extension ApisMy: Moya.TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .UserInfo:
            return "user/info"
        case .InterestCategoryList:
            return "user/interest/category"
        case .UserInfoUpdate(let userInfoType, _, _, _, _, _, _, _):
            return "user/info/update/" + userInfoType
        case .MyReferral:
            return "my/referral/use"
        case .MyReferralCreate:
            return "user/referral/create"
        case .UserWithdrawal:
            return "user/withdrawal"
        case .CheckUserPassword:
            return "my/user/pass/check"
        case .ChangePassword:
            return "my/user/pass/update"
        case .UserWallet:
            return "my/user/wallet"
        case .UserWalletType(_, _, _, _, let walletType, _):
            return "my/user/wallet/" + walletType
        case .UserMenuStorage:
            return "my/write/count/"
        case .UserCommunityStorageReply:
            return "community/my/reply"
        case .UserCommunityStoragePost:
            return "community/my/post"
        case .UserCommunityStorageBookmark:
            return "community/my/bookmark"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .UserInfo:
            return .post
        case .InterestCategoryList:
            return .get
        case .UserInfoUpdate:
            return .post
        case .MyReferral:
            return .post
        case .MyReferralCreate:
            return .get
        case .UserWithdrawal:
            return .post
        case .CheckUserPassword:
            return .post
        case .ChangePassword:
            return .post
        case .UserWallet:
            return .get
        case .UserWalletType:
            return .get
        case .UserMenuStorage:
            return .get
        case .UserCommunityStorageReply:
            return .get
        case .UserCommunityStoragePost:
            return .get
        case .UserCommunityStorageBookmark:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .UserInfo(let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .InterestCategoryList(let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .UserInfoUpdate(_, let birthDay, let countryIsoTwo, let genderType, let interestList, let userNick, let userPhoto, let integUid):
            var params = defultParams
            
            if birthDay.count > 0 {
                params["birthDay"] = birthDay
            }
            
            if countryIsoTwo.count > 0 {
                params["countryIsoTwo"] = countryIsoTwo
            }
            
            if genderType.count > 0 {
                params["genderType"] = genderType
            }
            
            if integUid.count > 0 {
                params["integUid"] = integUid
            }
            
            if interestList.count > 0 {
                var interests:[Any] = []
                for obj in interestList {
                    let dic = [DefineKey.code : obj]
                    interests.append(dic)
                }
                params["interestList"] = interests
            }
            
            if userNick.count > 0 {
                params["userNick"] = userNick
            }
            
            if userPhoto.count > 0 {
                params["userPhoto"] = userPhoto
            }
            
            log(params: params)
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default) // content-Type은 자동으로 'application/json'형식으로 변경된다.
            
        case .MyReferral(let integUid, let referralCode):
            var params = defultParams
            params["integUid"] = integUid
            params["referralCode"] = referralCode
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .MyReferralCreate(let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        case .UserWithdrawal(let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .CheckUserPassword(let integUid, let loginPw):
            var params = defultParams
            params["integUid"] = integUid
            params["loginPw"] = loginPw
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ChangePassword(let integUid, let loginPw):
            var params = defultParams
            params["integUid"] = integUid
            params["loginPw"] = loginPw
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        
        case .UserWallet(let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .UserWalletType(let integUid, let nextId, let size, let walletListType, _, let yearMonth):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            params["walletListType"] = walletListType
            params["yearMonth"] = yearMonth
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .UserMenuStorage(let integUid):
            var params = defultParams
            params["integUid"] = integUid
       
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .UserCommunityStorageReply(let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size

            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .UserCommunityStoragePost(let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size

            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        case .UserCommunityStorageBookmark(let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size

            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
//        case .InterestList(_, let access_token):
//            header["Content-Type"] = "application/json"
//            header["access_token"] = access_token
//
//        case .userInfoUpdate(_, _, _, _, _, _, _, _, let access_token):
//            header["Content-Type"] = "application/json"
//            header["access_token"] = access_token
//

        default:
            header["Content-Type"] = "application/json"
            header["access_token"] = UserManager.shared.accessToken
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

extension ApisMy {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisMy {
    func isAlLogOn() -> Bool {
        return true
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .UserInfo:
            return [true, true]
        case .InterestCategoryList:
            return [true, true]
        case .UserInfoUpdate:
            return [true, true]
        case .MyReferral:
            return [true, true]
        case .MyReferralCreate:
            return [true, true]
        case .UserWithdrawal:
            return [true, true]
        case .CheckUserPassword:
            return [true, true]
        case .ChangePassword:
            return [true, true]
        case .UserWallet:
            return [true, true]
        case .UserWalletType:
            return [true, true]
        case .UserMenuStorage:
            return [true, true]
        case .UserCommunityStorageReply:
            return [true, true]
        case .UserCommunityStoragePost:
            return [true, true]
        case .UserCommunityStorageBookmark:
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
extension ApisMy {
    func isCheckToken() -> Bool {
        switch self {
        case .UserInfo:
            return true
        case .InterestCategoryList:
            return true
        case .UserInfoUpdate:
            return true
        case .MyReferral:
            return true
        case .MyReferralCreate:
            return true
        case .UserWithdrawal:
            return true
        case .CheckUserPassword:
            return true
        case .ChangePassword:
            return true
        case .UserWallet:
            return true
        case .UserWalletType:
            return true
        case .UserMenuStorage:
            return true
        case .UserCommunityStorageReply:
            return true
        case .UserCommunityStoragePost:
            return true
        case .UserCommunityStorageBookmark:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisMy {
    func dataCachingTime() -> Int {
        switch self {
        case .UserInfo:
            return DataCachingTime.None.rawValue
        case .InterestCategoryList:
            return DataCachingTime.None.rawValue
        case .UserInfoUpdate:
            return DataCachingTime.None.rawValue
        case .MyReferral:
            return DataCachingTime.None.rawValue
        case .MyReferralCreate:
            return DataCachingTime.None.rawValue
        case .UserWithdrawal:
            return DataCachingTime.None.rawValue
        case .CheckUserPassword:
            return DataCachingTime.None.rawValue
        case .ChangePassword:
            return DataCachingTime.None.rawValue
        case .UserWallet:
            return DataCachingTime.None.rawValue
        case .UserWalletType:
            return DataCachingTime.None.rawValue
        case .UserMenuStorage:
            return DataCachingTime.None.rawValue
        case .UserCommunityStorageReply:
            return DataCachingTime.None.rawValue
        case .UserCommunityStoragePost:
            return DataCachingTime.None.rawValue
        case .UserCommunityStorageBookmark:
            return DataCachingTime.None.rawValue
        }
    }
}
