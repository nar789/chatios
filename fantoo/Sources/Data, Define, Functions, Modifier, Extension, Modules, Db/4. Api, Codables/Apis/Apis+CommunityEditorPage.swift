//
//  Apis+CommunityEditorPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/27.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisCommunityEditorPage {
    case PostBoard(code: String, anonymYn: Bool, attachList: [CommonReplyModel_AttachList], content: String, hashtagList: [Community_hashtagList], integUid: String, subCode: String, title: String, access_token: String)
}

extension ApisCommunityEditorPage: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .PostBoard:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .PostBoard(let code, _, _, _, _, _, _, _, _):
            return "community/" + code + "/post"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .PostBoard:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .PostBoard(_, let anonymYn, let attachList, let content, let hashtagList, let integUid, let subCode, let title, _):
            var params = defaultParams
            params["anonymYn"] = anonymYn
            params["attachList"] = attachList
            params["content"] = content
            params["hashtagList"] = hashtagList
            params["integUid"] = integUid
            params["subCode"] = subCode
            params["title"] = title
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFucntion.defaultHeader()
        
        switch self {
        case .PostBoard(_, _, _, _, _, _, _, _, let access_token):
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

extension ApisCommunityEditorPage {
    var cacheTime: NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}

//MARK: - Log On/Off
extension ApisCommunityEditorPage {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .PostBoard:
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
extension ApisCommunityEditorPage {
    func isCheckToken() -> Bool {
        switch self {
        case .PostBoard:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisCommunityEditorPage {
    func dataCachingTime() -> Int {
        switch self {
        case .PostBoard:
            return DataCachingTime.None.rawValue
        }
    }
}
