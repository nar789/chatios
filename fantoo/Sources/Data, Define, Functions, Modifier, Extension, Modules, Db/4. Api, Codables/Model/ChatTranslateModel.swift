

import Foundation




struct ChatTranslateModel : Codable, Hashable {
    
    var status: String = ""
    var language: [String] = []
    var messages: [ChatTranslateMessageModel] = []
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? container.decode(String.self, forKey: .status )) ?? ""
        language = (try? container.decode([String].self, forKey: .language)) ?? []
        messages = (try? container.decode([ChatTranslateMessageModel].self, forKey: .messages)) ?? []
    }
    

}

struct ChatTranslateMessageModel : Codable, Hashable {
    var id: String = ""
    var text: String = ""
    var user: String = ""
    var isTranslate:String = ""
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
        text = (try? container.decode(String.self, forKey: .text)) ?? ""
        user = (try? container.decode(String.self, forKey: .user)) ?? ""
        isTranslate = (try? container.decode(String.self, forKey: .isTranslate)) ?? ""
    }
}
