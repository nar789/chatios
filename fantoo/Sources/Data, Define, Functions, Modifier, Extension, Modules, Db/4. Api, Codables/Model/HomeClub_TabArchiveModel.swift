//
//  HomeClub_TabArchiveModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct HomeClub_TabArchiveModel: Codable {
    let code: Int
    let data: [HomeClub_TabArchiveModel_Data]
}

struct HomeClub_TabArchiveModel_Data: Codable, Hashable {
    let club_id, file_count: Int
    let title: String
    let post_thumbnail: [Post_Thumbnail]
}
