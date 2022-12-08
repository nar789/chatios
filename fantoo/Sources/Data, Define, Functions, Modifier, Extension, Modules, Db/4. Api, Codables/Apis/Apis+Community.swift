//
//  Apis+Community.swift
//  fantoo
//
//  Created by kimhongpil on 2022/06/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisCommunity {
    case Community_TopNotice    // 전체공지 TOP고정 List
    case Community_TopNoticeMore(nextId: Int, size: Int)   // 전체공지 List (Paging)
    case Community_TopNoticeCategory(code: String)  // 각 카테고리 TOP 고정 List
    case CommunityNoticeDetail_Total(postId: Int)   // 전체공지 Detail
    case CommunityNoticeDetail_Category(code: String, postId: Int)  // 각 카테고리 Detail
    case MainCommunity_GuestCategory    // 비회원
    case MainCommunity_GuestBoard       // 비회원
    case MainCommunity_UserCategory_Recog(integUid: String, access_token: String) // 회원 - 팬투 추천순
    case MainCommunity_UserCategory_Popular(integUid: String, access_token: String) // 회원 - 인기순
    case MainCommunity_UserBoard(integUid: String, access_token: String)    // 회원
    case CategoryFavoritePost(code: String, integUid: String, access_token: String)
    case CategoryFavoriteDelete(code: String, integUid: String, access_token: String)
    case MemberSearch(integUid: String, nextId: Int, search: String, size: Int, access_token: String)
    case EachCategoryBoards(code: String, globalYn: Bool, integUid: String, nextId: Int, size: Int, subCode: String, access_token: String)
    
    /**
     * 광고 서버에서 임시로 만든 API 모델 (fantoo api 적용 후 삭제할 것)
     */
    case CommunityCategory
    case CommunityNotice
    case CommunityCategoryFantooMember(integUid: String, access_token: String)
    case CommunityCategoryPopularMember(page: Int=1, pages: Int=10)
    case CommunitySubcategoryMember(page: Int=1, pages: Int=10)
    case CommunityCategoryFantooNonmember
    case CommunitySubcategoryNonmember(loginId: String, loginType: String)
    case CommunityCategoryNotice(nickname: String)
    case CommunityTopFive
    case CommunitySearch
    case CommunityMyBoard
    case CommunityMyComment
}

extension ApisCommunity: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .CommunityCategory:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .CommunityNotice:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .CommunityTopFive:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .CommunitySearch:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .CommunityMyBoard:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .CommunityMyComment:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .Community_TopNotice:
            return "community/notice/top"
        case .Community_TopNoticeMore:
            return "community/notice"
        case .Community_TopNoticeCategory(let code):
            return "community/" + code + "/notice/top"
        case .CommunityNoticeDetail_Total(let postId):
            return "community/notice/" + String(postId)
        case .CommunityNoticeDetail_Category(let code, let postId):
            return "community/" + code + "/notice/" + String(postId)
        case .MainCommunity_GuestCategory:
            return "community/guest/category"
        case .MainCommunity_GuestBoard:
            return "community/guest/post/popular"
        case .MainCommunity_UserCategory_Recog:
            return "community/category"
        case .MainCommunity_UserCategory_Popular:
            return "community/category/popular"
        case .MainCommunity_UserBoard:
            return "community/post/popular"
        case .CategoryFavoritePost:
            return "community/category/favorite"
        case .CategoryFavoriteDelete:
            return "community/category/favorite"
        case .MemberSearch:
            return "community/post/search"
        case .EachCategoryBoards(let code, _, _, _, _, _, _):
            return "community/" + code + "/post"
        case .CommunityCategory:
            return "api/fantoo2_dummy/main_community/category"
        case .CommunityNotice:
            return "api/fantoo2_dummy/main_community/notice"
        case .CommunityCategoryFantooMember:
            return "community/category"
        case .CommunityCategoryPopularMember:
            return "user/sns/join"
        case .CommunitySubcategoryMember:
            return "api/fantoo2_dummy/main_home/tab_home/v2"
        case .CommunityCategoryFantooNonmember:
            return "community/guest/category"
        case .CommunitySubcategoryNonmember:
            return "user/join/check"
        case .CommunityCategoryNotice:
            return "user/check/nickname"
        case .CommunityTopFive:
            return "api/fantoo2_dummy/main_community/topFive"
        case .CommunitySearch:
            return "api/fantoo2_dummy/main_community/topFive"
        case .CommunityMyBoard:
            return "api/fantoo2_dummy/main_community/topFive"
        case .CommunityMyComment:
            return "api/fantoo2_dummy/main_community/topFive"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Community_TopNotice:
            return .get
        case .Community_TopNoticeMore:
            return .get
        case .Community_TopNoticeCategory:
            return .get
        case .CommunityNoticeDetail_Total:
            return .get
        case .CommunityNoticeDetail_Category:
            return .get
        case .MainCommunity_GuestCategory:
            return .get
        case .MainCommunity_GuestBoard:
            return .get
        case .MainCommunity_UserCategory_Recog:
            return .get
        case .MainCommunity_UserCategory_Popular:
            return .get
        case .MainCommunity_UserBoard:
            return .get
        case .CategoryFavoritePost:
            return .post
        case .CategoryFavoriteDelete:
            return .delete
        case .MemberSearch:
            return .get
        case .EachCategoryBoards:
            return .get
        case .CommunityCategory:
            return .get
        case .CommunityNotice:
            return .get
        case .CommunityCategoryFantooMember:
            return .get
        case .CommunityCategoryPopularMember:
            return .get
        case .CommunitySubcategoryMember:
            return .get
        case .CommunityCategoryFantooNonmember:
            return .get
        case .CommunitySubcategoryNonmember:
            return .get
        case .CommunityCategoryNotice:
            return .get
        case .CommunityTopFive:
            return .get
        case .CommunitySearch:
            return .get
        case .CommunityMyBoard:
            return .get
        case .CommunityMyComment:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .Community_TopNotice:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .Community_TopNoticeMore(let nextId, let size):
            var params = defultParams
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .Community_TopNoticeCategory:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CommunityNoticeDetail_Total:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CommunityNoticeDetail_Category:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MainCommunity_GuestCategory:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MainCommunity_GuestBoard:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MainCommunity_UserCategory_Recog(let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MainCommunity_UserCategory_Popular(let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MainCommunity_UserBoard(let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CategoryFavoritePost(let code, let integUid, _):
            var params = defultParams
            params["code"] = code
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .CategoryFavoriteDelete(let code, let integUid, _):
            var params = defultParams
            params["code"] = code
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .MemberSearch(let integUid, let nextId, let search, let size, _):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = String(nextId)
            params["search"] = search
            params["size"] = String(size)
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .EachCategoryBoards(_, let globalYn, let integUid, let nextId, let size, let subCode, _):
            var params = defultParams
            
            if subCode == "All" {
                params["globalYn"] = String(globalYn)
                params["integUid"] = integUid
                params["nextId"] = String(nextId)
                params["size"] = String(size)
            } else {
                params["globalYn"] = String(globalYn)
                params["integUid"] = integUid
                params["nextId"] = String(nextId)
                params["size"] = String(size)
                params["subCode"] = subCode
            }
            
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CommunityCategory:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CommunityNotice:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CommunityCategoryFantooMember(let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CommunityCategoryPopularMember(let page, let pages):
            var params = defultParams
            params["page"] = String(page)
            params["pages"] = String(pages)
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        case .CommunitySubcategoryMember(let page, let pages):
            var params = defultParams
            params["page"] = String(page)
            params["pages"] = String(pages)
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CommunityCategoryFantooNonmember:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CommunitySubcategoryNonmember(let loginId, let loginType):
            var params = defultParams
            params["loginId"] = String(loginId)
            params["loginType"] = String(loginType)
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CommunityCategoryNotice(let nickname):
            var params = defultParams
            params["nickname"] = String(nickname)
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        
        case .CommunityTopFive:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CommunitySearch:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        
        case .CommunityMyBoard:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CommunityMyComment:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFucntion.defaultHeader()
        
        switch self {
        case .MainCommunity_UserCategory_Recog(_, let access_token):
            //header["Content-Type"] = "binary/octet-stream"
            //            header["Content-Type"] = "application/x-www-form-urlencoded"
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        case .MainCommunity_UserCategory_Popular(_, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        case .MainCommunity_UserBoard(_, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        case .CategoryFavoritePost(_, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        case .CategoryFavoriteDelete(_, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        case .MemberSearch(_, _, _, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        case .EachCategoryBoards(_, _, _, _, _, _, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        case .CommunityCategoryFantooMember(_, let access_token):
            header["Content-Type"] = "application/json"
            header["access_token"] = access_token
            return header
        default:
            //header["Content-Type"] = "binary/octet-stream"
            //            header["Content-Type"] = "application/x-www-form-urlencoded"
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

extension ApisCommunity {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisCommunity {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .Community_TopNotice:
            return [true, true]
        case .Community_TopNoticeMore:
            return [true, true]
        case .Community_TopNoticeCategory:
            return [true, true]
        case .CommunityNoticeDetail_Total:
            return [true, true]
        case .CommunityNoticeDetail_Category:
            return [true, true]
        case .MainCommunity_GuestCategory:
            return [true, true]
        case .MainCommunity_GuestBoard:
            return [true, true]
        case .MainCommunity_UserCategory_Recog:
            return [true, true]
        case .MainCommunity_UserCategory_Popular:
            return [true, true]
        case .MainCommunity_UserBoard:
            return [true, true]
        case .CategoryFavoritePost:
            return [true, true]
        case .CategoryFavoriteDelete:
            return [true, true]
        case .MemberSearch:
            return [true, true]
        case .EachCategoryBoards:
            return [true, true]
        case .CommunityCategory:
            return [true, true]
        case .CommunityNotice:
            return [true, true]
        case .CommunityCategoryFantooMember:
            return [true, true]
        case .CommunityCategoryPopularMember:
            return [true, true]
        case .CommunitySubcategoryMember:
            return [true, true]
        case .CommunityCategoryFantooNonmember:
            return [true, true]
        case .CommunitySubcategoryNonmember:
            return [true, true]
        case .CommunityCategoryNotice:
            return [true, true]
        case .CommunityTopFive:
            return [true, true]
        case .CommunitySearch:
            return [true, true]
        case .CommunityMyBoard:
            return [true, true]
        case .CommunityMyComment:
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
extension ApisCommunity {
    func isCheckToken() -> Bool {
        switch self {
        case .Community_TopNotice:
            return true
        case .Community_TopNoticeMore:
            return true
        case .Community_TopNoticeCategory:
            return true
        case .CommunityNoticeDetail_Total:
            return true
        case .CommunityNoticeDetail_Category:
            return true
        case .MainCommunity_GuestCategory:
            return true
        case .MainCommunity_GuestBoard:
            return true
        case .MainCommunity_UserCategory_Recog:
            return true
        case .MainCommunity_UserCategory_Popular:
            return true
        case .MainCommunity_UserBoard:
            return true
        case .CategoryFavoritePost:
            return true
        case .CategoryFavoriteDelete:
            return true
        case .MemberSearch:
            return true
        case .EachCategoryBoards:
            return true
        case .CommunityCategory:
            return true
        case .CommunityNotice:
            return true
        case .CommunityCategoryFantooMember:
            return true
        case .CommunityCategoryPopularMember:
            return true
        case .CommunitySubcategoryMember:
            return true
        case .CommunityCategoryFantooNonmember:
            return true
        case .CommunitySubcategoryNonmember:
            return true
        case .CommunityCategoryNotice:
            return true
        case .CommunityTopFive:
            return true
        case .CommunitySearch:
            return true
        case .CommunityMyBoard:
            return true
        case .CommunityMyComment:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisCommunity {
    func dataCachingTime() -> Int {
        switch self {
        case .Community_TopNotice:
            return DataCachingTime.None.rawValue
        case .Community_TopNoticeMore:
            return DataCachingTime.None.rawValue
        case .Community_TopNoticeCategory:
            return DataCachingTime.None.rawValue
        case .CommunityNoticeDetail_Total:
            return DataCachingTime.None.rawValue
        case .CommunityNoticeDetail_Category:
            return DataCachingTime.None.rawValue
        case .MainCommunity_GuestCategory:
            return DataCachingTime.None.rawValue
        case .MainCommunity_GuestBoard:
            return DataCachingTime.None.rawValue
        case .MainCommunity_UserCategory_Recog:
            return DataCachingTime.None.rawValue
        case .MainCommunity_UserCategory_Popular:
            return DataCachingTime.None.rawValue
        case .MainCommunity_UserBoard:
            return DataCachingTime.None.rawValue
        case .CategoryFavoritePost:
            return DataCachingTime.None.rawValue
        case .CategoryFavoriteDelete:
            return DataCachingTime.None.rawValue
        case .MemberSearch:
            return DataCachingTime.None.rawValue
        case .EachCategoryBoards:
            return DataCachingTime.None.rawValue
        case .CommunityCategory:
            return DataCachingTime.None.rawValue
        case .CommunityNotice:
            return DataCachingTime.None.rawValue
        case .CommunityCategoryFantooMember:
            return DataCachingTime.None.rawValue
        case .CommunityCategoryPopularMember:
            return DataCachingTime.None.rawValue
        case .CommunitySubcategoryMember:
            return DataCachingTime.None.rawValue
        case .CommunityCategoryFantooNonmember:
            return DataCachingTime.None.rawValue
        case .CommunitySubcategoryNonmember:
            return DataCachingTime.None.rawValue
        case .CommunityCategoryNotice:
            return DataCachingTime.None.rawValue
        case .CommunityTopFive:
            return DataCachingTime.None.rawValue
        case .CommunitySearch:
            return DataCachingTime.None.rawValue
        case .CommunityMyBoard:
            return DataCachingTime.None.rawValue
        case .CommunityMyComment:
            return DataCachingTime.None.rawValue
        }
    }
}
