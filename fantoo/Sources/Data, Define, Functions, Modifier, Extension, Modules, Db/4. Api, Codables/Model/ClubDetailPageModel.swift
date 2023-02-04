//
//  ClubDetailPageModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

/**
 * 클럽 2뎁스(말머리) 게시물 상세
 */
struct ClubDetailModel: Codable {
    let attachType, blockType, boardType, deleteType, memberId, memberLevel, postId, replyCount, status: Int
    let categoryCode, categoryName1, categoryName2, clubId, clubName, content, createDate, firstImage, integUid, langCode, link, nickname, profileImg, subject, url: String
    let attachList: [ClubCommonModel_AttachList]
    let hashtagList: [String]
    var like: ClubCommonModel_Like?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attachType = (try? container.decode(Int.self, forKey: .attachType)) ?? 0
        self.blockType = (try? container.decode(Int.self, forKey: .blockType)) ?? 0
        self.boardType = (try? container.decode(Int.self, forKey: .boardType)) ?? 0
        self.deleteType = (try? container.decode(Int.self, forKey: .deleteType)) ?? 0
        self.memberId = (try? container.decode(Int.self, forKey: .memberId)) ?? 0
        self.memberLevel = (try? container.decode(Int.self, forKey: .memberLevel)) ?? 0
        self.postId = (try? container.decode(Int.self, forKey: .postId)) ?? 0
        self.replyCount = (try? container.decode(Int.self, forKey: .replyCount)) ?? 0
        self.status = (try? container.decode(Int.self, forKey: .attachType)) ?? 0
        self.categoryCode = (try? container.decode(String.self, forKey: .categoryCode)) ?? ""
        self.categoryName1 = (try? container.decode(String.self, forKey: .categoryName1)) ?? ""
        self.categoryName2 = (try? container.decode(String.self, forKey: .categoryName2)) ?? ""
        self.clubId = (try? container.decode(String.self, forKey: .clubId)) ?? ""
        self.clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        self.firstImage = (try? container.decode(String.self, forKey: .firstImage)) ?? ""
        self.integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        self.langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        self.link = (try? container.decode(String.self, forKey: .link)) ?? ""
        self.nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        self.profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        self.subject = (try? container.decode(String.self, forKey: .subject)) ?? ""
        self.url = (try? container.decode(String.self, forKey: .url)) ?? ""
        self.attachList = (try? container.decode([ClubCommonModel_AttachList].self, forKey: .attachList)) ?? []
        self.hashtagList = (try? container.decode([String].self, forKey: .hashtagList)) ?? []
    }
}

/**
 * 클럽 2뎁스(말머리) 게시물 상세 - 댓글 리스트
 */
struct ClubDetailReplyModel: Codable {
    let listSize: Int
    let nextId: String? // 클럽 댓글 리스트에서, 더이상 리스트가 없는 경우에 nextId가 nil로 옴 ㅡ.ㅡ;;;
    let replyList: [ClubDetailReplyModel_ReplyList]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.listSize = (try? container.decode(Int.self, forKey: .listSize)) ?? 0
        self.nextId = (try? container.decode(String.self, forKey: .nextId)) ?? ""
        self.replyList = (try? container.decode([ClubDetailReplyModel_ReplyList].self, forKey: .replyList)) ?? []
    }
}
struct ClubDetailReplyModel_ReplyList: Codable, Hashable {
    let blockType, deleteType, depth, level, memberId, parentReplyId, postId, replyCount, replyId, status: Int
    let categoryCode, categoryName1, categoryName2, clubId, clubName, content, createDate, integUid, langCode, nickname, profileImg, subject, updateDate, url: String
    let attachList: [ClubCommonModel_AttachList]
    var like: ClubCommonModel_Like?
    let openGraphDtoList: [ClubCommonModel_OpenGraphDtoList]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.blockType = (try? container.decode(Int.self, forKey: .blockType)) ?? 0
        self.deleteType = (try? container.decode(Int.self, forKey: .deleteType)) ?? 0
        self.depth = (try? container.decode(Int.self, forKey: .depth)) ?? 0
        self.level = (try? container.decode(Int.self, forKey: .level)) ?? 0
        self.memberId = (try? container.decode(Int.self, forKey: .memberId)) ?? 0
        self.parentReplyId = (try? container.decode(Int.self, forKey: .parentReplyId)) ?? 0
        self.postId = (try? container.decode(Int.self, forKey: .postId)) ?? 0
        self.replyCount = (try? container.decode(Int.self, forKey: .replyCount)) ?? 0
        self.replyId = (try? container.decode(Int.self, forKey: .replyId)) ?? 0
        self.status = (try? container.decode(Int.self, forKey: .status)) ?? 0
        self.categoryCode = (try? container.decode(String.self, forKey: .categoryCode)) ?? ""
        self.categoryName1 = (try? container.decode(String.self, forKey: .categoryName1)) ?? ""
        self.categoryName2 = (try? container.decode(String.self, forKey: .categoryName2)) ?? ""
        self.clubId = (try? container.decode(String.self, forKey: .clubId)) ?? ""
        self.clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        self.integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        self.langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        self.nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        self.profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        self.subject = (try? container.decode(String.self, forKey: .subject)) ?? ""
        self.updateDate = (try? container.decode(String.self, forKey: .updateDate)) ?? ""
        self.url = (try? container.decode(String.self, forKey: .url)) ?? ""
        self.attachList = (try? container.decode([ClubCommonModel_AttachList].self, forKey: .attachList)) ?? []
        self.openGraphDtoList = (try? container.decode([ClubCommonModel_OpenGraphDtoList].self, forKey: .openGraphDtoList)) ?? []
    }
}

/**
 * 북마크 결과
 */
struct ClubDetailModel_BookMark: Codable {
    let bookmarkYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bookmarkYn = (try? container.decode(Bool.self, forKey: .bookmarkYn)) ?? false
    }
}
