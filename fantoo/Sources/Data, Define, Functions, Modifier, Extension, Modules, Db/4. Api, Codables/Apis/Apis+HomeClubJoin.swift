//
//  Apis+HomeClubJoin.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/27.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisHomeClubJoin {
    case ClubNicknameCheck(clubId: String, nickname: String)
    case ClubJoin(clubId: String, nickname: String, checkToken: String, integUid: String, accessToken: String, profileImg: String?)
    case ClubJoinCancel(clubId: String, integUid: String, accessToken: String)
}

extension ApisHomeClubJoin: Moya.TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .ClubNicknameCheck(let clubId, _):
            return "club/\(clubId)/member/nickname"
        case .ClubJoin(let clubId, _, _, _, _, _):
            return "club/\(clubId)/join/member"
        case .ClubJoinCancel(let clubId, _, _):
            return "club/\(clubId)/join/member/cancel"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .ClubNicknameCheck:
            return .get
        case .ClubJoin:
            return .post
        case .ClubJoinCancel:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .ClubNicknameCheck(_, let nickname):
            var params = defultParams
            params["nickname"] = nickname
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubJoin(_, let nickname, let checkToken, let integUid, _, let profileImg):
            var params = defultParams
            params["nickname"] = nickname
            params["integUid"] = integUid
            params["checkToken"] = checkToken
            if let img = profileImg {
                params["profileImg"] = img
            }
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .ClubJoinCancel(_, let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
        case .ClubJoin(_,_,_,_, let accessToken,_):
            header["Content-Type"] = "application/json"
            header["access_token"] = accessToken
        case .ClubJoinCancel(_,_, let accessToken):
            header["Content-Type"] = "application/json"
            header["access_token"] = accessToken
        default:
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

extension ApisHomeClubJoin {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisHomeClubJoin {
    func isAlLogOn() -> Bool {
        return true
    }
    
    func isLogOn() -> [Bool] {
        switch self {
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
extension ApisHomeClubJoin {
    func isCheckToken() -> Bool {
        switch self {
        default:
            return true
            
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisHomeClubJoin {
    func dataCachingTime() -> Int {
        switch self {
        default:
            return DataCachingTime.None.rawValue
            
        }
    }
}
