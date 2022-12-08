//
//  Apis+HomeClubCreating.swift
//  fantoo
//
//  Created by fns on 2022/11/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisHomeClubCreating {
    case CreatingClubNameCheck(clubName: String)
    case CreatingClub(activeCountryCode: String, bgImg: String, checkToken: String, clubName: String, integUid: String, interestCategoryId: Int, languageCode: String, memberJoinAutoYn: Bool, openYn: Bool, profileImg: String)
    case ClubInterestList
}

extension ApisHomeClubCreating: Moya.TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .CreatingClubNameCheck:
            return "club/name"
        case .CreatingClub:
            return "club"
        case .ClubInterestList:
            return "club/interest"
            
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .CreatingClubNameCheck:
            return .get
        case .CreatingClub:
            return .post
        case .ClubInterestList:
            return .get
            
        }
    }
    
    var task: Task {
        switch self {
        case .CreatingClubNameCheck(let clubName):
            var params = defultParams
            params["clubName"] = clubName
            
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CreatingClub(let activeCountryCode, let bgImg, let checkToken, let clubName, let integUid, let interestCategoryId, let languageCode, let memberJoinAutoYn, let openYn, let profileImg):
            var params = defultParams
            params["activeCountryCode"] = activeCountryCode
            
            if bgImg.count > 0 {
                params["bgImg"] = bgImg
            }
            params["checkToken"] = checkToken
            params["clubName"] = clubName
            params["integUid"] = integUid
            params["interestCategoryId"] = interestCategoryId
            params["languageCode"] = languageCode
            params["memberJoinAutoYn"] = memberJoinAutoYn
            params["openYn"] = openYn
            
            if profileImg.count > 0 {
                params["profileImg"] = profileImg
            }
            
            
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default) // content-Type은 자동으로 'application/json'형식으로 변경된다.
            
        case .ClubInterestList:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
            
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFucntion.defaultHeader()
        
        switch self {
            
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

extension ApisHomeClubCreating {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisHomeClubCreating {
    func isAlLogOn() -> Bool {
        return true
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .CreatingClubNameCheck:
            return [true, true]
        case .CreatingClub:
            return [true, true]
        case .ClubInterestList:
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
extension ApisHomeClubCreating {
    func isCheckToken() -> Bool {
        switch self {
        case .CreatingClubNameCheck:
            return true
        case .CreatingClub:
            return true
        case .ClubInterestList:
            return true
            
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisHomeClubCreating {
    func dataCachingTime() -> Int {
        switch self {
        case .CreatingClubNameCheck:
            return DataCachingTime.None.rawValue
        case .CreatingClub:
            return DataCachingTime.None.rawValue
        case .ClubInterestList:
            return DataCachingTime.None.rawValue
            
        }
    }
}
