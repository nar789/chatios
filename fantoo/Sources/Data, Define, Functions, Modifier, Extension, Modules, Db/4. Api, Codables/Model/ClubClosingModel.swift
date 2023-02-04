//
//  ClubClosingModel.swift
//  fantoo
//
//  Created by fns on 2022/10/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct ClubClosingStateData: Codable {
    let clubId: Int
    let closesStatus: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        closesStatus = (try? container.decode(Int.self, forKey: .closesStatus)) ?? 0
    }
}

