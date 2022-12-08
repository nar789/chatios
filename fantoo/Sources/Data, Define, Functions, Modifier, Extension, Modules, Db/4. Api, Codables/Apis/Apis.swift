//
//  Apis.swift
//  fantooTests
//
//  Created by mkapps on 2022/04/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum Apis {
    case Config
    case Trans(language: String, messages: [TransMessagesReq])
}

extension Apis: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .Config:
            return URL(string: "http://api.fantoo.co.kr:3000")!
        case .Trans:
            return URL(string: DefineUrl.Domain.Trans)!
        }
    }
    
    var path: String {
        switch self {
        case .Config:
            return "api/native/config/ios_real"
        case .Trans:
            return "trans"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Config:
            return .get
        case .Trans:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .Config:
            let params = defultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .Trans(let language, let messages):
//            var params = defultParams
//            params["language"] = language
//            params["messages"] = messages
//            log(params: params)
//            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
            var messageParams = Array<Any>()

            for trans in messages {
                let obj = [
                    "origin" : trans.origin,
                    "text" : trans.text
                ]

                messageParams.append(obj)
            }

            var params = defultParams
            params["language"] = [language]
            params["messages"] = messageParams

            //print("trans parameters json string : \(params.toString()!)")

            log(params: params)

            return .requestParameters(parameters: params.toString()!.convertToDictionary()!, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFucntion.defaultHeader()
        
        switch self {
            
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
        print("\n--- API : \(baseURL)/\(path) -----------------------------------------------------------\n\(params)\n------------------------------------------------------------------------------------------------------------------------------\n")
    }
}

extension Apis {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}



//MARK: - Log On/Off
extension Apis {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .Config:
            return [true, true]
        case .Trans:
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
extension Apis {
    func isCheckToken() -> Bool {
        switch self {
        case .Config:
            return true
        case .Trans:
            return false
        }
    }
}


//MARK: - Caching Time : Seconds
extension Apis {
    func dataCachingTime() -> Int {
        switch self {
        case .Config:
            return DataCachingTime.None.rawValue
        case .Trans:
            return DataCachingTime.None.rawValue
        }
    }
}
