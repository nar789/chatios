//
//  MainTabClubModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct MainClub_MainPage: Codable {
    let code: Int
    let data: MainClub_MainPageData
}
struct MainClub_MainPageData: Codable {
    let ad: MainClub_MainPage_Ad
    let myclub: [MainClub_MainPage_MyClub]
    let challenge: [String]
    let popular_club: MainClub_MainPage_PopularClub
    let new_club: [MainClub_MainPage_NewClub]
    let popular_top10: [MainClub_MainPage_PopularTop10]
}

struct MainClub_MainPage_Ad: Codable {
    let id, image, image_en, url: String
}
struct MainClub_MainPage_MyClub: Codable, Hashable {
    let club_name, club_image: String
    var owner, lock, favorite: Bool
    let users: Int
    let club_tags: [String]
}
struct MainClub_MainPage_PopularClub: Codable {
    let catagory: [String]
    let club_list: [MainClub_MainPage_PopularClub_ClubList]
}
struct MainClub_MainPage_PopularClub_ClubList: Codable, Hashable {
    let club_name, club_image, profile_image: String
    let club_tags: [String]
    let isJoined: Bool
}
struct MainClub_MainPage_NewClub: Codable, Hashable {
    let club_name, club_image, profile_image: String
    let club_tags: [String]
    let isJoined: Bool
}
struct MainClub_MainPage_PopularTop10: Codable, Hashable {
    let board_id, post_id, anonymous, use_notice, like_count, un_like_count, honor_count, story_count: Int
    let board_name, author_id, author_uid, author_nickname, author_profile, title, subject, contents, date: String
    let post_thumbnail: [MainClub_MainPage_PopularTop10_Thumbnail]
    let post_video: MainClub_MainPage_PopularTop10_Video
    let my: MainClub_MainPage_PopularTop10_My
    let tags: [String]
    let comment: [MainClub_MainPage_PopularTop10_Comment]
}
struct MainClub_MainPage_PopularTop10_Thumbnail: Codable, Hashable {
    let type, url: String
}
struct MainClub_MainPage_PopularTop10_Video: Codable, Hashable {
    let video_url, video_thumbnail: String
}
struct MainClub_MainPage_PopularTop10_My: Codable, Hashable {
    let like_yn, honor_yn, club_join_yn, voting_yn, voting_pos, blind_yn, block_yn, favorite_yn: Int
}
struct MainClub_MainPage_PopularTop10_Comment: Codable, Hashable {
    let id, comment_like_count: Int
    let content, image, createAt, updateAt, comment_uid, comment_nickname, comment_profile: String
    let recomment: [MainClub_MainPage_PopularTop10_Comment_Recomment]
}
struct MainClub_MainPage_PopularTop10_Comment_Recomment: Codable, Hashable {
    let id, comment_like_count: Int
    let content, image, createAt, updateAt, comment_uid, comment_nickname, comment_profile: String
}
