


import Moya
import Foundation
import Alamofire

enum ApisChatUserInfo {
    case GetUserInfo(accessToken: String, integUid: String)
}


extension ApisChatUserInfo: Moya.TargetType {
    
    
    var baseURL: URL {
        switch self {
        case .GetUserInfo:
            return URL(string: "https://fapi.fantoo.co.kr:9121")!
        }
    }
    
    var path: String {
        switch self {
        case .GetUserInfo:
            return "chat/user/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .GetUserInfo:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .GetUserInfo(_, let integUid):
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
        case .GetUserInfo(let accessToken, _):
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


