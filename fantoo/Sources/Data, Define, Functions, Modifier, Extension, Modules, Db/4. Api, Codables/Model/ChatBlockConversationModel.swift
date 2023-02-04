

import Foundation


struct ChatBlockConversationModel : Codable, Hashable {
    
    var blockYn: Bool = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        blockYn = (try? container.decode(Bool.self, forKey: .blockYn)) ?? false
    }
    
}
