


import Moya
import Foundation
import Alamofire



enum ApisChatBlock {
    case block(accessToken:String, targetUid:String)
    case unblock(accessToken:String, targetUid:String)
    case isblockconversation(accessToken:String, conversationId:String)
    case blockconversation(accessToken:String, conversationId:String)
    case unblockconversation(accessToken:String, conversationId:String)
}




extension ApisChatBlock: Moya.TargetType {
    
    
    var baseURL: URL {
        switch self {
        case .block:
            return URL(string: "https://fapi.fantoo.co.kr:9121")!
        case .unblock:
            return URL(string: "https://fapi.fantoo.co.kr:9121")!
        case .blockconversation:
            return URL(string: "https://fapi.fantoo.co.kr:9121")!
        case .unblockconversation:
            return URL(string: "https://fapi.fantoo.co.kr:9121")!
        case .isblockconversation:
            return URL(string: "https://fapi.fantoo.co.kr:9121")!
        }
    }
    
    var path: String {
        switch self {
        case .block:
            return "chat/block"
        case .unblock:
            return "chat/block"
        case .blockconversation:
            return "chat/conversation/block"
        case .unblockconversation:
            return "chat/conversation/block"
        case .isblockconversation:
            return "chat/conversation/block"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .block:
            return .post
        case .unblock:
            return .delete
        case .blockconversation:
            return .post
        case .unblockconversation:
            return .delete
        case .isblockconversation:
            return .get
            
        }
    }
    
    var task: Task {
        switch self {
        case .block(_, let integUid):
            var params = defaultParams
            params["integUid"] = UserManager.shared.uid
            params["targetIntegUid"] = integUid
           
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .unblock(_, let integUid):
            var params = defaultParams
            params["integUid"] = UserManager.shared.uid
            params["targetIntegUid"] = integUid
           
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .blockconversation(_, let conversationId):
            var params = defaultParams
            params["integUid"] = UserManager.shared.uid
            params["conversationId"] = conversationId
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .unblockconversation(_, let conversationId):
            var params = defaultParams
            params["integUid"] = UserManager.shared.uid
            params["conversationId"] = conversationId
            log(params: params)
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .isblockconversation(_, let conversationId):
            var params = defaultParams
            params["integUid"] = UserManager.shared.uid
            params["conversationId"] = conversationId
            log(params: params)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
        
    
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
        case .block(let accessToken, _):
            header["Content-Type"] = "application/json"
            header["access_token"] = accessToken
        case .unblock(let accessToken,_):
            header["Content-Type"] = "application/json"
            header["access_token"] = accessToken
        case .blockconversation(let accessToken,_):
            header["Content-Type"] = "application/json"
            header["access_token"] = accessToken
        case .unblockconversation(let accessToken,_):
            header["Content-Type"] = "application/json"
            header["access_token"] = accessToken
        case .isblockconversation(let accessToken,_):
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
