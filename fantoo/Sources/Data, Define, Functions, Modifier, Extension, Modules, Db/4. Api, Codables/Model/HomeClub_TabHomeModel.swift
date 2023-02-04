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

struct HomeClub_TabHome_Response: Codable {
    let listSize: Int
    let nextId: Int?
    let postList: [HomeClub_TabHome_Post_Model]?
}

struct HomeClub_TabHome_Post_Model: Codable, Hashable {
    let attachList: [HomeClub_TabHome_Post_Attach_Model]?
    let attachType: Int?
    let blockType: Int?
    let boardType: Int?
    let categoryCode: String?
    let categoryName1: String?
    let categoryName2: String?
    let clubId: String?
    let clubName: String?
    let content: String?
    let createDate: String?
    let deleteType: Int?
    let firstImage: String?
    let hashtagList: [String]?
    let honor: HomeClub_TabHome_Post_Honor_Model?
    let integUid: String?
    let langCode: String?
    let like: HomeClub_TabHome_Post_Like_Model?
    let link: String?
    let memberId: Int?
    let memberLevel: Int?
    let nickname: String?
    let postId: Int?
    let profileImg: String?
    let replyCount: Int?
    let status: Int?
    let subject: String?
    let url: String?
}

struct HomeClub_TabHome_Post_Attach_Model: Codable, Hashable {
    let attach: String
    let attachId: Int
    let attachType: Int
}

struct HomeClub_TabHome_Post_Honor_Model: Codable, Hashable {
    let honorCount: Int
    let honorYn: Bool
}

struct HomeClub_TabHome_Post_Like_Model: Codable, Hashable {
    let dislikeCount: Int
    let likeCount: Int
    let likeYn: Bool
}


extension HomeClub_TabHome_Post_Attach_Model {
    func toPostThumbnail() -> Post_Thumbnail {
        return Post_Thumbnail(type: String(attachType), url: attach.imageOriginalUrl)
    }
}
