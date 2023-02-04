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


// --------------------------------------- api 적용

struct MainHomeData: Codable {
    let listSize: Int
    let mainPostDtoList: [MainPostDtoList]
    let nextId: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        listSize = (try? container.decode(Int.self, forKey: .listSize)) ?? 0
        mainPostDtoList = (try? container.decode([MainPostDtoList].self, forKey: .mainPostDtoList)) ?? []
        nextId = (try? container.decode(String.self, forKey: .nextId)) ?? ""
        
    }
}

struct MainPostDtoList: Codable {
    let clubPost: ClubPost?
    let comPost: ComPost?
    var type: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubPost = (try? container.decode(ClubPost.self, forKey: .clubPost)) ?? nil
        comPost = (try? container.decode(ComPost.self, forKey: .comPost)) ?? nil
        type = (try? container.decode(String.self, forKey: .type)) ?? ""
        
    }
}

struct ClubPost: Codable {
    let attachList: [AttachList]
    let attachType: Int
    let blockType: Int
    let boardType: Int
    let categoryCode: String
    let categoryId: String
    let categoryName1: String
    let categoryName2: String
    let clubId: String
    let clubName: String
    let content: String
    let createDate: String
    let deleteType: Int
    let firstImage: String
    let hashtagList: [String]
    let integUid: String
    let langCode: String
    let like: LikeData?
    let link: String
    let memberId: Int
    let memberLevel: Int
    let nickname: String
    let openGraphList: [OpenGraphList]
    let parentCategoryId: String
    let postId: Int
    let profileImg: String
    let replyCount: Int
    let scoreSort: String
    let status: Int
    let subject: String
    let topYn: Bool
    let url: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        attachList = (try? container.decode([AttachList].self, forKey: .attachList)) ?? []
        attachType = (try? container.decode(Int.self, forKey: .attachType)) ?? 0
        blockType = (try? container.decode(Int.self, forKey: .blockType)) ?? 0
        boardType = (try? container.decode(Int.self, forKey: .boardType)) ?? 0
        categoryCode = (try? container.decode(String.self, forKey: .categoryCode)) ?? ""
        categoryId = (try? container.decode(String.self, forKey: .categoryId)) ?? ""
        categoryName1 = (try? container.decode(String.self, forKey: .categoryName1)) ?? ""
        categoryName2 = (try? container.decode(String.self, forKey: .categoryName2)) ?? ""
        clubId = (try? container.decode(String.self, forKey: .clubId)) ?? ""
        clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
        content = (try? container.decode(String.self, forKey: .content)) ?? ""
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        deleteType = (try? container.decode(Int.self, forKey: .deleteType)) ?? 0
        firstImage = (try? container.decode(String.self, forKey: .firstImage)) ?? ""
        hashtagList = (try? container.decode([String].self, forKey: .hashtagList)) ?? [""]
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        like = (try? container.decode(LikeData.self, forKey: .like)) ?? nil
        link = (try? container.decode(String.self, forKey: .link)) ?? ""
        memberId = (try? container.decode(Int.self, forKey: .memberId)) ?? 0
        memberLevel = (try? container.decode(Int.self, forKey: .memberLevel)) ?? 0
        nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        openGraphList = (try? container.decode([OpenGraphList].self, forKey: .openGraphList)) ?? []
        parentCategoryId = (try? container.decode(String.self, forKey: .parentCategoryId)) ?? ""
        postId = (try? container.decode(Int.self, forKey: .postId)) ?? 0
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        replyCount = (try? container.decode(Int.self, forKey: .replyCount)) ?? 0
        scoreSort = (try? container.decode(String.self, forKey: .scoreSort)) ?? ""
        status = (try? container.decode(Int.self, forKey: .status)) ?? 0
        subject = (try? container.decode(String.self, forKey: .subject)) ?? ""
        topYn = (try? container.decode(Bool.self, forKey: .topYn)) ?? false
        url = (try? container.decode(String.self, forKey: .url)) ?? ""
        
    }
}


struct AttachList: Codable {
    let attach: String
    let attachId: Int
    let attachType: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        attach = (try? container.decode(String.self, forKey: .attach)) ?? ""
        attachId = (try? container.decode(Int.self, forKey: .attachId)) ?? 0
        attachType = (try? container.decode(Bool.self, forKey: .attachType)) ?? false
        
    }
}

struct LikeData: Codable {
    let dislikeCount: Int
    let likeCount: Int
    let likeYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dislikeCount = (try? container.decode(Int.self, forKey: .dislikeCount)) ?? 0
        likeCount = (try? container.decode(Int.self, forKey: .likeCount)) ?? 0
        likeYn = (try? container.decode(Bool.self, forKey: .likeYn)) ?? false
        
    }
}

struct OpenGraphList: Codable {
    let description: String
    let domain: String
    let image: String
    let title: String
    let url: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
        domain = (try? container.decode(String.self, forKey: .domain)) ?? ""
        image = (try? container.decode(String.self, forKey: .image)) ?? ""
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        url = (try? container.decode(String.self, forKey: .url)) ?? ""
    }
}

struct ComPost: Codable {
    let activeStatus: Int
    let anonymYn: Bool
    let attachList: [ComPostAttachList]
    let attachYn: Bool
    let bookmarkYn: Bool
    let categoryImage: String
    let code: String
    let content: String
    let createDate: String
    let dislikeCnt: Int
    let dislikeYn: Bool
    let hashtagList: [HashTagList]
    let honorCnt: Int
    let integUid: String
    let langCode: String
    let likeCnt: Int
    let likeYn: Bool
    let openGraphList: [OpenGraphList]
    let pieceBlockYn: Bool
    let postId: Int
    let replyCnt: Int
    let scoreSort: String
    let subCode: String
    let title: String
    let userBlockYn: Bool
    let userNick: String
    let userPhoto: String
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activeStatus = (try? container.decode(Int.self, forKey: .activeStatus)) ?? 0
        anonymYn = (try? container.decode(Bool.self, forKey: .anonymYn)) ?? false
        attachList = (try? container.decode([ComPostAttachList].self, forKey: .attachList)) ?? []
        attachYn = (try? container.decode(Bool.self, forKey: .attachYn)) ?? false
        bookmarkYn = (try? container.decode(Bool.self, forKey: .bookmarkYn)) ?? false
        categoryImage = (try? container.decode(String.self, forKey: .categoryImage)) ?? ""
        code = (try? container.decode(String.self, forKey: .code)) ?? ""
        content = (try? container.decode(String.self, forKey: .content)) ?? ""
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        dislikeCnt = (try? container.decode(Int.self, forKey: .dislikeCnt)) ?? 0
        dislikeYn = (try? container.decode(Bool.self, forKey: .dislikeCnt)) ?? false
        hashtagList = (try? container.decode([HashTagList].self, forKey: .hashtagList)) ?? []
        honorCnt = (try? container.decode(Int.self, forKey: .honorCnt)) ?? 0
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        likeCnt = (try? container.decode(Int.self, forKey: .likeCnt)) ?? 0
        likeYn = (try? container.decode(Bool.self, forKey: .likeYn)) ?? false
        openGraphList = (try? container.decode([OpenGraphList].self, forKey: .openGraphList)) ?? []
        pieceBlockYn = (try? container.decode(Bool.self, forKey: .pieceBlockYn)) ?? false
        postId = (try? container.decode(Int.self, forKey: .postId)) ?? 0
        replyCnt = (try? container.decode(Int.self, forKey: .replyCnt)) ?? 0
        scoreSort = (try? container.decode(String.self, forKey: .scoreSort)) ?? ""
        subCode = (try? container.decode(String.self, forKey: .subCode)) ?? ""
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        userBlockYn = (try? container.decode(Bool.self, forKey: .userBlockYn)) ?? false
        userNick = (try? container.decode(String.self, forKey: .userNick)) ?? ""
        userPhoto = (try? container.decode(String.self, forKey: .userPhoto)) ?? ""
        
    }
}

struct HashTagList: Codable {
    let tag: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tag = (try? container.decode(String.self, forKey: .tag)) ?? ""
    }
}

struct ComPostAttachList: Codable {
    let attachType: String
    let id: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        attachType = (try? container.decode(String.self, forKey: .attachType)) ?? ""
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
    }
}


struct MainHomeTabPopularTrending: Codable {
    let listSize: Int
    let searchList: [TrendingList]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        listSize = (try? container.decode(Int.self, forKey: .listSize)) ?? 0
        searchList = (try? container.decode([TrendingList].self, forKey: .searchList)) ?? []
    }
}

struct TrendingList: Codable, Hashable {
    let hashtagId: Int
    let tag: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hashtagId = (try? container.decode(Int.self, forKey: .hashtagId)) ?? 0
        tag = (try? container.decode(String.self, forKey: .tag)) ?? ""
    }
}
