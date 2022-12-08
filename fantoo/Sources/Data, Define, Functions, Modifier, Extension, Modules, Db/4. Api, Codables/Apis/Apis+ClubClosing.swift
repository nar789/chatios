//
//  Apis+ClubClosing.swift
//  fantoo
//
//  Created by fns on 2022/10/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisClubClosing {
    case ClubClosingRequest(clubId: String, integUid: String)
    case ClubClosingState(clubId: String, integUid: String)
    case ClubClosingCancel(clubId: String, integUid: String)
   
}

extension ApisClubClosing: Moya.TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .ClubClosingRequest(let clubId, _):
            return "club/" + clubId + "/closes"
        case .ClubClosingState(let clubId, _):
            return "club/" + clubId + "/closes"
        case .ClubClosingCancel(let clubId, _):
            return "club/" + clubId + "/closes/cancel"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .ClubClosingRequest:
            return .post
        case .ClubClosingState:
            return .get
        case .ClubClosingCancel:
            return .patch
        }
        
    }
    
    var task: Task {
        switch self {
        case .ClubClosingRequest(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubClosingState(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubClosingCancel(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFucntion.defaultHeader()
        
        switch self {
        default:
            header["Content-Type"] = "application/json"
            header["access_token"] = UserManager.shared.accessToken
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

extension ApisClubClosing {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisClubClosing {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .ClubClosingRequest:
            return [true, true]
        case .ClubClosingState:
            return [true, true]
        case .ClubClosingCancel:
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
extension ApisClubClosing {
    func isCheckToken() -> Bool {
        switch self {
        case .ClubClosingRequest:
            return true
        case .ClubClosingState:
            return true
        case .ClubClosingCancel:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisClubClosing {
    func dataCachingTime() -> Int {
        switch self {
        case .ClubClosingRequest:
            return DataCachingTime.None.rawValue
        case .ClubClosingState:
            return DataCachingTime.None.rawValue
        case .ClubClosingCancel:
            return DataCachingTime.None.rawValue
        }
    }
}
