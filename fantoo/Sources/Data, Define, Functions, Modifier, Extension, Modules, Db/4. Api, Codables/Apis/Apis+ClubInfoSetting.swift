//
//  Apis+ClubInfoSetting.swift
//  fantoo
//
//  Created by fns on 2022/10/24.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisClubInfoSetting {
    case ClubCategoryList(clubId: String, integUid: String)
    case ClubFullInfo(clubId: String, integUid: String)
    case ClubInfoEdit(clubId: String, activeCountryCode: String, bgImg: String, checkToken: String, clubName: String, integUid: String, interestCategoryId: Int, introduction: String, languageCode: String, memberCountOpenYn: Bool, memberJoinAutoYn: Bool, memberListOpenYn: Bool, openYn: Bool, profileImg: String)
    case ClubNameCheck(clubName: String)
    case ClubHashtag(clubId: String, integUid: String)
    case ClubAddHashtag(clubId: String, hashtagList: [String], integUid: String)

    
}

extension ApisClubInfoSetting: Moya.TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .ClubCategoryList(let clubId, _):
            return "club/" + clubId + "/setting/category"
        case .ClubFullInfo(let clubId, _):
            return "club/" + clubId
        case .ClubInfoEdit(let clubId, _, _, _, _, _, _, _, _, _, _, _, _, _):
            return "club/" + clubId
        case .ClubNameCheck:
            return "/club/name"
        case .ClubHashtag(let clubId, _):
            return "club/" + clubId + "/hashtag"
        case .ClubAddHashtag(let clubId, _, _):
            return "club/" + clubId + "/hashtag"
            
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .ClubCategoryList:
            return .get
        case .ClubFullInfo:
            return .get
        case .ClubInfoEdit:
            return .patch
        case .ClubNameCheck:
            return .get
        case .ClubHashtag:
            return .get
        case .ClubAddHashtag:
            return .post
            
        }
        
    }
    
    var task: Task {
        switch self {
        case .ClubCategoryList(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubFullInfo(_, let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubInfoEdit(_, let activeCountryCode, let bgImg, let checkToken, let clubName, let integUid, let interestCategoryId, let introduction, let languageCode, let memberCountOpenYn, let memberJoinAutoYn, let memberListOpenYn, let openYn, let profileImg):
            var params = defultParams
            if integUid.count > 0 {
                params["integUid"] = integUid
            }
            if activeCountryCode.count > 0 {
                params["activeCountryCode"] = activeCountryCode
            }
            if bgImg.count > 0 {
                params["bgImg"] = bgImg
            }
            if checkToken.count > 0 {
                params["checkToken"] = checkToken
            }
            if clubName.count > 0 {
                params["clubName"] = clubName
            }
            if interestCategoryId > 0 {
                params["interestCategoryId"] = interestCategoryId
            }
            if introduction.count > 0 {
                params["introduction"] = introduction
            }
            if languageCode.count > 0 {
                params["languageCode"] = languageCode
            }
            params["memberCountOpenYn"] = memberCountOpenYn
            params["memberJoinAutoYn"] = memberJoinAutoYn
            params["memberListOpenYn"] = memberListOpenYn
            params["openYn"] = openYn
            if profileImg.count > 0 {
                params["profileImg"] = profileImg
            }
            
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubNameCheck(let clubName):
            var params = defultParams
            params["clubName"] = clubName
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubHashtag(_, let integUid):
            var params = defultParams
            params["integuid"] = integUid
            //요거 u 대문자로 바꿔 달라고 해야하는지...
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ClubAddHashtag(_, let hashtagList, let integUid):
            var params = defultParams
            params["hashtagList"] = hashtagList
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()

        switch self {
        default:
            header["Content-Type"] = "application/json"
            header["access_token"] = UserManager.shared.accessToken
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

extension ApisClubInfoSetting {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisClubInfoSetting {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .ClubCategoryList:
            return [true, true]
        case .ClubFullInfo:
            return [true, true]
        case .ClubInfoEdit:
            return [true, true]
        case .ClubNameCheck:
            return [true, true]
        case .ClubHashtag:
            return [true, true]
        case .ClubAddHashtag:
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
extension ApisClubInfoSetting {
    func isCheckToken() -> Bool {
        switch self {
        case .ClubCategoryList:
            return true
        case .ClubFullInfo:
            return true
        case .ClubInfoEdit:
            return true
        case .ClubNameCheck:
            return true
        case .ClubHashtag:
            return true
        case .ClubAddHashtag:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisClubInfoSetting {
    func dataCachingTime() -> Int {
        switch self {
        case .ClubCategoryList:
            return DataCachingTime.None.rawValue
        case .ClubFullInfo:
            return DataCachingTime.None.rawValue
        case .ClubInfoEdit:
            return DataCachingTime.None.rawValue
        case .ClubNameCheck:
            return DataCachingTime.None.rawValue
        case .ClubHashtag:
            return DataCachingTime.None.rawValue
        case .ClubAddHashtag:
            return DataCachingTime.None.rawValue


        }
    }
}


