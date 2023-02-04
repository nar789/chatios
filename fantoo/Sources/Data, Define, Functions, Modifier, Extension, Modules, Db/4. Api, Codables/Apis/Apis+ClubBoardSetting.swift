//
//  Apis+ClubBoardSetting.swift
//  fantoo
//
//  Created by fns on 2022/12/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisClubBoardSetting {
    case ClubBoardCategoryList(categoryCode: String, clubId: String, integUid: String)
    case CreateClubBoardList(categoryCode: String, clubId: String, boardType:Int, categoryName: String, integUid: String, openYn: Bool)
    case DeleteClubBoardList(categoryCode: String, clubId: String, integUid: String)
    case SettingClubBoardCategoryList(categoryCode: String, clubId: String, boardType:Int, categoryName: String, integUid: String, openYn: Bool)
    case ClubBoardListSortSetting(categoryCode: String, clubId: String, categoryNameList: [String], integUid: String)
    
}

extension ApisClubBoardSetting: Moya.TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .ClubBoardCategoryList(let categoryCode, let clubId, _):
            return "club/" + clubId + "/category/" + categoryCode
        case .CreateClubBoardList(let categoryCode, let clubId, _, _, _, _):
            return "club/" + clubId + "/setting/category/" + categoryCode
        case .DeleteClubBoardList(let categoryCode, let clubId, _):
            return "club/" + clubId + "/setting/category/" + categoryCode
        case .SettingClubBoardCategoryList(let categoryCode, let clubId, _, _, _, _):
            return "club/" + clubId + "/setting/category/" + categoryCode
        case .ClubBoardListSortSetting(let categoryCode, let clubId, _, _):
            return "club/" + clubId + "/setting/category/" + categoryCode + "/list/order"

            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .ClubBoardCategoryList:
            return .get
        case .CreateClubBoardList:
            return .post
        case .DeleteClubBoardList:
            return .delete
        case .SettingClubBoardCategoryList:
            return .patch
        case .ClubBoardListSortSetting:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .ClubBoardCategoryList(let categoryCode, let clubId, let integUid):
            var params = defultParams
            params["categoryCode"] = categoryCode
            params["clubId"] = clubId
            params["integUid"] = integUid
            
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CreateClubBoardList(let categoryCode, let clubId, let boardType, let categoryName, let integUid, let openYn):
            var params = defultParams
            params["categoryCode"] = categoryCode
            params["clubId"] = clubId
            params["boardType"] = boardType
            params["categoryName"] = categoryName
            params["integUid"] = integUid
            params["openYn"] = openYn
            
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .DeleteClubBoardList(let categoryCode, let clubId, let integUid):
            var params = defultParams
            params["categoryCode"] = categoryCode
            params["clubId"] = clubId
            params["integUid"] = integUid
            
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .SettingClubBoardCategoryList(let categoryCode, let clubId, let boardType, let categoryName, let integUid, let openYn):
            
            var params = defultParams
            params["categoryCode"] = categoryCode
            params["clubId"] = clubId
            params["boardType"] = boardType
            params["categoryName"] = categoryName
            params["integUid"] = integUid
            params["openYn"] = openYn
            
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubBoardListSortSetting(let categoryCode, let clubId, let categoryNameList, let integUid):
            
            var params = defultParams
            params["categoryCode"] = categoryCode
            params["clubId"] = clubId
            params["categoryNameList"] = categoryNameList
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

extension ApisClubBoardSetting {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisClubBoardSetting {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .ClubBoardCategoryList:
            return [true, true]
        case .CreateClubBoardList:
            return [true, true]
        case .DeleteClubBoardList:
            return [true, true]
        case .SettingClubBoardCategoryList:
            return [true, true]
        case .ClubBoardListSortSetting:
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
extension ApisClubBoardSetting {
    func isCheckToken() -> Bool {
        switch self {
        case .ClubBoardCategoryList:
            return true
        case .CreateClubBoardList:
            return true
        case .DeleteClubBoardList:
            return true
        case .SettingClubBoardCategoryList:
            return true
        case .ClubBoardListSortSetting:
            return true

        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisClubBoardSetting {
    func dataCachingTime() -> Int {
        switch self {
        case .ClubBoardCategoryList:
            return DataCachingTime.None.rawValue
        case .CreateClubBoardList:
            return DataCachingTime.None.rawValue
        case .DeleteClubBoardList:
            return DataCachingTime.None.rawValue
        case .SettingClubBoardCategoryList:
            return DataCachingTime.None.rawValue
        case .ClubBoardListSortSetting:
            return DataCachingTime.None.rawValue
        }
    }
}


