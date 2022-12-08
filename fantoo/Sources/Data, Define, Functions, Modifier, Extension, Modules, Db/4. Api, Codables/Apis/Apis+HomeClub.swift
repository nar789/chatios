//
//  Apis+HomeClub.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisHomeClub {
    case TabHome
    case TabFreeBoard
    case TabArchive
    case TabBank
}

extension ApisHomeClub: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .TabHome:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .TabFreeBoard:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .TabArchive:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        case .TabBank:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!
        }
    }
    
    var path: String {
        switch self {
        case .TabHome:
            return "api/fantoo2_dummy/home_club/tab_home"
        case .TabFreeBoard:
            return "api/fantoo2_dummy/home_club/tab_freeboard"
        case .TabArchive:
            return "api/fantoo2_dummy/home_club/tab_archive"
        case .TabBank:
            return "api/fantoo2_dummy/home_club/tab_bank"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .TabHome:
            return .get
        case .TabFreeBoard:
            return .get
        case .TabArchive:
            return .get
        case .TabBank:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .TabHome:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .TabFreeBoard:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .TabArchive:
            let params = defaultParams
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .TabBank:
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

extension ApisHomeClub {
    var cacheTime: NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}

//MARK: - Log On/Off
extension ApisHomeClub {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .TabHome:
            return [true, true]
        case .TabFreeBoard:
            return [true, true]
        case .TabArchive:
            return [true, true]
        case .TabBank:
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
extension ApisHomeClub {
    func isCheckToken() -> Bool {
        switch self {
        case .TabHome:
            return true
        case .TabFreeBoard:
            return true
        case .TabArchive:
            return true
        case .TabBank:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisHomeClub {
    func dataCachingTime() -> Int {
        switch self {
        case .TabHome:
            return DataCachingTime.None.rawValue
        case .TabFreeBoard:
            return DataCachingTime.None.rawValue
        case .TabArchive:
            return DataCachingTime.None.rawValue
        case .TabBank:
            return DataCachingTime.None.rawValue
        }
    }
}
