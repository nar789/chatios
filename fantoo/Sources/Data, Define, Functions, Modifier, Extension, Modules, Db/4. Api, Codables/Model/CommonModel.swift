//
//  CommonModel.swift
//  fantoo
//
//  Created by mkapps on 2022/04/27.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

struct ErrorModel: Codable, Error {
    var code : String = ""
    
//    var msg : String? = ""
//    var code: String = "" {
//        didSet {
//
//        }
//    }

    var message: String {
        return ErrorHandler.getErrorMessage(code: code)
    }
}

struct ResultModel: Codable {
    let success: Bool
}

struct Post_Thumbnail: Codable, Hashable {
    let type: String
    let url: String
}


//MARK: - Transition
struct TransResult: Codable {
    var status: String?
    var messages: [TransResultMessage]?
}

struct TransResultMessage: Codable {
    var id: String?
    var isTranslated: String?
    var text: String?
    var user: String?
}

struct Trans: Codable {
    var message:String?
    var id:String?
}

struct OpenGraphListModel: Codable, Hashable {
    let title, description, domain, url, image: String
}


//MARK: - Club
struct Club_DetailTopModel: Codable {
    let clubId, memberCount: Int
    let clubName, introduction, createDate, profileImg, clubMasterNickname: String
    let memberCountOpenYn: Bool
}

struct Club_FollowModel: Codable {
    let followYn: Bool
}

struct Club_TabInfoModel: Codable {
    let categoryList: [ClubCategoryModel]
    let listSize: Int
}

struct ClubCategoryModel: Codable, Hashable {
    let clubId, categoryCode, url, categoryName: String
    let categoryId, boardType, depth, sort, categoryType : Int
    let parentCategoryId, postCount: Int?
    let openYn: Bool
    let showYn, commonYn: Bool?
    let firstImageList: [String]?
    let categoryList: [ClubCategoryModel]?
}

struct Club_TabHomeModel: Codable {
    let postList: [Club_TabHomeModel_PostList]
    let listSize, nextId: Int
}

struct Club_TabHomeModel_PostList: Codable, Hashable {
    let postId, memberId, memberLevel, status, boardType, attachType, deleteType: Int
    let replyCount: Int?
    let clubId, categoryCode, subject, content, langCode, createDate, nickname, url, categoryName1, categoryName2, profileImg: String
    let attachList: [AttachListModel]
    var like: Club_Like
}
struct AttachListModel: Codable, Hashable {
    let attachType, attachId: Int
    let attach: String
}

struct Club_Like: Codable, Hashable {
    var likeYn: Bool? // nil 값이 있기 때문에 옵셔널로 설정한다. true: 좋아요 누른 경우, false: 싫어요 누른 경우, nil: 아무것도 누르지 않은 경우
    let likeCount: Int
    let dislikeCount: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        likeYn = (try? container.decode(Bool.self, forKey: .likeYn)) ?? nil
        likeCount = (try? container.decode(Int.self, forKey: .likeCount)) ?? 0
        dislikeCount = (try? container.decode(Int.self, forKey: .dislikeCount)) ?? 0
    }
}

struct Community_Like: Codable {
    let like: Int
    let disLike: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        like = (try? container.decode(Int.self, forKey: .like)) ?? 0
        disLike = (try? container.decode(Int.self, forKey: .disLike)) ?? 0
    }
}

struct Community_hashtagList: Codable, Hashable {
    let tag: String
}
