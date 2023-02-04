
import Foundation


struct ChatSearchListModel : Codable, Hashable {
    let listSize : Int
    let nextId : Int
    let chatUserDtoList : [ChatUserModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        listSize = (try? container.decode(Int.self, forKey: .listSize)) ?? 0
        nextId = (try? container.decode(Int.self, forKey: .nextId)) ?? 0
        chatUserDtoList = (try? container.decode([ChatUserModel].self, forKey: .chatUserDtoList)) ?? []
    }
}


struct ChatUserModel : Codable, Hashable, Identifiable {
    let integUid : String
    let type : String
    let userNick : String
    let userPhoto : String
    var id: String { integUid }
    var isChecked = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        type = (try? container.decode(String.self, forKey: .type)) ?? ""
        userNick = (try? container.decode(String.self, forKey: .userNick)) ?? ""
        userPhoto = (try? container.decode(String.self, forKey: .userPhoto)) ?? ""
    }
}
