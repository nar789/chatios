//
//  MainTabHome_HomeModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/05/26.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct MainHomeTabHome: Codable {
    let code: Int
    let message: String
    let data: TabHome
    let page: Int
    let pages: Int
}

struct TabHome: Codable {
    let banner: [BannerData]
    let board: [ItemData]
    let clubReco: [ItemData]
}

struct BannerData: Codable, Identifiable {
    let _id: Int
    let id, image, image_en, url: String
}

struct ItemData: Codable, Hashable {
    let type: String
    let item: itemCard
}

struct itemCardVideo: Codable, Hashable {
    let video_url, video_thumbnail: String
}

struct itemCardWebLink: Codable, Hashable {
    let link_image, link_title, link_url: String
}

struct itemCardClubReco: Codable, Hashable {
    let club_name, club_image, profile_image: String
    let club_tags: [String]
    let isJoined: Bool
}

struct itemCard: Codable, Hashable {
    let board_name, author_id, author_uid, author_nickname, author_profile, post_id, title, subject, contents, date, ad_image: String
    let board_id, anonymous, use_notice, like_count, un_like_count, honor_count, story_count: Int
    let post_thumbnail: [Post_Thumbnail]
    let my: [String: Int]
    let tags: [String]
    let web_link: itemCardWebLink
    let club_reco: [itemCardClubReco]
    let post_video: itemCardVideo
}

struct BoardData: Codable, Hashable {
    let type: String
    let community: boardCard
}

struct boardCardThumbnails: Codable, Hashable {
    let pos, title, image: String
    let percent: Int
}

struct boardCardMy: Codable {
    let like_yn, honor_yn, club_join_yn, voting_yn, voting_pos, blind_yn, block_yn, favorite_yn: Int
}

struct boardCard: Codable, Hashable {
    let board_name, author_id, author_uid, author_nickname, author_profile, post_id, title, subject, contents, date: String
    let board_id, anonymous, use_notice, like_count, un_like_count, honor_count, story_count: Int
    let post_thumbnail: [boardCardThumbnails]
    let my: [String: Int]
    let tags: [String]
}

struct CommunityData: Codable, Hashable {
    let type: String
    let community: communityCard
}

struct communityCard: Codable, Hashable {
    let board_id: Int
    let author_nickname, title, contents: String
}

struct fantooTvData: Codable, Hashable {
    let type: String
    let community: fantooTvCard
}

struct fantooTvCard: Codable, Hashable {
    let board_id: Int
    let author_nickname, title, contents: String
}

struct hanryuTimesData: Codable, Hashable {
    let type: String
    let community: hanryuTimesCard
}

struct hanryuTimesCard: Codable, Hashable {
    let board_id: Int
    let author_nickname, title, contents: String
}

struct clubData: Codable, Hashable {
    let type: String
    let community: clubCard
}

struct clubCard: Codable, Hashable {
    let board_id: Int
    let author_nickname, title, contents: String
}

struct clubRecoData: Codable, Hashable {
    let type: String
    let club: clubRecoCard
}

struct clubRecoThumbnails: Codable, Hashable {
    let type, url: String
}

struct clubRecoVotings: Codable, Hashable {
    let start_date, end_date, voting_idx: String
    let voting_count: Int
    let items: [clubRecoVotingItems]
}

struct clubRecoVotingItems: Codable, Hashable {
    let pos, title, image: String
    let percent: Int
}

struct clubRecoCard: Codable, Hashable {
    let club_id, club_name, author_id, author_uid, author_nickname, author_profile, post_id, title, subject, contents, date: String
    let anonymous, use_notice, like_count, un_like_count, honor_count, story_count: Int
    let post_thumbnail: [clubRecoThumbnails]
    let my: [String: Int]
    let tags: [String]
    let voting: clubRecoVotings
}
