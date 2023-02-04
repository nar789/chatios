
import Foundation


struct ChatUserInfoModel : Codable, Hashable {
    
    var blockYn: Bool = false
    var followYn: Bool = false
    let userNick: String
    let userPhoto: String
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        blockYn = (try? container.decode(Bool.self, forKey: .blockYn)) ?? false
        followYn = (try? container.decode(Bool.self, forKey: .followYn)) ?? false
        userNick = (try? container.decode(String.self, forKey: .userNick)) ?? ""
        userPhoto = (try? container.decode(String.self, forKey: .userPhoto)) ?? ""
    }
    
}
