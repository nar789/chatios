


import Moya
import Foundation
import Alamofire



enum ApisChatTranslate {
    case translate(id:String, text:String, user:String)
}




extension ApisChatTranslate: Moya.TargetType {
    
    
    var baseURL: URL {
        switch self {
        case .translate:
            return URL(string: "http://ntrans.fantoo.co.kr:5000")!
        }
    }
    
    var path: String {
        switch self {
        case .translate:
            return "trans"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .translate:
            return .post
        
        }
    }
    
    var task: Task {
        switch self {
        case .translate(let id, let text, let user):
            let m:ApisChatTranslateModelMessage = .init(id: id, text:text, user:user)
            let languageCode:String = LanguageManager.shared.getLanguageCode()
            let p:ApisChatTranslateModel = .init(language: [languageCode], messages: [m])
            return .requestJSONEncodable(p)
        }
    }
    
    var headers: [String : String]? {
        var header = CommonFunction.defaultHeader()
        
        switch self {
        case .translate(_, _, _):
            header["Content-Type"] = "application/json"
        
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

struct ApisChatTranslateModel:Codable{
    
    var language:[String] = []
    var messages:[ApisChatTranslateModelMessage] = []
}

struct ApisChatTranslateModelMessage:Codable {
    
    var id:String = ""
    var text:String = ""
    var user:String = ""
    
}
