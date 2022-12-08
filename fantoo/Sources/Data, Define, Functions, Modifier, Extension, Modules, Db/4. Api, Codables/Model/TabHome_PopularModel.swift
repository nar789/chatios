//
//  TabHome_PopularModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/06/23.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct MainHomeTabPopular: Codable {
    let code: Int
    let message: String
    let data: Datas // Item, Data 이런 이름으로 struct 생성시 에러 발생함 !
    let page: Int
    let pages: Int
}

struct Datas: Codable {
    let trending: [String]
    let banner: [Banner]
    let clubReco: [ItemData]
    let board: [ItemData]
}

struct Banner: Codable, Identifiable {
    let _id: Int
    let id, image, image_en, url: String
}

struct BoardAndClubReco: Codable, Hashable {
    let type: String
    let item: Item
}

struct Item: Codable, Hashable {
    let board_name, author_id, author_uid, author_nickname, author_profile, post_id, title, subject, contents, date, ad_image: String
    let board_id, anonymous, use_notice, like_count, un_like_count, honor_count, story_count: Int
    let post_thumbnail: [Post_Thumbnail]
    let my: [String: Int]
    let tags: [String]
}
