//
//  UploadModel.swift
//  fantoo
//
//  Created by mkapps on 2022/10/27.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct UploadModel : Codable {
    var result : UploadResultModel
    var success: Bool
}

struct UploadResultModel : Codable {
    var id : String
    var filename: String
    var uploaded: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
        filename = (try? container.decode(String.self, forKey: .filename)) ?? ""
        uploaded = (try? container.decode(String.self, forKey: .uploaded)) ?? ""
    }
}
