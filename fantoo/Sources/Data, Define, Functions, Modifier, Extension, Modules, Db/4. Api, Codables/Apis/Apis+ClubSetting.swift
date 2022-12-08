//
//  Apis+MyClub.swift
//  fantoo
//
//  Created by fns on 2022/10/04.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisClubSetting {
    case ClubBasic(clubId: String, integUid: String)
    
    case MyClub(integUid: String, nextId: String, size: String, sort: String)
    case MyClubBasic(integUid: String, nextId: String, size: String)
    case MyClubCount(integUid: String, sort: String)
    case MyClubFavorite(clubId: String, integUid: String)
    case MyClubFavoritePatch(clubId: String, integUid: String)
    case MyClubStorageCount(clubId: String, integUid: String)
    case ClubStorageCount(integUid: String)
    case ClubStorageReply(integUid: String, nextId: String, size: String)
    case ClubStorageBookmark(integUid: String, nextId: String, size: String)
    case ClubStoragePost(integUid: String, nextId: String, size: String)
    
    case ClubMemberList(clubId: String, integUid: String, nextId: String, size: String)
    case ClubMemberDetail(clubId: String, integUid: String, memberId: String)
    case ClubMemberFollow(clubId: String, integUid: String)
    case ClubMemberFollowPatch(clubId: String, checkToken: String, favoriteYn: Bool, integUid: String, nickname: String, profileImg: String)
    case ClubMemberWithdrwal(clubId: String, integUid: String, joinYn: Bool)
    case ClubMemberEdit(clubId: String, checkToken: String, integUid: String, nickname: String, profileImg: String)
    case ClubMemberNicknameCheck(clubId: String, nickname: String)
    case ClubMemberPostList(clubId: String, integUid: String, memberId: String, nextId: String, size: String)
    case ClubMemberReplyList(clubId: String, integUid: String, memberId: String, nextId: String, size: String)
    
    case ClubManage(clubId: String, integUid: String)
    
    case ClubJoinMemberList(clubId: String, integUid: String, nextId: String, size: String)
    case RequestClubJoinMember(clubId: String, checkToken: String, integUid: String, nickname: String, profileImg: String)
    case ClubJoinMemberApproval(clubId: String, integUid: String, joinIdList: [Int])
    case ClubJoinMemberRejection(clubId: String, integUid: String, joinIdList: [Int])
    case ClubMemberForceLeave(clubId: String, memberId: String, integUid: String, joinYn: Bool)
    case ClubMemberForceLeaveList(clubId: String, integUid: String, nextId: String, size: String)
    case ClubMemberForceLeaveListCount(clubId: String, integUid: String)
    case ClubMemberForceLeaveEdit(clubId: String, integUid: String, joinYn: Bool, withdrawId: String)
    case ClubMemberCount(clubId: String, integUid: String)
    case ClubDelegateRequest(clubId: String, memberId: String, integUid: String)
    case ClubDelegateMember(clubId: String, integUid: String)
    case ClubDelegateCancel(clubId: String, memberId: String, integUid: String)
    case ClubBlockMember(clubId: String, memberId: String, categoryCode: String, integUid: String)
    case ClubBlockCheck(clubId: String, memberId: String, integUid: String)
}

extension ApisClubSetting: Moya.TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .ClubBasic(let clubId, _):
            return "club/" + clubId + "/basic"
        case .MyClub:
            return "club/my"
        case .MyClubCount:
            return "club/my/count"
        case .MyClubBasic:
            return "club/my/basic"
        case .MyClubFavorite(let clubId, _):
            return "club/" + clubId + "/favorite"
        case .MyClubFavoritePatch(let clubId, _):
            return "club/" + clubId + "/favorite"
        case .MyClubStorageCount(let clubId, _):
            return "club/" + clubId + "/storage/count"
        case .ClubStorageCount:
            return "club/storage/count"
        case .ClubStorageReply:
            return "club/storage/reply"
        case .ClubStorageBookmark:
            return "club/storage/bookmark"
        case .ClubStoragePost:
            return "club/storage/post"
        case .ClubMemberList(let clubId, _, _, _):
            return "club/" + clubId + "/member"
        case .ClubMemberDetail(let clubId, _, let memberId):
            return "club/" + clubId + "/member/" + memberId
        case .ClubMemberFollow(let clubId, _):
            return "club/" + clubId + "/follow"
        case .ClubMemberFollowPatch(let clubId, _, _, _, _, _):
            return "club/" + clubId + "/follow"
        case .ClubMemberWithdrwal(let clubId, _, _):
            return "club/" + clubId + "/member/0"
        case .ClubMemberEdit(let clubId, _, _, _, _):
            return "club/" + clubId + "/member/0"
        case .ClubMemberNicknameCheck(let clubId, _):
            return "club/" + clubId + "/member/nickname"
        case .ClubMemberPostList(let clubId, _, let memberId, _, _):
            return "club/" + clubId + "/storage/member/" + memberId + "/post"
        case .ClubMemberReplyList(let clubId, _, let memberId, _, _):
            return "club/" + clubId + "/storage/member/" + memberId + "/reply"
        case .ClubManage(let clubId, _):
            return "club/" + clubId + "/manage"
        case .ClubJoinMemberList(let clubId, _, _, _):
            return "club/" + clubId + "/join/member"
        case .RequestClubJoinMember(let clubId, _, _, _, _):
            return "club/" + clubId + "/join/member"
        case .ClubJoinMemberApproval(let clubId, _, _):
            return "club/" + clubId + "/join/member/list/ok"
        case .ClubJoinMemberRejection(let clubId, _, _):
            return "club/" + clubId + "/join/member/list/no"
        case .ClubMemberForceLeave(let clubId, let memberId, _, _):
            return "club/" + clubId + "/withdraw/member/" + memberId
        case .ClubMemberForceLeaveList(let clubId, _, _, _):
            return "club/" + clubId + "/withdraw/member"
        case .ClubMemberForceLeaveListCount(let clubId, _):
            return "club/" + clubId + "/withdraw/member/count"
        case .ClubMemberForceLeaveEdit(let clubId, _, _, let withdrawId):
            return "club/" + clubId + "/withdraw/member/" + withdrawId 
        case .ClubMemberCount(let clubId, _):
            return "club/" + clubId + "/member/count"
        case .ClubDelegateRequest(let clubId, let memberId, _):
            return "club/" + clubId + "/delegate/member/" + memberId + "/request"
        case .ClubDelegateMember(let clubId, _):
            return "club/" + clubId + "/delegate/member"
        case .ClubDelegateCancel(let clubId, let memberId, _):
            return "club/" + clubId + "/delegate/member/" + memberId + "/cancel"
        case .ClubBlockMember(let clubId, let memberId, _, _):
            return "club/" + clubId + "/block/member/" + memberId
        case .ClubBlockCheck(let clubId, let memberId, _):
            return "club/" + clubId + "/block/member/" + memberId
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .ClubBasic:
            return .get
        case .MyClub:
            return .get
        case .MyClubCount:
            return .get
        case .MyClubBasic:
            return .get
        case .MyClubFavorite:
            return .get
        case .MyClubFavoritePatch:
            return .patch
        case .MyClubStorageCount:
            return .get
        case .ClubStorageCount:
            return .get
        case .ClubStorageReply:
            return .get
        case .ClubStorageBookmark:
            return .get
        case .ClubStoragePost:
            return .get
        case .ClubMemberList:
            return .get
        case .ClubMemberDetail:
            return .get
        case .ClubMemberFollow:
            return .get
        case .ClubMemberFollowPatch:
            return .patch
        case .ClubMemberWithdrwal:
            return .delete
        case .ClubMemberEdit:
            return .patch
        case .ClubMemberNicknameCheck:
            return .get
        case .ClubMemberPostList:
            return .get
        case .ClubMemberReplyList:
            return .get
        case .ClubManage:
            return .get
        case .ClubJoinMemberList:
            return .get
        case .RequestClubJoinMember:
            return .post
        case .ClubJoinMemberApproval:
            return .patch
        case .ClubJoinMemberRejection:
            return .delete
        case .ClubMemberForceLeave:
            return .post
        case .ClubMemberForceLeaveList:
            return .get
        case .ClubMemberForceLeaveListCount:
            return .get
        case .ClubMemberForceLeaveEdit:
            return .patch
        case .ClubMemberCount:
            return .get
        case .ClubDelegateRequest:
            return .patch
        case .ClubDelegateMember:
            return .get
        case .ClubDelegateCancel:
            return .patch
        case .ClubBlockMember:
            return .patch
        case .ClubBlockCheck:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .ClubBasic(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid

            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MyClub(let integUid, let nextId, let size, let sort):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            params["sort"] = sort
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MyClubCount(let integUid, let sort):
            var params = defultParams
            params["integUid"] = integUid
            params["sort"] = sort
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MyClubBasic(let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MyClubFavorite(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MyClubFavoritePatch(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .MyClubStorageCount(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
            
        case .ClubStorageCount(let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubStorageReply(let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubStorageBookmark(let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubStoragePost(let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubMemberList(_, let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
            
        case .ClubMemberDetail(_, let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubMemberFollow(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubMemberFollowPatch(_, let checkToken, let favoriteYn, let integUid, let nickname, let profileImg):
            var params = defultParams
            params["checkToken"] = checkToken
            params["favoriteYn"] = favoriteYn
            params["integUid"] = integUid
            params["nickname"] = nickname
            params["profileImg"] = profileImg
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubMemberWithdrwal(_, let integUid, let joinYn):
            var params = defultParams
            params["integUid"] = integUid
            params["joinYn"] = joinYn
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubMemberEdit(_, let checkToken, let integUid, let nickname, let profileImg):
            var params = defultParams
            params["integUid"] = integUid
            
            if checkToken.count > 0 {
                params["checkToken"] = checkToken
            }
            
            if nickname.count > 0 {
                params["nickname"] = nickname
            }
            
            if profileImg.count > 0 {
                params["profileImg"] = profileImg
            }
            
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubMemberNicknameCheck(_, let nickname):
            var params = defultParams
            params["nickname"] = nickname
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubMemberPostList(_, let integUid, _, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubMemberReplyList(_, let integUid, _, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubManage(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubJoinMemberList(_, let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .RequestClubJoinMember(_, let checkToken, let integUid, let nickname, let profileImg):
            var params = defultParams
            params["checkToken"] = checkToken
            params["integUid"] = integUid
            params["nickname"] = nickname
            params["profileImg"] = profileImg
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubJoinMemberApproval(_, let integUid, let joinIdList):
            var params = defultParams
            params["integUid"] = integUid
            params["joinIdList"] = joinIdList
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubJoinMemberRejection(_, let integUid, let joinIdList):
            var params = defultParams
            params["integUid"] = integUid
            params["joinIdList"] = joinIdList
            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubMemberForceLeave(_, _, let integUid, let joinYn):
            var params = defultParams
            params["integUid"] = integUid
            params["joinYn"] = joinYn
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubMemberForceLeaveList(_, let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubMemberForceLeaveListCount(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid

            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubMemberForceLeaveEdit(_, let integUid, let joinYn, _):
            var params = defultParams
            params["integUid"] = integUid
            params["joinYn"] = joinYn

            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubMemberCount(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubDelegateRequest(_, _, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubDelegateMember(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubDelegateCancel(_, _, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubBlockMember(_, _, let categoryCode, let integUid):
            var params = defultParams
            params["categoryCode"] = categoryCode
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case .ClubBlockCheck(_, _, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFucntion.defaultHeader()
        
        switch self {
        case .MyClub(_,_,_,_):
            header["Content-Type"] = "application/json"
        case .MyClubBasic(_,_,_):
            header["Content-Type"] = "application/json"
            
        default:
            header["Content-Type"] = "application/json"
            header["access_token"] = UserManager.shared.accessToken
            //header["Content-Type"] = "binary/octet-stream"
            //            header["Content-Type"] = "application/x-www-form-urlencoded"
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

extension ApisClubSetting {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisClubSetting {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .ClubBasic:
            return [true, true]
        case .MyClub:
            return [true, true]
        case .MyClubCount:
            return [true, true]
        case .MyClubBasic:
            return [true, true]
        case .MyClubFavorite:
            return [true, true]
        case .MyClubFavoritePatch:
            return [true, true]
        case .MyClubStorageCount:
            return [true, true]
        case .ClubStorageCount:
            return [true, true]
        case .ClubStorageReply:
            return [true, true]
        case .ClubStorageBookmark:
            return [true, true]
        case .ClubStoragePost:
            return [true, true]
        case .ClubMemberList:
            return [true, true]
        case .ClubMemberDetail:
            return [true, true]
        case .ClubMemberFollow:
            return [true, true]
        case .ClubMemberFollowPatch:
            return [true, true]
        case .ClubMemberWithdrwal:
            return [true, true]
        case .ClubMemberEdit:
            return [true, true]
        case .ClubMemberNicknameCheck:
            return [true, true]
        case .ClubMemberPostList:
            return [true, true]
        case .ClubMemberReplyList:
            return [true, true]
        case .ClubManage:
            return [true, true]
        case .ClubJoinMemberList:
            return [true, true]
        case .RequestClubJoinMember:
            return [true, true]
        case .ClubJoinMemberApproval:
            return [true, true]
        case .ClubJoinMemberRejection:
            return [true, true]
        case .ClubMemberForceLeave:
            return [true, true]
        case .ClubMemberForceLeaveList:
            return [true, true]
        case .ClubMemberForceLeaveListCount:
            return [true, true]
        case .ClubMemberForceLeaveEdit:
            return [true, true]
        case .ClubMemberCount:
            return [true, true]
        case .ClubDelegateRequest:
            return [true, true]
        case .ClubDelegateMember:
            return [true, true]
        case .ClubDelegateCancel:
            return [true, true]
        case .ClubBlockMember:
            return [true, true]
        case .ClubBlockCheck:
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
extension ApisClubSetting {
    func isCheckToken() -> Bool {
        switch self {
        case .ClubBasic:
            return true
        case .MyClub:
            return true
        case .MyClubCount:
            return true
        case .MyClubBasic:
            return true
        case .MyClubFavorite:
            return true
        case .MyClubFavoritePatch:
            return true
        case .MyClubStorageCount:
            return true
        case .ClubStorageCount:
            return true
        case .ClubStorageReply:
            return true
        case .ClubStorageBookmark:
            return true
        case .ClubStoragePost:
            return true
        case .ClubMemberList:
            return true
        case .ClubMemberDetail:
            return true
        case .ClubMemberFollow:
            return true
        case .ClubMemberFollowPatch:
            return true
        case .ClubMemberWithdrwal:
            return true
        case .ClubMemberEdit:
            return true
        case .ClubMemberNicknameCheck:
            return true
        case .ClubMemberPostList:
            return true
        case .ClubMemberReplyList:
            return true
        case .ClubManage:
            return true
        case .ClubJoinMemberList:
            return true
        case .RequestClubJoinMember:
            return true
        case .ClubJoinMemberApproval:
            return true
        case .ClubJoinMemberRejection:
            return true
        case .ClubMemberForceLeave:
            return true
        case .ClubMemberForceLeaveList:
            return true
        case .ClubMemberForceLeaveListCount:
            return true
        case .ClubMemberForceLeaveEdit:
            return true
        case .ClubMemberCount:
            return true
        case .ClubDelegateRequest:
            return true
        case .ClubDelegateMember:
            return true
        case .ClubDelegateCancel:
            return true
        case .ClubBlockMember:
            return true
        case .ClubBlockCheck:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisClubSetting {
    func dataCachingTime() -> Int {
        switch self {
        case .ClubBasic:
            return DataCachingTime.None.rawValue
        case .MyClub:
            return DataCachingTime.None.rawValue
        case .MyClubCount:
            return DataCachingTime.None.rawValue
        case .MyClubBasic:
            return DataCachingTime.None.rawValue
        case .MyClubFavorite:
            return DataCachingTime.None.rawValue
        case .MyClubFavoritePatch:
            return DataCachingTime.None.rawValue
        case .MyClubStorageCount:
            return DataCachingTime.None.rawValue
        case .ClubStorageCount:
            return DataCachingTime.None.rawValue
        case .ClubStorageReply:
            return DataCachingTime.None.rawValue
        case .ClubStorageBookmark:
            return DataCachingTime.None.rawValue
        case .ClubStoragePost:
            return DataCachingTime.None.rawValue
        case .ClubMemberList:
            return DataCachingTime.None.rawValue
        case .ClubMemberDetail:
            return DataCachingTime.None.rawValue
        case .ClubMemberFollow:
            return DataCachingTime.None.rawValue
        case .ClubMemberFollowPatch:
            return DataCachingTime.None.rawValue
        case .ClubMemberWithdrwal:
            return DataCachingTime.None.rawValue
        case .ClubMemberEdit:
            return DataCachingTime.None.rawValue
        case .ClubMemberNicknameCheck:
            return DataCachingTime.None.rawValue
        case .ClubMemberPostList:
            return DataCachingTime.None.rawValue
        case .ClubMemberReplyList:
            return DataCachingTime.None.rawValue
        case .ClubManage:
            return DataCachingTime.None.rawValue
        case .ClubJoinMemberList:
            return DataCachingTime.None.rawValue
        case .RequestClubJoinMember:
            return DataCachingTime.None.rawValue
        case .ClubJoinMemberApproval:
            return DataCachingTime.None.rawValue
        case .ClubJoinMemberRejection:
            return DataCachingTime.None.rawValue
        case .ClubMemberForceLeave:
            return DataCachingTime.None.rawValue
        case .ClubMemberForceLeaveList:
            return DataCachingTime.None.rawValue
        case .ClubMemberForceLeaveListCount:
            return DataCachingTime.None.rawValue
        case .ClubMemberForceLeaveEdit:
            return DataCachingTime.None.rawValue
        case .ClubMemberCount:
            return DataCachingTime.None.rawValue
        case .ClubDelegateRequest:
            return DataCachingTime.None.rawValue
        case .ClubDelegateMember:
            return DataCachingTime.None.rawValue
        case .ClubDelegateCancel:
            return DataCachingTime.None.rawValue
        case .ClubBlockMember:
            return DataCachingTime.None.rawValue
        case .ClubBlockCheck:
            return DataCachingTime.None.rawValue
        }
    }
}
