//
//  Apis+Alert.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisAlertPage {
    case HomeTabNavi
}

extension ApisAlertPage: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .HomeTabNavi:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        }
    }
    
    var path: String {
        switch self {
        case .HomeTabNavi:
            return "api/fantoo2_dummy/alert"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .HomeTabNavi:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .HomeTabNavi:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
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

extension ApisAlertPage {
    var cacheTime: NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}

//MARK: - Log On/Off
extension ApisAlertPage {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .HomeTabNavi:
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
extension ApisAlertPage {
    func isCheckToken() -> Bool {
        switch self {
        case .HomeTabNavi:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisAlertPage {
    func dataCachingTime() -> Int {
        switch self {
        case .HomeTabNavi:
            return DataCachingTime.None.rawValue
        }
    }
}
