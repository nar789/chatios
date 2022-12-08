//
//  TransModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/11/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct TransData: Codable {
    let status: String
    let language: [String]
    let messages: [TransMessagesList]
}

struct TransMessagesList: Codable, Hashable {
    let origin, text: String
    let isTranslated: String?
    
    init(frome decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        origin = (try? container.decode(String.self, forKey: .origin)) ?? ""
        text = (try? container.decode(String.self, forKey: .text)) ?? ""
        isTranslated = (try? container.decode(String.self, forKey: .isTranslated)) ?? ""
    }
}

struct TransMessagesReq: Codable {
    let origin, text: String
}
