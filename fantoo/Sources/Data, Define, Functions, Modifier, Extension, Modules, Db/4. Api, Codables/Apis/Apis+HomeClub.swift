//
//  Apis+HomeClub.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisHomeClub {
    case TabHomeDummy
    case TabHome(clubId: String, integUid: String, nextId: Int?, size: Int)
    case TabFreeBoard
    case TabArchive
    case TabBank
    case ClubBasicInfo(clubId: String, intergUid: String)
    case ClubBoard(clubId: String, categoryCode: String, integUid: String, nextId: Int?, size: Int)
    case ClubCategory(clubId: String, categoryCode: String?, integUid: String)
    case ClubLogin(clubId: String, intergUid: String, accessToken: String)
    case ClubVisit(clubId: String, intergUid: String)
    
}

extension ApisHomeClub: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .TabHomeDummy:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .TabFreeBoard:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .TabArchive:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .TabBank:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .TabHome(let clubId, _, _, _):
            return "club/\(clubId)/board/home/post"
        case .TabHomeDummy:
            return "api/fantoo2_dummy/home_club/tab_home"
        case .TabFreeBoard:
            return "api/fantoo2_dummy/home_club/tab_freeboard"
        case .TabArchive:
            return "api/fantoo2_dummy/home_club/tab_archive"
        case .TabBank:
            return "api/fantoo2_dummy/home_club/tab_bank"
        case .ClubBasicInfo(let clubId, _):
            return "club/\(clubId)/basic"
        case .ClubLogin(let clubId, _, _):
            return "club/\(clubId)/login"
        case .ClubVisit(let clubId, _):
            return "club/\(clubId)/visit"
        case .ClubBoard(let clubId, let categoryCode, _, _, _):
            return "club/\(clubId)/board/\(categoryCode)/post"
        case .ClubCategory(let clubId, let categoryCode, _):
            if let cate = categoryCode {
                return "club/\(clubId)/category/\(cate)"
            } else {
                return "club/\(clubId)/category"
            }
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .TabHome:
            return .get
        case .TabHomeDummy:
            return .get
        case .TabFreeBoard:
            return .get
        case .TabArchive:
            return .get
        case .TabBank:
            return .get
        case .ClubLogin:
            return .patch
        case .ClubVisit:
            return .patch
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .TabHome(_, let integUid, let nextId, let size):
            var params = defaultParams
            params["integUid"] = integUid
            if let nId = nextId {
                params["nextId"] = nId
            }
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .ClubBasicInfo(_, let integUid):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .ClubLogin(_, let integUid, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .ClubVisit(_, let integUid):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .ClubBoard(_, _, let integUid, let nextId, let size):
            var params = defaultParams
            params["integUid"] = integUid
            if let nId = nextId {
                params["nextId"] = nId
            }
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .ClubCategory(_, _, let integUid):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
        case .ClubLogin(_, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
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

extension ApisHomeClub {
    var cacheTime: NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}

//MARK: - Log On/Off
extension ApisHomeClub {
    func isAlLogOn() -> Bool {
        return true
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .TabHome:
            return [true, true]
        case .TabHomeDummy:
            return [true, true]
        case .TabFreeBoard:
            return [true, true]
        case .TabArchive:
            return [true, true]
        case .TabBank:
            return [true, true]
        default:
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
extension ApisHomeClub {
    func isCheckToken() -> Bool {
        switch self {
        case .TabHome:
            return true
        case .TabHomeDummy:
            return true
        case .TabFreeBoard:
            return true
        case .TabArchive:
            return true
        case .TabBank:
            return true
        default:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisHomeClub {
    func dataCachingTime() -> Int {
        switch self {
        case .TabHome:
            return DataCachingTime.None.rawValue
        case .TabHomeDummy:
            return DataCachingTime.None.rawValue
        case .TabFreeBoard:
            return DataCachingTime.None.rawValue
        case .TabArchive:
            return DataCachingTime.None.rawValue
        case .TabBank:
            return DataCachingTime.None.rawValue
        default:
            return DataCachingTime.None.rawValue
        }
    }
}
