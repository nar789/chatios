//
//  ClubDetailPageModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct ClubDetailPageModel: Codable {
    let code: Int
    let data: ClubDetailPageData
}
struct ClubDetailPageData: Codable {
    let board_id, post_id, anonymous, use_notice, like_count, un_like_count, honor_count, story_count: Int
    let board_name, board_item_name, author_id, author_uid, author_nickname, author_profile, title, subject, contents, date: String
    //let post_thumbnail: [CommunityDetailPage_Thumbnail]
    let post_thumbnail: [Post_Thumbnail]
    let post_video: ClubDetailPage_Video
    let my: ClubDetailPage_My
    let tags: [String]
    //let comment: [CommunityDetailPage_Comment]
    let comment: [Comment_Community]
}
struct ClubDetailPage_Thumbnail: Codable, Hashable {
    let type, url: String
}
struct ClubDetailPage_Video: Codable {
    let video_url, video_thumbnail: String
}
struct ClubDetailPage_My: Codable {
    let like_yn, honor_yn, club_join_yn, voting_yn, voting_pos, blind_yn, block_yn, favorite_yn: Int
}
struct ClubDetailPage_Comment: Codable, Hashable {
    let id, comment_like_count: Int
    let content, image, createAt, updateAt, comment_uid, comment_nickname, comment_profile: String
    let recomment: [ClubDetailPage_Comment_Recomment]
}
struct ClubDetailPage_Comment_Recomment: Codable, Hashable {
    let id, comment_like_count: Int
    let content, image, createAt, updateAt, comment_uid, comment_nickname, comment_profile: String
}
