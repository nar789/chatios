//
//  HomeClub_TabHomeModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct HomeClub_TabHomeModel: Codable {
    let code: Int
    let data: HomeClub_TabHomeModel_Data
}

struct HomeClub_TabHomeModel_Data: Codable {
    let notice: [String]
    let ad: HomeClub_TabHomeModel_Ad
    let board_list: [HomeClub_TabHomeModel_BoardList]
}
struct HomeClub_TabHomeModel_Ad: Codable {
    let id: String
    let image: String
    let image_en: String
    let url: String
}
struct HomeClub_TabHomeModel_BoardList: Codable, Hashable {
    let board_name, author_id, author_uid, author_nickname, author_profile, post_id, title, subject, contents, date: String
    let board_id, anonymous, use_notice, like_count, un_like_count, honor_count, story_count: Int
    let post_thumbnail: [Post_Thumbnail]
    let my: [String: Int]
    let tags: [String]
    let web_link: itemCardWebLink
    let post_video: itemCardVideo
}
