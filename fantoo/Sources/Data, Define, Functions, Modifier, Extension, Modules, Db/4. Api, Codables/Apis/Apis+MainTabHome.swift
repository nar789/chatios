//
//  asdf.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Moya
import Foundation
import Alamofire

enum ApisHome {
    case MainTabHome_Home(page: Int=1, pages: Int=10)
    case MainTabHome_Popular(page: Int=1, pages: Int=10)
}

extension ApisHome: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .MainTabHome_Home:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!    // 임시. 도메인주소 변경 예정
        case .MainTabHome_Popular:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!    // 임시. 도메인주소 변경 예정
        }
    }
    
    var path: String {
        switch self {
        case .MainTabHome_Home:
            return "api/fantoo2_dummy/main_home/tab_home/v2"   // 임시. 도메인주소 변경 예정
        case .MainTabHome_Popular:
            return "api//fantoo2_dummy/main_home/tab_popular"   // 임시. 도메인주소 변경 예정
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .MainTabHome_Home:
            return .get
        case .MainTabHome_Popular:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .MainTabHome_Home(let page, let pages):
            var params = defultParams
            params["page"] = String(page)
            params["pages"] = String(pages)
            
            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MainTabHome_Popular(let page, let pages):
            var params = defultParams
            params["page"] = String(page)
            params["pages"] = String(pages)
            
            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
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
        if self.isApiLogOn() {
            print("\n--- API : \(baseURL)/\(path) -----------------------------------------------------------\n\(params)\n------------------------------------------------------------------------------------------------------------------------------\n")
        }
    }
}

extension ApisHome {
    var cacheTime:NSInteger {
        var time = 0
        switch self {
        default: time = 15
        }
        
        return time
    }
}


//MARK: - Log On/Off
extension ApisHome {
    func isAlLogOn() -> Bool {
        return false
    }
    
    func isLogOn() -> [Bool] {
        switch self {
        case .MainTabHome_Home:
            return [true, true]
        case .MainTabHome_Popular:
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
extension ApisHome {
    func isCheckToken() -> Bool {
        switch self {
        case .MainTabHome_Home:
            return true
        case .MainTabHome_Popular:
            return true
        }
    }
}


//MARK: - Caching Time : Seconds
extension ApisHome {
    func dataCachingTime() -> Int {
        switch self {
        case .MainTabHome_Home:
            return DataCachingTime.None.rawValue
        case .MainTabHome_Popular:
            return DataCachingTime.None.rawValue
        }
    }
}
