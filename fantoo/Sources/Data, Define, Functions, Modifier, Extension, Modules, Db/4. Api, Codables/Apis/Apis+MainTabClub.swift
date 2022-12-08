//
//  Apis+MainTabClub.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisMainClub {
    case MainPage
    case MyPage
}

extension ApisMainClub: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .MainPage:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .MyPage:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        }
    }
    
    var path: String {
        switch self {
        case .MainPage:
            return "api/fantoo2_dummy/main_club/main_page"
        case .MyPage:
            return "api/fantoo2_dummy/main_club/main_page"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .MainPage:
            return .get
        case .MyPage:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .MainPage:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .MyPage:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFucntion.defaultHeader()
        
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

extension ApisMainClub {
    var cacheTime: NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}

//MARK: - Log On/Off
extension ApisMainClub {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .MainPage:
            return [true, true]
        case .MyPage:
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
extension ApisMainClub {
    func isCheckToken() -> Bool {
        switch self {
        case .MainPage:
            return true
        case .MyPage:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisMainClub {
    func dataCachingTime() -> Int {
        switch self {
        case .MainPage:
            return DataCachingTime.None.rawValue
        case .MyPage:
            return DataCachingTime.None.rawValue
        }
    }
}
