//
//  CommonModel.swift
//  fantoo
//
//  Created by mkapps on 2022/04/27.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

struct ErrorModel: Codable, Error {
    var code : String = ""
    
    var msg : String? = ""
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
    let clubId, categoryId, categoryCode, url, categoryName: String
    let parentCategoryId: String?
    let boardType, depth, sort, categoryType : Int
    let postCount: Int?
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
    let clubId, categoryCode, subject, content, langCode, createDate, nickname, url, categoryName2, profileImg: String
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


struct ClubListCommonModel: Codable {
    let clubList: [ClubListCommonModel_ClubList]
    let listSize, nextId: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clubList = (try? container.decode([ClubListCommonModel_ClubList].self, forKey: .clubList)) ?? []
        self.listSize = (try? container.decode(Int.self, forKey: .listSize)) ?? 0
        self.nextId = (try? container.decode(Int.self, forKey: .nextId)) ?? 0
    }
}
struct ClubListCommonModel_ClubList: Codable, Hashable {
    let clubId, joinMemberCount, memberCount, postCount, joinStatus: Int
    let activeCountryCode, bgImg, clubMasterNickname, clubName, createDate, interestCategoryCode, introduction, languageCode, profileImg, visitDate: String
    let memberCountOpenYn, memberJoinAutoYn, memberListOpenYn, openYn: Bool
    let hashtagList: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        self.joinMemberCount = (try? container.decode(Int.self, forKey: .joinMemberCount)) ?? 0
        self.memberCount = (try? container.decode(Int.self, forKey: .memberCount)) ?? 0
        self.postCount = (try? container.decode(Int.self, forKey: .postCount)) ?? 0
        self.joinStatus = (try? container.decode(Int.self, forKey: .joinStatus)) ?? 0
        self.activeCountryCode = (try? container.decode(String.self, forKey: .activeCountryCode)) ?? ""
        self.bgImg = (try? container.decode(String.self, forKey: .bgImg)) ?? ""
        self.clubMasterNickname = (try? container.decode(String.self, forKey: .clubMasterNickname)) ?? ""
        self.clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
        self.createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        self.interestCategoryCode = (try? container.decode(String.self, forKey: .interestCategoryCode)) ?? ""
        self.introduction = (try? container.decode(String.self, forKey: .introduction)) ?? ""
        self.languageCode = (try? container.decode(String.self, forKey: .languageCode)) ?? ""
        self.profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        self.visitDate = (try? container.decode(String.self, forKey: .visitDate)) ?? ""
        self.memberCountOpenYn = (try? container.decode(Bool.self, forKey: .memberCountOpenYn)) ?? false
        self.memberJoinAutoYn = (try? container.decode(Bool.self, forKey: .memberJoinAutoYn)) ?? false
        self.memberListOpenYn = (try? container.decode(Bool.self, forKey: .memberListOpenYn)) ?? false
        self.openYn = (try? container.decode(Bool.self, forKey: .openYn)) ?? false
        self.hashtagList = (try? container.decode([String].self, forKey: .hashtagList)) ?? []
    }
}




/**
 * 클럽 공통
 */
struct ClubCommonModel_AttachList: Codable, Hashable {
    let attachType, attachId: Int
    let attach: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attachType = (try? container.decode(Int.self, forKey: .attachType)) ?? 0
        self.attachId = (try? container.decode(Int.self, forKey: .attachId)) ?? 0
        self.attach = (try? container.decode(String.self, forKey: .attach)) ?? ""
    }
}
struct ClubCommonModel_Like: Codable, Hashable {
    let likeYn: Bool
    let likeCount, dislikeCount: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.likeYn = (try? container.decode(Bool.self, forKey: .likeYn)) ?? false
        self.likeCount = (try? container.decode(Int.self, forKey: .likeCount)) ?? 0
        self.dislikeCount = (try? container.decode(Int.self, forKey: .dislikeCount)) ?? 0
    }
}
struct ClubCommonModel_OpenGraphDtoList: Codable, Hashable {
    let description, domain, image, title, url: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        self.domain = (try? container.decode(String.self, forKey: .domain)) ?? ""
        self.image = (try? container.decode(String.self, forKey: .image)) ?? ""
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.url = (try? container.decode(String.self, forKey: .url)) ?? ""
    }
}
