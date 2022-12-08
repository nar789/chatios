//
//  Apis+Settings.swift
//  fantoo
//
//  Created by mkapps on 2022/07/05.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisSettings {
    case LanguageList
    case CountryList
    case CountryIsoTwoList(IsoCode: String)
    case Trans(messages: [Trans], lang: String)
    case Alim(integUid: String)
    case ComAlimSetting(alimType: String, integUid: String)
    case ClubAlimSetting(alimType: String, integUid: String, clubId: String)
    case NoticeList(integUid: String, nextId: Int, size: Int)
    case NoticeListDetail(integUid: String, noticeId: String)
}

extension ApisSettings: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .Trans:
            return URL(string: DefineUrl.Domain.Trans)!
        default:
            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .LanguageList:
            return "lang/all"
        case .CountryList:
            return "country/select/all"
        case .CountryIsoTwoList:
            return "country/select/iso2"
        case .Trans:
            return "trans"
        case .Alim:
            return "user/alim"
        case .ComAlimSetting:
            return "user/alim"
        case .ClubAlimSetting:
            return "user/alim"
        case .NoticeList:
            return "user/fantoo/notice"
        case .NoticeListDetail(_, let noticeId):
            return "user/fantoo/notice/" + noticeId
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .LanguageList:
            return .get
        case .CountryList:
            return .get
        case .CountryIsoTwoList:
            return .get
        case .Trans:
            return .post
        case .Alim:
            return .get
        case .ComAlimSetting:
            return .patch
        case .ClubAlimSetting:
            return .patch
        case .NoticeList:
            return .get
        case .NoticeListDetail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .LanguageList:
            let params = defultParams
            
            //log
            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CountryList:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .CountryIsoTwoList(let IsoCode):
            var params = defultParams
            params["iso2"] = IsoCode
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .Trans(let messages, let lang):
            var messageParams = Array<Any>()
            
            for trans in messages {
                let obj = [
                    "id" : trans.id,
                    "text" : trans.message,
                    "user" : ""
                ]
                
                messageParams.append(obj)
            }
            
            var params = defultParams
            params["language"] = [lang]
            params["messages"] = messageParams
            
            print("trans parameters json string : \(params.toString()!)")
        
            log(params: params)
        
            return .requestParameters(parameters: params.toString()!.convertToDictionary()!, encoding: JSONEncoding.default)
            
        case .Alim(let integUid):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .ComAlimSetting(let alimType, let integUid):
            var params = defultParams
            params["alimType"] = alimType
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .ClubAlimSetting(let alimType, let integUid, let clubId):
            var params = defultParams
            params["alimType"] = alimType
            params["integUid"] = integUid
            log(params: params)
            return .requestCompositeParameters(bodyParameters: params, bodyEncoding: JSONEncoding.default, urlParameters: ["clubId": clubId])

            
        case .NoticeList(let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .NoticeListDetail(let integUid, _):
            var params = defultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        }
    }
    
    var headers: [String : String]? {
        var header = CommonFucntion.defaultHeader()
        
        switch self {
            
        case .Alim(_):
            header["Content-Type"] = "application/json"
            header["access_token"] = UserManager.shared.accessToken
            
        case .ComAlimSetting(_, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = UserManager.shared.accessToken
            
        case .ClubAlimSetting(_, _, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = UserManager.shared.accessToken
            
        case .NoticeList(_, _, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = UserManager.shared.accessToken
            
        case .NoticeListDetail(_, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = UserManager.shared.accessToken
            
            
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

extension ApisSettings {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisSettings {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .LanguageList:
            return [true, true]
        case .CountryList:
            return [true, true]
        case .CountryIsoTwoList:
            return [true, true]
        case .Trans:
            return [true, true]
        case .Alim:
            return [true, true]
        case .ComAlimSetting:
            return [true, true]
        case .ClubAlimSetting:
            return [true, true]
        case .NoticeList:
            return [true, true]
        case .NoticeListDetail:
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
extension ApisSettings {
    func isCheckToken() -> Bool {
        switch self {
        case .LanguageList:
            return true
        case .CountryList:
            return true
        case .CountryIsoTwoList:
            return true
        case .Trans:
            return true
        case .Alim:
            return true
        case .ComAlimSetting:
            return true
        case .ClubAlimSetting:
            return true
        case .NoticeList:
            return true
        case .NoticeListDetail:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisSettings {
    func dataCachingTime() -> Int {
        switch self {
        case .LanguageList:
            return DataCachingTime.None.rawValue
        case .CountryList:
            return DataCachingTime.None.rawValue
        case .CountryIsoTwoList:
            return DataCachingTime.None.rawValue
        case .Trans:
            return DataCachingTime.None.rawValue
        case .Alim:
            return DataCachingTime.None.rawValue
        case .ComAlimSetting:
            return DataCachingTime.None.rawValue
        case .ClubAlimSetting:
            return DataCachingTime.None.rawValue
        case .NoticeList:
            return DataCachingTime.None.rawValue
        case .NoticeListDetail:
            return DataCachingTime.None.rawValue
        }
    }
}
