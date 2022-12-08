//
//  Apis+DetailPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisDetailPage {
    case CommunityDetail(integUid: String, access_token: String, code: String, postId: Int)
    case CommunityDetailReply(integUid: String, access_token: String, postId: Int, size: Int)
    case CommunityDetailPage
    case ClubDetailPage
    case CommunityPostReply(postId: Int, anonymYn: Bool, attachList: [CommonReplyModel_AttachList], content: String, integUid: String, access_token: String)
    case CommunityPostBookmark(postId: Int, integUid: String, access_token: String)
    case CommunityDeleteBookmark(postId: Int, integUid: String, access_token: String)
}

extension ApisDetailPage: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .CommunityDetailPage:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .ClubDetailPage:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .CommunityDetail(_, _, let code, let postId):
            return "community/" + code + "/post/" + String(postId)
        case .CommunityDetailReply(_, _, let postId, _):
            return "community/" + String(postId) + "/reply"
        case .CommunityDetailPage:
            return "api/fantoo2_dummy/community_detail"
        case .ClubDetailPage:
            return "api/fantoo2_dummy/club_detail"
        case .CommunityPostReply(let postId, _, _, _, _, _):
            return "community/" + String(postId) + "/reply"
        case .CommunityPostBookmark(let postId, _, _):
            return "community/my/bookmark/" + String(postId)
        case .CommunityDeleteBookmark(let postId, _, _):
            return "community/my/bookmark/" + String(postId)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .CommunityDetail:
            return .get
        case .CommunityDetailReply:
            return .get
        case .CommunityDetailPage:
            return .get
        case .ClubDetailPage:
            return .get
        case .CommunityPostReply:
            return .post
        case .CommunityPostBookmark:
            return .post
        case .CommunityDeleteBookmark:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .CommunityDetail(let integUid, _, _, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .CommunityDetailReply(let integUid, _, _, let size):
            var params = defaultParams
            params["integUid"] = integUid
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .CommunityDetailPage:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .ClubDetailPage:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .CommunityPostReply(_, let anonymYn, let attachList, let content, let integUid, _):
            var params = defaultParams
            params["anonymYn"] = anonymYn
            params["attachList"] = attachList
            params["content"] = content
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .CommunityPostBookmark(_, let integUid, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .CommunityDeleteBookmark(_, let integUid, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
        
    }
    
    var headers: [String : String]? {
        var header = CommonFucntion.defaultHeader()
        
        switch self {
        case .CommunityDetail(_, let access_token, _, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .CommunityDetailReply(_, let access_token, _, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .CommunityPostReply(_, _, _, _, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .CommunityPostBookmark(_, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .CommunityDeleteBookmark(_, _, let access_token):
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

extension ApisDetailPage {
    var cacheTime: NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}

//MARK: - Log On/Off
extension ApisDetailPage {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .CommunityDetail:
            return [true, true]
        case .CommunityDetailReply:
            return [true, true]
        case .CommunityDetailPage:
            return [true, true]
        case .ClubDetailPage:
            return [true, true]
        case .CommunityPostReply:
            return [true, true]
        case .CommunityPostBookmark:
            return [true, true]
        case .CommunityDeleteBookmark:
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
extension ApisDetailPage {
    func isCheckToken() -> Bool {
        switch self {
        case .CommunityDetail:
            return true
        case .CommunityDetailReply:
            return true
        case .CommunityDetailPage:
            return true
        case .ClubDetailPage:
            return true
        case .CommunityPostReply:
            return true
        case .CommunityPostBookmark:
            return true
        case .CommunityDeleteBookmark:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisDetailPage {
    func dataCachingTime() -> Int {
        switch self {
        case .CommunityDetail:
            return DataCachingTime.None.rawValue
        case .CommunityDetailReply:
            return DataCachingTime.None.rawValue
        case .CommunityDetailPage:
            return DataCachingTime.None.rawValue
        case .ClubDetailPage:
            return DataCachingTime.None.rawValue
        case .CommunityPostReply:
            return DataCachingTime.None.rawValue
        case .CommunityPostBookmark:
            return DataCachingTime.None.rawValue
        case .CommunityDeleteBookmark:
            return DataCachingTime.None.rawValue
        }
    }
}
