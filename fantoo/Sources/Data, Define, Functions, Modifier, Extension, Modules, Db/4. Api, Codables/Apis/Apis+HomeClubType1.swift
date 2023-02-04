//
//  Apis+FantooTVClub.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/17.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisHomeClubType1 {
    case DetailTop(clubId: String)
    case FollowInfo(clubId: String, integUid: String, access_token: String)
    case TabInfo(clubId: String, integUid: String)
    case HomeTab(clubId: String, categoryCode: String, integUid: String
                 , nextId: Int?, size: Int?)
    case ChannelTab(clubId: String, integUid: String, categoryCode: String)
    case Like(clubId: String, likeType: String, categoryCode: String, url_postId: Int, integUid: String, access_token: String)
}

extension ApisHomeClubType1: Moya.TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .DetailTop(let clubId):
            return "club/" + clubId + "/basic"
        case .FollowInfo(let clubId, _, _):
            return "club/" + clubId + "/follow"
        case .TabInfo(let clubId, _):
            return "club/" + clubId + "/category"
        case .HomeTab(let clubId, let categoryCode, _, _, _):
            return "club/" + clubId + "/board/" + categoryCode + "/post"
        case .ChannelTab(let clubId, _, let categoryCode):
            return "club/" + clubId + "/category/" + categoryCode
        case .Like(let clubId, let likeType, let categoryCode, let url_postId, _, _):
            return "club/" + clubId + "/" + likeType + "/" + categoryCode + "/post/" + String(url_postId)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Like:
            return .patch
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .DetailTop(_):
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .FollowInfo(_, let integUid, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .TabInfo(_, let integUid):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .HomeTab(_, _, let integUid, let nextId, let size):
            var params = defaultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .ChannelTab(_, let integUid, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .Like(_, _, _, _, let integUid, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
        case .FollowInfo(_, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .Like(_, _, _, _, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        default:
            header["Content-Type"] = "application/json"
        }
        return header
    }
    
    var defaultParams: [String : Any] {
        let params: [String: Any] = [:]
        return params
    }
    
    func log(params: [String: Any]) {
        if self.isApiLogOn() {
            print("\n--- API : \(baseURL)/\(path) -----------------------------------------------------------\n\(params)\n------------------------------------------------------------------------------------------------------------------------------\n")
        }
    }
}

extension ApisHomeClubType1 {
    var cacheTime: NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}

//MARK: - Log On/Off
extension ApisHomeClubType1 {
    func isAlLogOn() -> Bool {
        return true
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .DetailTop:
            return [true, true]
        case .FollowInfo:
            return [true, true]
        case .TabInfo:
            return [true, true]
        case .HomeTab:
            return [true, true]
        case .ChannelTab:
            return [true, true]
        case .Like:
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
extension ApisHomeClubType1 {
    func isCheckToken() -> Bool {
        switch self {
        case .DetailTop:
            return true
        case .FollowInfo:
            return true
        case .TabInfo:
            return true
        case .HomeTab:
            return true
        case .ChannelTab:
            return true
        case .Like:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisHomeClubType1 {
    func dataCachingTime() -> Int {
        switch self {
        case .DetailTop:
            return DataCachingTime.None.rawValue
        case .FollowInfo:
            return DataCachingTime.None.rawValue
        case .TabInfo:
            return DataCachingTime.None.rawValue
        case .HomeTab:
            return DataCachingTime.None.rawValue
        case .ChannelTab:
            return DataCachingTime.None.rawValue
        case .Like:
            return DataCachingTime.None.rawValue
        }
    }
}
