


import Moya
import Foundation
import Alamofire



enum ApisChatFollow {
    
    case follow(accessToken:String, targetUid:String)
    case unfollow(accessToken:String, targetUid:String)
    

}


extension ApisChatFollow: Moya.TargetType {
    
    
    var baseURL: URL {
        switch self {
        case .follow:
            return URL(string: "https://fapi.fantoo.co.kr:9121")!
        case .unfollow:
            return URL(string: "https://fapi.fantoo.co.kr:9121")!
        }
    }
    
    var path: String {
        switch self {
        case .follow:
            return "chat/follow"
        case .unfollow:
            return "chat/follow"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .follow:
            return .post
        case .unfollow:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .follow(_, let integUid):
            var params = defaultParams
            params["integUid"] = UserManager.shared.uid
            params["targetIntegUid"] = integUid
           
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .unfollow(_, let integUid):
            var params = defaultParams
            params["integUid"] = UserManager.shared.uid
            params["targetIntegUid"] = integUid
           
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
        case .follow(let accessToken, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = accessToken
        case .unfollow(let accessToken,_):
            header["Content-Type"] = "application/json"
            header["access_token"] = accessToken
        }
        return header
    }
    
    var defaultParams: [String : Any] {
        let params: [String: Any] = [:]
        return params
    }
    
    func log(params: [String: Any]) {
        print("\n--- API : \(baseURL)/\(path) -----------------------------------------------------------\n\(params)\n------------------------------------------------------------------------------------------------------------------------------\n")
    }
    
}

