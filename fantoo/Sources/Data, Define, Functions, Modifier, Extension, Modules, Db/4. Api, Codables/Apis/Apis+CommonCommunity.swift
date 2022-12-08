//
//  Apis+CommonCommunity.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisCommonCommunity {
    case Like(likeType: String, targetType: String, targetId: Int, integUid: String, access_token: String)
    case DeleteLike(targetType: String, targetId: Int, integUid: String, access_token: String)
    case MemberRecogCategory(integUid: String, access_token: String)
    case MemberSubCategory(code: String, integUid: String, access_token: String)
}

extension ApisCommonCommunity: Moya.TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .Like(let likeType, let targetType, let targetId, _, _):
            return "community/" + likeType + "/" + targetType + "/target-id/" + String(targetId)
        case .DeleteLike(let targetType, let targetId, _, _):
            return "community/like/" + targetType + "/target-id/" + String(targetId)
        case .MemberRecogCategory:
            return "community/category"
        case .MemberSubCategory(let code, _, _):
            return "community/category/" + code
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Like:
            return .post
        case .DeleteLike:
            return .delete
        case .MemberRecogCategory:
            return .get
        case .MemberSubCategory:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .Like(_, _, _, let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .DeleteLike(_, _, let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .MemberRecogCategory(let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .MemberSubCategory(_, let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFucntion.defaultHeader()
        
        switch self {
        case .Like(_, _, _, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        case .DeleteLike(_, _, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        case .MemberRecogCategory(_, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        case .MemberSubCategory(_, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        default:
            header["Content-Type"] = "application/json"
        }
        return header
    }
    
    var defultParams: [String : Any] {
        return CommonFucntion.defaultParams()
    }
    
    func log(params: [String: Any]) {
        if self.isApiLogOn() {
            print("\n--- API : \(baseURL)/\(path) -----------------------------------------------------------\n\(params)\n------------------------------------------------------------------------------------------------------------------------------\n")
        }
    }
}

extension ApisCommonCommunity {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisCommonCommunity {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .Like:
            return [true, true]
        case .DeleteLike:
            return [true, true]
        case .MemberRecogCategory:
            return [true, true]
        case .MemberSubCategory:
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
extension ApisCommonCommunity {
    func isCheckToken() -> Bool {
        switch self {
        case .Like:
            return true
        case .DeleteLike:
            return true
        case .MemberRecogCategory:
            return true
        case .MemberSubCategory:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisCommonCommunity {
    func dataCachingTime() -> Int {
        switch self {
        case .Like:
            return DataCachingTime.None.rawValue
        case .DeleteLike:
            return DataCachingTime.None.rawValue
        case .MemberRecogCategory:
            return DataCachingTime.None.rawValue
        case .MemberSubCategory:
            return DataCachingTime.None.rawValue
        }
    }
}
