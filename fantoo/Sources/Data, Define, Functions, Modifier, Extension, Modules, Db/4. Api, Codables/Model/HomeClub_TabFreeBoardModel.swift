//
//  HomeClub_TabFreeBoardModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct HomeClub_TabFreeboardModel: Codable {
    let code: Int
    let data: HomeClub_TabFreeboardModel_Data
}

struct HomeClub_TabFreeboardModel_Data: Codable {
    let category: [String]
    let free_board: [HomeClub_TabFreeboardModel_FreeBoard]
}
struct HomeClub_TabFreeboardModel_FreeBoard: Codable, Hashable {
    let board_name, author_id, author_uid, author_nickname, author_profile, title, subject, contents, date: String
    let board_id, post_id, anonymous, use_notice, like_count, un_like_count, honor_count, story_count: Int
    let post_thumbnail: [Post_Thumbnail]
    let my: [String: Int]
    let tags: [String]
    //let web_link: itemCardWebLink
    let post_video: itemCardVideo
    let comment: [Comment_Community]
}
