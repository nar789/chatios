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
    
    
    case MainTabHome_PopularTrending(size: Int)
    case MainHome_Home(integUid: String, nextId: String, size: Int)
    case MainHome_Popular(integUid: String, nextId: String, size: Int)

    
}

extension ApisHome: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .MainTabHome_Home:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!    // 임시. 도메인주소 변경 예정
        case .MainTabHome_Popular:
            return URL(string: "http://devadmin.fantoo.co.kr:5000")!    // 임시. 도메인주소 변경 예정
            
            
        case .MainTabHome_PopularTrending:
            return URL(string: DefineUrl.Domain.Api)!
        case .MainHome_Home:
            return URL(string: DefineUrl.Domain.Api)!
        case .MainHome_Popular:
            return URL(string: DefineUrl.Domain.Api)!

            
            
//        default:
//            return URL(string: DefineUrl.Domain.Api)!
        }
    }
    
    var path: String {
        switch self {
        case .MainTabHome_Home:
            return "api/fantoo2_dummy/main_home/tab_home/v2"   // 임시. 도메인주소 변경 예정
        case .MainTabHome_Popular:
            return "api//fantoo2_dummy/main_home/tab_popular"   // 임시. 도메인주소 변경 예정
            
            
        case .MainTabHome_PopularTrending:
            return "/main/popular/trending/search"
        case .MainHome_Home:
            return "/main/home"
        case .MainHome_Popular:
            return "/main/popular"
            
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .MainTabHome_Home:
            return .get
        case .MainTabHome_Popular:
            return .get
        case .MainTabHome_PopularTrending:
            return .get
        case .MainHome_Home:
            return .get
        case .MainHome_Popular:
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
            
            
        case .MainTabHome_PopularTrending(let size):
            var params = defultParams
            params["size"] = size
            
            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MainHome_Home(let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .MainHome_Popular(let integUid, let nextId, let size):
            var params = defultParams
            params["integUid"] = integUid
            params["nextId"] = nextId
            params["size"] = size

            log(params: params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
        default:
            //header["Content-Type"] = "binary/octet-stream"
            //            header["Content-Type"] = "application/x-www-form-urlencoded"
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
        case .MainTabHome_PopularTrending:
            return [true, true]
        case .MainHome_Home:
            return [true, true]
        case .MainHome_Popular:
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
        case .MainTabHome_PopularTrending:
            return true
        case .MainHome_Home:
            return true
        case .MainHome_Popular:
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
        case .MainTabHome_PopularTrending:
            return DataCachingTime.None.rawValue
        case .MainHome_Home:
            return DataCachingTime.None.rawValue
        case .MainHome_Popular:
            return DataCachingTime.None.rawValue
        }
    }
}
