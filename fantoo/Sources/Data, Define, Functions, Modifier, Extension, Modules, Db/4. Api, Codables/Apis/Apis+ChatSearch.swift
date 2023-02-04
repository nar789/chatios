

import Moya
import Foundation
import Alamofire

enum ApisChatSearch {
    case Search(accessToken: String, integUid: String, keyword: String)
}

extension ApisChatSearch: Moya.TargetType {
    
    var baseURL: URL {
        switch self {
        case .Search:
            return URL(string: "https://fapi.fantoo.co.kr:9121")!
        }
    }
    
    var path: String {
        switch self {
        case .Search:
            return "chat/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Search:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .Search(_, let integUid, let keyword):
            var params = defaultParams
            params["integUid"] = integUid
            params["search"] = keyword
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
        case .Search(let accessToken, _, _):
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


