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
    let integUid, userPhoto, content, langCode, userNick, createDate: String
    let anonymYn, likeYn, dislikeYn, userBlockYn, pieceBlockYn: Bool
    let attachList: [CommonReplyModel_AttachList]
    let childReplyList: [CommonReplyModel]
    let openGraphList: [CommonReplyModel_OpenGraphList]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        replyId = (try? container.decode(Int.self, forKey: .replyId)) ?? 0
        parentReplyId = (try? container.decode(Int.self, forKey: .parentReplyId)) ?? 0
        comPostId = (try? container.decode(Int.self, forKey: .comPostId)) ?? 0
        activeStatus = (try? container.decode(Int.self, forKey: .activeStatus)) ?? 0
        depth = (try? container.decode(Int.self, forKey: .depth)) ?? 0
        likeCnt = (try? container.decode(Int.self, forKey: .likeCnt)) ?? 0
        dislikeCnt = (try? container.decode(Int.self, forKey: .dislikeCnt)) ?? 0
        replyCnt = (try? container.decode(Int.self, forKey: .replyCnt)) ?? 0
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        userPhoto = (try? container.decode(String.self, forKey: .userPhoto)) ?? ""
        content = (try? container.decode(String.self, forKey: .content)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        userNick = (try? container.decode(String.self, forKey: .userNick)) ?? ""
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        anonymYn = (try? container.decode(Bool.self, forKey: .anonymYn)) ?? false
        likeYn = (try? container.decode(Bool.self, forKey: .likeYn)) ?? false
        dislikeYn = (try? container.decode(Bool.self, forKey: .dislikeYn)) ?? false
        userBlockYn = (try? container.decode(Bool.self, forKey: .userBlockYn)) ?? false
        pieceBlockYn = (try? container.decode(Bool.self, forKey: .pieceBlockYn)) ?? false
        attachList = (try? container.decode([CommonReplyModel_AttachList].self, forKey: .attachList)) ?? [CommonReplyModel_AttachList]()
        childReplyList = (try? container.decode([CommonReplyModel].self, forKey: .childReplyList)) ?? [CommonReplyModel]()
        openGraphList = (try? container.decode([CommonReplyModel_OpenGraphList].self, forKey: .openGraphList)) ?? [CommonReplyModel_OpenGraphList]()
    }
}
struct CommonReplyModel_AttachList: Codable, Hashable {
    let attachType, id: String
}
struct CommonReplyModel_OpenGraphList: Codable, Hashable {
    let title, description, domain, url, image: String
}
