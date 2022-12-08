//
//  Apis+Reply.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisReply {
    case CommunityDetailReplyDetail(integUid: String, access_token: String, postId: Int, replyId: Int)
}

extension ApisReply: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .CommunityDetailReplyDetail:
            return URL(string: "https://fapi.fantoo.co.kr:9121")!
        }
    }
    
    var path: String {
        switch self {
        case .CommunityDetailReplyDetail(_, _, let postId, let replyId):
            return "community/" + String(postId) + "/reply/" + String(replyId)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .CommunityDetailReplyDetail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .CommunityDetailReplyDetail(let integUid, _, _, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFucntion.defaultHeader()
        
        switch self {
        case .CommunityDetailReplyDetail(_, let access_token, _, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
//        default:
//            header["Content-Type"] = "application/json"
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

extension ApisReply {
    var cacheTime: NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}

//MARK: - Log On/Off
extension ApisReply {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .CommunityDetailReplyDetail:
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
extension ApisReply {
    func isCheckToken() -> Bool {
        switch self {
        case .CommunityDetailReplyDetail:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisReply {
    func dataCachingTime() -> Int {
        switch self {
        case .CommunityDetailReplyDetail:
            return DataCachingTime.None.rawValue
        }
    }
}
