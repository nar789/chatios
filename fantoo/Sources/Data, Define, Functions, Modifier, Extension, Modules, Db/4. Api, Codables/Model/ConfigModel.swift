//
//  Config.swift
//  fantoo
//
//  Created by mkapps on 2021/09/27.
//  Copyright © 2021 FNS. All rights reserved.
//

import Foundation

struct ConfigData: Codable {
    let emergency: ConfigDataEmergency?
    let server: ConfigDataServer?
    let version: ConfigDataVersion?
}

struct ConfigDataEmergency: Codable {
    let enable: Int
    let end_date: String
    let message_eng: String
    let message_kr: String
    let start_date: String
    
    enum CodingKeys: String, CodingKey {
        case enable
        case end_date
        case message_eng
        case message_kr
        case start_date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.enable = (try? container.decode(Int.self, forKey: .enable)) ?? 0
        self.end_date = (try? container.decode(String.self, forKey: .end_date)) ?? ""
        self.message_eng = (try? container.decode(String.self, forKey: .message_eng)) ?? ""
        self.message_kr = (try? container.decode(String.self, forKey: .message_kr)) ?? ""
        self.start_date = (try? container.decode(String.self, forKey: .start_date)) ?? ""
    }
}

struct ConfigDataServer: Codable {
    let api_url: String?
    let image_url: String?
    let trans_url: String?
    let web_url: String?
    let ad_url: String?
    let pay_url: String?
}

struct ConfigDataVersion: Codable {
    let current_version: String?
    let force_update: Int?
    let update_enable: Int?
}

