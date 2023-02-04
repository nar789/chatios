//
//  MyMenuMedel.swift
//  fantoo
//
//  Created by fns on 2022/09/20.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct MyInfoData: Codable {
    let birthDay: String?
    let cdate: String?
    let cellCode: String?
    let cellNum: String?
    let countryIsoTwo: String?
    let deviceId: String?
    let email: String?
    let fnsCoins: Int?
    let genderType: String?
    let integUid: String?
    let interestList: [MyInfointerestListData]
    let introduce: String?
    let langCode: String?
    let lastLoginDate: String?
    let loginId: String?
    let loginPwUpdate: String?
    let loginType: String?
    let pandroidToken: String?
    let piosToken: String?
    let referralCode: String?
    let sortStatus: String?
    let useReferralCode: String?
    let userName: String?
    let userNick: String?
    let userNickUpdate: String?
    let userPhoto: String?
}

struct MyInfointerestListData: Codable, Hashable {
    let code: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? container.decode(String.self, forKey: .code)) ?? ""
    }
}

struct MyInterestListData: Codable {
    let listSize: Int?
    let interestList: [InterestListCategoryData]
}
       
struct InterestListCategoryData: Codable, Hashable {
    var code: String
    let langCode: String
    let codeName: String
    let description: String
    let sort: Int
    let selectYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? container.decode(String.self, forKey: .code)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        codeName = (try? container.decode(String.self, forKey: .codeName)) ?? ""
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
        sort = (try? container.decode(Int.self, forKey: .sort)) ?? 0
        selectYn = (try? container.decode(Bool.self, forKey: .selectYn)) ?? false
    }
}

struct UserInfoUpdateData : Codable {
    let code: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? container.decode(Int.self, forKey: .code)) ?? 0
    }
}

struct InterestListData: Codable {
    let code: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? container.decode(String.self, forKey: .code)) ?? ""
    }
}

struct CheckPasswordData: Codable {
    let isMatchePw: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isMatchePw = (try? container.decode(Bool.self, forKey: .isMatchePw)) ?? false
    }
}


struct UserWalletData: Codable {
    let fanit: Int
    let kdg: Int
    let honor: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fanit = (try? container.decode(Int.self, forKey: .fanit)) ?? 0
        kdg = (try? container.decode(Int.self, forKey: .kdg)) ?? 0
        honor = (try? container.decode(Int.self, forKey: .honor)) ?? 0
    }
}

struct UserWalletTypeData: Codable {
    let listSize: Int?
    let nextId: Int?
    let walletList: [WalletListData]
}

struct WalletListData: Codable, Hashable {
    let comment: String
    let createDate: String
    let historyId: Int
    let monthAndDate: String
    let title: String
    let value: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        comment = (try? container.decode(String.self, forKey: .comment)) ?? ""
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        historyId = (try? container.decode(Int.self, forKey: .historyId)) ?? 0
        monthAndDate = (try? container.decode(String.self, forKey: .monthAndDate)) ?? ""
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        value = (try? container.decode(Int.self, forKey: .value)) ?? 0
    }
}

struct UserMenuStorageData: Codable {
    
    let postCnt: Int
    let replyCnt: Int
    let bookmarkCnt: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postCnt = (try? container.decode(Int.self, forKey: .postCnt)) ?? 0
        replyCnt = (try? container.decode(Int.self, forKey: .replyCnt)) ?? 0
        bookmarkCnt = (try? container.decode(Int.self, forKey: .bookmarkCnt)) ?? 0
    }
}

struct UserCommunityReplyData: Codable {
    let listSize: Int?
    let nextId: Int?
    let reply: [UserCommunityReplyListData]
}

struct UserCommunityReplyListData: Codable, Hashable  {
    let replyId: Int?
        let parentReplyId: Int?
        let comPostId: Int?
        let integUid: String?
        let content: String?
        let activeStatus: Int?
        let anonymYn: Bool?
        let depth: Int?
        let langCode: String?
        let likeCnt: Int?
        let dislikeCnt: Int?
        let replyCnt: Int?
        let likeYn: Bool?
        let dislikeYn: Bool?
        let userNick: String?
        let userPhoto: String?
        let postTitle: String?
        let code: String?
        let image: String?
        let userBlockYn: Bool?
        let pieceBlockYn: Bool?
        let attachList: [AttachListData]
        let createDate: String?
}

struct AttachListData: Codable, Hashable  {
    let attachType: String
    let id: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        attachType = (try? container.decode(String.self, forKey: .attachType)) ?? ""
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
    }
}


struct UserCommunityPostData: Codable {
    let listSize: Int?
    let nextId: Int?
    let post: [UserCommunityPostListData]
}

struct UserCommunityPostListData: Codable, Hashable  {
    let postId: Int
    let code: String
    let subCode: String
    let title: String
    let content: String
    let integUid: String
    let langCode: String
    let activeStatus: Int
    let likeCnt: Int
    let dislikeCnt: Int
    let honorCnt: Int
    let replyCnt: Int
    let anonymYn: Bool
    let userNick: String
    let userPhoto: String
    let categoryImage: String
    let likeYn: Bool
    let dislikeYn: Bool
    let createDate: String
    let bookmarkYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postId = (try? container.decode(Int.self, forKey: .postId)) ?? 0
        code = (try? container.decode(String.self, forKey: .code)) ?? ""
        subCode = (try? container.decode(String.self, forKey: .subCode)) ?? ""
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        content = (try? container.decode(String.self, forKey: .content)) ?? ""
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        activeStatus = (try? container.decode(Int.self, forKey: .activeStatus)) ?? 0
        likeCnt = (try? container.decode(Int.self, forKey: .likeCnt)) ?? 0
        dislikeCnt = (try? container.decode(Int.self, forKey: .dislikeCnt)) ?? 0
        honorCnt = (try? container.decode(Int.self, forKey: .honorCnt)) ?? 0
        replyCnt = (try? container.decode(Int.self, forKey: .replyCnt)) ?? 0
        anonymYn = (try? container.decode(Bool.self, forKey: .anonymYn)) ?? false
        userNick = (try? container.decode(String.self, forKey: .userNick)) ?? ""
        userPhoto = (try? container.decode(String.self, forKey: .userPhoto)) ?? ""
        categoryImage = (try? container.decode(String.self, forKey: .categoryImage)) ?? ""
        likeYn = (try? container.decode(Bool.self, forKey: .likeYn)) ?? false
        dislikeYn = (try? container.decode(Bool.self, forKey: .dislikeYn)) ?? false
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        bookmarkYn = (try? container.decode(Bool.self, forKey: .bookmarkYn)) ?? false
    }
}

struct UserCommunityBookmarkData: Codable {
    let listSize: Int?
    let nextId: Int?
    let post: [UserCommunityBookmarkListData]
}

struct UserCommunityBookmarkListData: Codable, Hashable  {
    let postId: Int
    let code: String
    let subCode: String
    let title: String
    let content: String
    let integUid: String
    let langCode: String
    let activeStatus: Int
    let likeCnt: Int
    let dislikeCnt: Int
    let honorCnt: Int
    let replyCnt: Int
    let anonymYn: Bool
    let userNick: String
    let userPhoto: String
    let categoryImage: String
    let likeYn: Bool
    let dislikeYn: Bool
    let userBlockYn: Bool
    let pieceBlockYn: Bool
    let createDate: String
    let bookmarkYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postId = (try? container.decode(Int.self, forKey: .postId)) ?? 0
        code = (try? container.decode(String.self, forKey: .code)) ?? ""
        subCode = (try? container.decode(String.self, forKey: .subCode)) ?? ""
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        content = (try? container.decode(String.self, forKey: .content)) ?? ""
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        activeStatus = (try? container.decode(Int.self, forKey: .activeStatus)) ?? 0
        likeCnt = (try? container.decode(Int.self, forKey: .likeCnt)) ?? 0
        dislikeCnt = (try? container.decode(Int.self, forKey: .dislikeCnt)) ?? 0
        honorCnt = (try? container.decode(Int.self, forKey: .honorCnt)) ?? 0
        replyCnt = (try? container.decode(Int.self, forKey: .replyCnt)) ?? 0
        anonymYn = (try? container.decode(Bool.self, forKey: .anonymYn)) ?? false
        userNick = (try? container.decode(String.self, forKey: .userNick)) ?? ""
        userPhoto = (try? container.decode(String.self, forKey: .userPhoto)) ?? ""
        categoryImage = (try? container.decode(String.self, forKey: .categoryImage)) ?? ""
        likeYn = (try? container.decode(Bool.self, forKey: .likeYn)) ?? false
        dislikeYn = (try? container.decode(Bool.self, forKey: .dislikeYn)) ?? false
        userBlockYn = (try? container.decode(Bool.self, forKey: .userBlockYn)) ?? false
        pieceBlockYn = (try? container.decode(Bool.self, forKey: .pieceBlockYn)) ?? false
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        bookmarkYn = (try? container.decode(Bool.self, forKey: .bookmarkYn)) ?? false
    }
}

struct referralCodeData : Codable, Hashable {
    let referralCode: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        referralCode = (try? container.decode(String.self, forKey: .referralCode)) ?? ""
    }
}
