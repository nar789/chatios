//
//  CommonReplyModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct CommonReplyModel: Codable, Hashable {
    let replyId, parentReplyId, comPostId, activeStatus, depth, likeCnt, dislikeCnt, replyCnt: Int
    let integUid, content, langCode, userNick, createDate: String
    let userPhoto: String?
    let anonymYn, likeYn, dislikeYn, userBlockYn, pieceBlockYn: Bool
    let attachList: [CommonReplyModel_AttachList]
    let childReplyList: [CommonReplyModel]?
    let openGraphList: [CommonReplyModel_OpenGraphList]
}
struct CommonReplyModel_AttachList: Codable, Hashable {
    let attachType, id: String
}
struct CommonReplyModel_OpenGraphList: Codable, Hashable {
    let title, description, domain, url, image: String
}
