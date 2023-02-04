




import Moya
import Foundation
import Alamofire

enum ApisChatMyFollow {
    case MyFollow(accessToken: String, integUid: String)
}

extension ApisChatMyFollow: Moya.TargetType {
    
    var baseURL: URL {
        switch self {
        case .MyFollow:
            return URL(string: "https://fapi.fantoo.co.kr:9121")!
        }
    }
    
    var path: String {
        switch self {
        case .MyFollow:
            return "chat/my/follow"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .MyFollow:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .MyFollow(_, let integUid):
            var params = defaultParams
            params["integUid"] = integUid
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
        case .MyFollow(let accessToken, _):
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


