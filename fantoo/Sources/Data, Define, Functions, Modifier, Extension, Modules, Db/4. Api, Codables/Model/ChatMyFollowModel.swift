
import Foundation

struct ChatMyFollowModel : Codable, Hashable {
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
