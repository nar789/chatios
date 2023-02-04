//
//  Apis+MainTabClub.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisMainClub {
    case MyPage(integUid: String, nextId: String, size: String)
    case PopularClubCategory(integUid: String)
    case PopularClub(categoryCode: String, integUid: String)
    case NewClub(integUid: String)
    case PopularTop10(integUid: String)
    case PopularClubTop100(integUid: String)
    case ClubSearch(keyword: String, nextId: String, size: String)
}

extension ApisMainClub: Moya.TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .MyPage:
            return "club/my/basic"
        case .PopularClubCategory:
            return "club/main/popular/club/category/list"
        case .PopularClub:
            return "club/main/popular/club/category/top10"
        case .NewClub:
            return "club/main/newly/club/top10"
        case .PopularTop10:
            return "club/main/popular/post/top10"
        case .PopularClubTop100:
            return "club/main/popular/club/top100"
        case .ClubSearch:
            return "club/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .MyPage(let integUid, let nextId, let size):
            var params = defaultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .PopularClubCategory(let integUid):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .PopularClub(let categoryCode, let integUid):
            var params = defaultParams
            params["categoryCode"] = categoryCode
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .NewClub(let integUid):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .PopularTop10(let integUid):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .PopularClubTop100(let integUid):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .ClubSearch(let keyword, let nextId, let size):
            var params = defaultParams
            params["keyword"] = keyword
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
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

extension ApisMainClub {
    var cacheTime: NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}

//MARK: - Log On/Off
extension ApisMainClub {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .MyPage:
            return [true, true]
        case .PopularClubCategory:
            return [true, true]
        case .PopularClub:
            return [true, true]
        case .NewClub:
            return [true, true]
        case .PopularTop10:
            return [true, true]
        case .PopularClubTop100:
            return [true, true]
        case .ClubSearch:
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
extension ApisMainClub {
    func isCheckToken() -> Bool {
        switch self {
        case .MyPage:
            return true
        case .PopularClubCategory:
            return true
        case .PopularClub:
            return true
        case .NewClub:
            return true
        case .PopularTop10:
            return true
        case .PopularClubTop100:
            return true
        case .ClubSearch:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisMainClub {
    func dataCachingTime() -> Int {
        switch self {
        case .MyPage:
            return DataCachingTime.None.rawValue
        case .PopularClubCategory:
            return DataCachingTime.None.rawValue
        case .PopularClub:
            return DataCachingTime.None.rawValue
        case .NewClub:
            return DataCachingTime.None.rawValue
        case .PopularTop10:
            return DataCachingTime.None.rawValue
        case .PopularClubTop100:
            return DataCachingTime.None.rawValue
        case .ClubSearch:
            return DataCachingTime.None.rawValue
        }
    }
}
