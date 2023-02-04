//
//  MainTabClubModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

/**
 * 내 클럽
 */
struct MainClub_MyClub: Codable {
    let clubList: [MainClub_MyClub_ClubList]
    let listSize: Int
    let favoriteYn: Bool?
    let nextId: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubList = (try? container.decode([MainClub_MyClub_ClubList].self, forKey: .clubList)) ?? []
        listSize = (try? container.decode(Int.self, forKey: .listSize)) ?? 0
        favoriteYn = (try? container.decode(Bool.self, forKey: .favoriteYn)) ?? nil
        nextId = (try? container.decode(Int.self, forKey: .nextId)) ?? nil
    }
}
struct MainClub_MyClub_ClubList: Codable, Hashable {
    let clubId: Int
    let clubName, profileImg: String
    let openYn, manageYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        openYn = (try? container.decode(Bool.self, forKey: .openYn)) ?? false
        manageYn = (try? container.decode(Bool.self, forKey: .manageYn)) ?? false
    }
}

/**
 * 인기클럽 추천 카테고리
 */
struct MainClub_Popular_Category: Codable {
    let popularList: [MainClub_Popular_Category_PopularList]
    let listSize: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        popularList = (try? container.decode([MainClub_Popular_Category_PopularList].self, forKey: .popularList)) ?? []
        listSize = (try? container.decode(Int.self, forKey: .listSize)) ?? 0
    }
}
struct MainClub_Popular_Category_PopularList: Codable, Hashable {
    let categoryCode, categoryCodeName: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryCode = (try? container.decode(String.self, forKey: .categoryCode)) ?? ""
        categoryCodeName = (try? container.decode(String.self, forKey: .categoryCodeName)) ?? ""
    }
}

/**
 * 인기 게시글 TOP10
 */
struct MainClub_Popular10: Codable {
    let postList: [MainClub_Popular10_PostList]
    let listSize: Int
    let date: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postList = (try? container.decode([MainClub_Popular10_PostList].self, forKey: .postList)) ?? []
        listSize = (try? container.decode(Int.self, forKey: .listSize)) ?? 0
        date = (try? container.decode(String.self, forKey: .date)) ?? ""
    }
}
struct MainClub_Popular10_PostList: Codable, Hashable {
    let postId, memberId, replyCount, memberLevel, status, boardType, attachType, deleteType: Int
    let clubId, categoryCode, subject, langCode, createDate, nickname, url, categoryName1, categoryName2, profileImg, link: String
    let honor: MainClub_Popular10_PostList_Honor?
    let like: MainClub_Popular10_PostList_Like?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postId = (try? container.decode(Int.self, forKey: .postId)) ?? 0
        memberId = (try? container.decode(Int.self, forKey: .memberId)) ?? 0
        replyCount = (try? container.decode(Int.self, forKey: .replyCount)) ?? 0
        memberLevel = (try? container.decode(Int.self, forKey: .memberLevel)) ?? 0
        status = (try? container.decode(Int.self, forKey: .status)) ?? 0
        boardType = (try? container.decode(Int.self, forKey: .boardType)) ?? 0
        attachType = (try? container.decode(Int.self, forKey: .attachType)) ?? 0
        deleteType = (try? container.decode(Int.self, forKey: .deleteType)) ?? 0
        clubId = (try? container.decode(String.self, forKey: .clubId)) ?? ""
        categoryCode = (try? container.decode(String.self, forKey: .categoryCode)) ?? ""
        subject = (try? container.decode(String.self, forKey: .subject)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        url = (try? container.decode(String.self, forKey: .url)) ?? ""
        categoryName1 = (try? container.decode(String.self, forKey: .categoryName1)) ?? ""
        categoryName2 = (try? container.decode(String.self, forKey: .categoryName2)) ?? ""
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        link = (try? container.decode(String.self, forKey: .link)) ?? ""
        honor = (try? container.decode(MainClub_Popular10_PostList_Honor.self, forKey: .honor)) ?? nil
        like = (try? container.decode(MainClub_Popular10_PostList_Like.self, forKey: .like)) ?? nil
    }
}
struct MainClub_Popular10_PostList_Like: Codable, Hashable {
    let likeYn: Bool?
    let likeCount, dislikeCount: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        likeYn = (try? container.decode(Bool.self, forKey: .likeYn)) ?? nil
        likeCount = (try? container.decode(Int.self, forKey: .likeCount)) ?? 0
        dislikeCount = (try? container.decode(Int.self, forKey: .dislikeCount)) ?? 0
    }
}
struct MainClub_Popular10_PostList_Honor: Codable, Hashable {
    let honorYn: Bool
    let honorCount: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        honorYn = (try? container.decode(Bool.self, forKey: .honorYn)) ?? false
        honorCount = (try? container.decode(Int.self, forKey: .honorCount)) ?? 0
    }
}
