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
    // Community
    case CommunityDetail(integUid: String, access_token: String, code: String, postId: Int)
    case CommunityDetailReply(integUid: String, access_token: String, postId: Int, size: Int, nextPage: Int)
    case CommunityDetailPage
    case CommunityPostReply(postId: Int, anonymYn: Bool, imageName: String, mediaType: String, content: String, integUid: String, access_token: String)
    case CommunityPostBookmark(postId: Int, integUid: String, access_token: String)
    case CommunityDeleteBookmark(postId: Int, integUid: String, access_token: String)
    
    // Club
    case ClubDetailPage // 지울것
    case ClubDetail(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String)
    case ClubDetailReply(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String, nextId: String, size: String)
    case FetchClubDetailBookmark(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String)
    case PatchClubDetailBookmark(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String)
    case ClubPostReply(clubId: String, categoryCode: String, postId: Int, langCode: String, imageName: String, mediaType: String, replyTxt: String, integUid: String, access_token: String)
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
            // Community
        case .CommunityDetail(_, _, let code, let postId):
            return "community/" + code + "/post/" + String(postId)
        case .CommunityDetailReply(_, _, let postId, _, _):
            return "community/" + String(postId) + "/reply"
        case .CommunityDetailPage:
            return "api/fantoo2_dummy/community_detail"
        case .CommunityPostReply(let postId, _, _, _, _, _, _):
            return "community/" + String(postId) + "/reply"
        case .CommunityPostBookmark(let postId, _, _):
            return "community/my/bookmark/" + String(postId)
        case .CommunityDeleteBookmark(let postId, _, _):
            return "community/my/bookmark/" + String(postId)
            
            // Club
        case .ClubDetailPage:
            return "api/fantoo2_dummy/club_detail"
        case .ClubDetail(let clubId, let categoryCode, let postId, _, _):
            return "/club/" + clubId + "/board/" + categoryCode + "/post/" + String(postId)
        case .ClubDetailReply(let clubId, let categoryCode, let postId, _, _, _, _):
            return "/club/" + clubId + "/board/" + categoryCode + "/post/" + String(postId) + "/reply"
        case .FetchClubDetailBookmark(let clubId, let categoryCode, let postId, _, _):
            return "/club/" + clubId + "/bookmark/" + categoryCode + "/post/" + String(postId)
        case .PatchClubDetailBookmark(let clubId, let categoryCode, let postId, _, _):
            return "/club/" + clubId + "/bookmark/" + categoryCode + "/post/" + String(postId)
        case .ClubPostReply(let clubId, let categoryCode, let postId, _, _, _, _, _, _):
            return "/club/" + clubId + "/board/" + categoryCode + "/post/" + String(postId) + "/reply"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .CommunityPostReply:
            return .post
        case .CommunityPostBookmark:
            return .post
        case .CommunityDeleteBookmark:
            return .delete
        case .PatchClubDetailBookmark:
            return .patch
        case .ClubPostReply:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
            // Community
        case .CommunityDetail(let integUid, _, _, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .CommunityDetailReply(let integUid, _, _, let size, let nextPage):
            var params = defaultParams
            params["integUid"] = integUid
            params["size"] = size
            params["nextId"] = nextPage
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .CommunityDetailPage:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .CommunityPostReply(_, let anonymYn, let imageName, let mediaType, let content, let integUid, _):
            var params = defaultParams
            params["anonymYn"] = anonymYn
            
            var messageParams = Array<Any>()
            if mediaType == "image" {
                let obj = [
                    "attachType" : "image",
                    "id" : imageName
                ]
                messageParams.append(obj)
                
                params["attachList"] = messageParams
            }
            
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
            
            // Club
        case .ClubDetailPage:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .ClubDetail(_, _, _, let integUid, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .ClubDetailReply(_, _, _, let integUid, _, let nextId, let size):
            var params = defaultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .FetchClubDetailBookmark(_, _, _, let integUid, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .PatchClubDetailBookmark(_, _, _, let integUid, _):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .ClubPostReply(_, _, _, let langCode, let imageName, let mediaType, let replyTxt, let integUid, _):
            var params = defaultParams
            // Postman Body Contents
//            {
//              "attachList": [
//                {
//                  "attach": "IMAGE_ABCDEFGH1234567890",
//                  "attachType": 0
//                },
//                {
//                  "attach": "VIDEO_ABCDEFGH1234567890",
//                  "attachType": 1
//                }
//              ],
//              "content": "idpil 02",
//              "integUid": "ft_u_73bb0e80f68311ec8c4a2bae01ffd812_2022_06_28_01_41_38_443",
//              "langCode": "KR"
//            }
            
            var messageParams = Array<Any>()
            if mediaType == "image" {
                // 미디어 타입(0:이미지, 1:동영상)
                let obj = [
                    "attach" : imageName,
                    "attachType" : 0
                ] as [String : Any]
                messageParams.append(obj)
                
                params["attachList"] = messageParams
            }
            
            params["content"] = replyTxt
            params["integUid"] = integUid
            params["langCode"] = langCode
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        }
        
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
            // Community
        case .CommunityDetail(_, let access_token, _, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .CommunityDetailReply(_, let access_token, _, _, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .CommunityPostReply(_, _, _, _, _, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .CommunityPostBookmark(_, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .CommunityDeleteBookmark(_, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            
            // Club
        case .ClubDetail(_, _, _, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .ClubDetailReply(_, _, _, _, let access_token, _, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .FetchClubDetailBookmark(_, _, _, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .PatchClubDetailBookmark(_, _, _, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
        case .ClubPostReply(_, _, _, _, _, _, _, _, let access_token):
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
extension ApisDetailPage {
    func isCheckToken() -> Bool {
        switch self {
        default:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisDetailPage {
    func dataCachingTime() -> Int {
        switch self {
        default:
            return DataCachingTime.None.rawValue
        }
    }
}
