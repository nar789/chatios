//
//  MyClubModel.swift
//  fantoo
//
//  Created by fns on 2022/10/04.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct ClubBasicData: Codable {
    let clubId: Int
     let clubName: String
     let memberCountOpenYn: Bool
     let memberListOpenYn: Bool
     let interestCategoryId: String
     let createDate: String
     let profileImg: String
     let bgImg: String
     let memberCount: Int
     let clubMasterNickname: String
     let visitDate: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
        memberCountOpenYn = (try? container.decode(Bool.self, forKey: .memberCountOpenYn)) ?? false
        memberListOpenYn = (try? container.decode(Bool.self, forKey: .memberListOpenYn)) ?? false
        interestCategoryId = (try? container.decode(String.self, forKey: .interestCategoryId)) ?? ""
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        bgImg = (try? container.decode(String.self, forKey: .bgImg)) ?? ""
        memberCount = (try? container.decode(Int.self, forKey: .memberCount)) ?? 0
        clubMasterNickname = (try? container.decode(String.self, forKey: .clubMasterNickname)) ?? ""
        visitDate = (try? container.decode(String.self, forKey: .visitDate)) ?? ""
    }
}

struct MyClubListData: Codable {
    let clubCount: Int?
    let clubList: [ClubListData]
    let listSize: Int?
    let favoriteYn: Bool?
    let nextId: String?
}

struct MyClubBasicListData: Codable {
//      let clubCount: Int?
      let clubList: [ClubBasicListData]
      let favoriteYn: Bool?
      let listSize: Int?
      let nextId: String?
}


struct ClubBasicListData: Codable {
//      let activeCountryCode: String?
//      let bgImg: String?
      let clubId: Int
//      let clubMasterNickname: String?
      let clubName: String
//      let createDate: String?
      var favoriteYn: Bool
//      let hashtagList: [String?]
//      let interestCategoryId: Int?
//      let introduction: String?
//      let joinMemberCount: Int?
//      let languageCode: String?
      let memberCount: Int
//      let memberCountOpenYn: Bool?
//      let memberJoinAutoYn: Bool?
//      let memberListOpenYn: Bool?
      let openYn: Bool
//      let postCount: Int?
      let profileImg: String
//      let visitDate: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
        favoriteYn = (try? container.decode(Bool.self, forKey: .favoriteYn)) ?? false
        memberCount = (try? container.decode(Int.self, forKey: .memberCount)) ?? 0
        openYn = (try? container.decode(Bool.self, forKey: .openYn)) ?? false
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
    }
    
}

struct MyClubCountData: Codable {
    let clubCount: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubCount = (try? container.decode(Int.self, forKey: .clubCount)) ?? 0
    }
}


struct MyClubFavoriteData: Codable {
    let favoriteYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        favoriteYn = (try? container.decode(Bool.self, forKey: .favoriteYn)) ?? false
    }
}


struct ClubListData: Codable, Hashable {
    let clubId: Int
    let clubName: String
    let openYn: Bool
    let profileImg: String
    let memberCount: Int
    var favoriteYn: Bool
    let visitDate: String
    let manageYn: Bool

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
        openYn = (try? container.decode(Bool.self, forKey: .openYn)) ?? false
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        memberCount = (try? container.decode(Int.self, forKey: .memberCount)) ?? 0
        favoriteYn = (try? container.decode(Bool.self, forKey: .favoriteYn)) ?? false
        visitDate = (try? container.decode(String.self, forKey: .visitDate)) ?? ""
        manageYn = (try? container.decode(Bool.self, forKey: .manageYn)) ?? false

    }
}

struct ClubStorageCountData: Codable, Hashable {
    let postCount: Int
    let replyCount: Int
    let bookmarkCount: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postCount = (try? container.decode(Int.self, forKey: .postCount)) ?? 0
        replyCount = (try? container.decode(Int.self, forKey: .replyCount)) ?? 0
        bookmarkCount = (try? container.decode(Int.self, forKey: .bookmarkCount)) ?? 0
    }
}

struct ClubStorageReplyData: Codable {
    let replyList: [ClubStorageReplyListData]
    let listSize: Int?
    let nextId: String?
}

struct ClubStorageReplyListData: Codable, Hashable {
    
    let attachList: [ClubStorageAttachListData?]
    
    let blockType: Int?
    let categoryCode: String?
    let categoryName1: String?
    let categoryName2: String?
    let clubId: String?
    let clubName: String?
    let content: String?
    let createDate: String?
    let deleteType: Int?
    let depth: Int?
    let integUid: String?
    let langCode: String?
    let level: Int?
    let like: ClubStoragePostLikeData?
    
    let memberId: Int?
    let nickname: String?
    let parentReplyId: Int?
    let postId: Int?
    let profileImg: String?
    let replyCount: Int?
    let replyId: Int?
    let status: Int?
    let subject: String?
    let updateDate: String?
    let url: String?
}

struct ClubStorageBookmarkData: Codable {
    let postList: [ClubStorageBookmarkListData]
    let listSize: Int?
    let nextId: Int?
}

struct ClubStorageBookmarkListData: Codable, Hashable {
    let postId: Int?
    let clubId: String?
    let memberId: Int?
    let categoryCode: String?
    let subject: String?
    let createDate: String?
    let replyCount: Int?
    let nickname: String?
    let url: String?
    let categoryName1: String?
    let categoryName2: String?
    let profileImg: String?
    let honor: ClubStorageHonorData?
    let boardType: Int?
    let clubName: String?
    let attachType: Int?
    let deleteType: Int?
    
//    let attachList: [ClubStorageAttachListData?]
//    let postId: Int?
//    let clubId: Int?
//    let memberId: Int?
//    let categoryCode: String?
//    let subject: String?
//    let createDate: String?
//    let replyCount: Int?
//    let honorCount: Int?
//    let nickname: String?
//    let url: String?
//    let memberUrl: String?
//    let codeNameKo1: String?
//    let codeNameEn1: String?
//    let codeNameKo2: String?
//    let codeNameEn2: String?
//    let profileImg: String?
//    let honor: ClubStorageHonorData?
//    let boardType1: Int?
//    let boardType2: Int?
//    let clubName: String?
//    let attachType: Int?
//    let blockType: String?
//    let bookmarkId: Int?
//    let content: String?
//    let deleteType: Int?
//    let dislikeCount: Int?
//    let firstImage: String?
//    let hashtagList: [String?]
//    let integUid: String?
//    let langCode: String
//    let like: ClubStoragePostLikeData?
//    let likeCount: Int?
//    let memberLevel: Int?
//    let status: Int?
}

struct ClubStorageHonorData: Codable, Hashable {
    let honorYn: Bool
    let honorCount: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        honorYn = (try? container.decode(Bool.self, forKey: .honorYn)) ?? false
        honorCount = (try? container.decode(Int.self, forKey: .honorCount)) ?? 0
    }
}

struct ClubStoragePostData: Codable {
    let listSize: Int?
    let nextId: Int?
    let postList: [ClubStoragePostListData]
}

struct ClubStoragePostListData: Codable, Hashable {
        let postId: Int?
        let clubId: String?
        let memberId: Int?
        let categoryCode: String?
        let subject: String?
        let createDate: String?
        let replyCount: Int?
        let honorCount: Int?
        let nickname: String?
        let url: String?
        let memberUrl: String?
        let categoryName1: String?
        let categoryName2: String?
        let status: Int?
        let profileImg: String?
        let like: ClubStoragePostLikeData?
        let honor: ClubStorageHonorData?
        let boardType: Int?
        let clubName: String?
        let firstImage: String?
        let attachType: Int?
        let deleteType: Int?
    
    
//    let attachList: [ClubStorageAttachListData?]
//    let attachType : Int?
//    let blockType : Int?
//    let boardType : Int?
//    let categoryCode : String?
//    let categoryName1 : String?
//    let categoryName2 : String?
//    let clubId : String?
//    let clubName : String?
//    let content : String?
//    let createDate : String?
//    let deleteType : Int?
//    let firstImage : String?
//    let hashtagList : [String?]
//    let honor : ClubStorageHonorData?
//    let integUid : String?
//    let langCode : String?
//    let like : ClubStoragePostLikeData?
//    let link : String?
//    let memberId : Int?
//    let memberLevel : Int?
//    let nickname : String?
//    let postId : Int?
//    let profileImg : String?
//    let replyCount : Int?
//    let status : Int?
//    let subject : String?
//    let url : String?
}

struct ClubStorageAttachListData: Codable, Hashable {
    let attach: String
    let attachId: Int
    let attachType: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        attach = (try? container.decode(String.self, forKey: .attach)) ?? ""
        attachId = (try? container.decode(Int.self, forKey: .attachId)) ?? 0
        attachType = (try? container.decode(Int.self, forKey: .attachType)) ?? 0
    }
}

struct ClubStoragePostLikeData: Codable, Hashable {
    let dislikeCount: Int
    let dislikeYn: Bool
    let likeCount: Int
    let likeYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dislikeCount = (try? container.decode(Int.self, forKey: .dislikeCount)) ?? 0
        dislikeYn = (try? container.decode(Bool.self, forKey: .dislikeYn)) ?? false
        likeCount = (try? container.decode(Int.self, forKey: .likeCount)) ?? 0
        likeYn = (try? container.decode(Bool.self, forKey: .likeYn)) ?? false
    }
}

struct ClubMemberData: Codable {
    let listSize: Int?
    let memberCount: Int?
    let memberList: [ClubMemberListData]
    let nextId: Int?
    let totalMemberCount: Int?
    
}

struct ClubMemberListData: Codable, Hashable {
    let createDate: String
    let integUid: String
    let joinDate: String
    let memberId: Int
    let memberLevel: Int
    let nickname: String
    let nicknameChangeDate: String
    let profileImg: String
    let visitDate: String
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        joinDate = (try? container.decode(String.self, forKey: .joinDate)) ?? ""
        memberId = (try? container.decode(Int.self, forKey: .memberId)) ?? 0
        memberLevel = (try? container.decode(Int.self, forKey: .memberLevel)) ?? 0
        nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        nicknameChangeDate = (try? container.decode(String.self, forKey: .nicknameChangeDate)) ?? ""
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        visitDate = (try? container.decode(String.self, forKey: .visitDate)) ?? ""
    }
}

struct ClubMemberFollowData: Codable {
    let followCount: Int
    let followYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        followCount = (try? container.decode(Int.self, forKey: .followCount)) ?? 0
        followYn = (try? container.decode(Bool.self, forKey: .followYn)) ?? false
    }
}

struct ClubMemberDetailData: Codable {

    let createDate: String
    let integUid: String
    let joinDate: String
    let memberId: Int
    let memberLevel: Int
    let nickname: String
    let nicknameChangeDate: String
    let profileImg: String
    let visitDate: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        joinDate = (try? container.decode(String.self, forKey: .joinDate)) ?? ""
        memberId = (try? container.decode(Int.self, forKey: .memberId)) ?? 0
        memberLevel = (try? container.decode(Int.self, forKey: .memberLevel)) ?? 0
        nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        nicknameChangeDate = (try? container.decode(String.self, forKey: .nicknameChangeDate)) ?? ""
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        visitDate = (try? container.decode(String.self, forKey: .visitDate)) ?? ""
    }
}

struct ClubMemberNicknameCheckData: Codable {
    let checkToken: String
    let existYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        checkToken = (try? container.decode(String.self, forKey: .checkToken)) ?? ""
        existYn = (try? container.decode(Bool.self, forKey: .existYn)) ?? false
    }
}

struct ClubManageData: Codable {

    let clubId: Int
    let clubName: String
    let openYn: Bool
    let createDate: String
    let profileImg: String
    let bgImg: String
    let memberCount: Int
    let postCount: Int
    let joinMemberCount: Int
    let clubMasterNickname: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        clubName = (try? container.decode(String.self, forKey: .clubName)) ?? ""
        openYn = (try? container.decode(Bool.self, forKey: .openYn)) ?? false
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        bgImg = (try? container.decode(String.self, forKey: .bgImg)) ?? ""
        memberCount = (try? container.decode(Int.self, forKey: .memberCount)) ?? 0
        postCount = (try? container.decode(Int.self, forKey: .postCount)) ?? 0
        joinMemberCount = (try? container.decode(Int.self, forKey: .joinMemberCount)) ?? 0
        clubMasterNickname = (try? container.decode(String.self, forKey: .clubMasterNickname)) ?? ""

    }
}

struct ClubJoinMemberData: Codable {

    let joinList: [ClubJoinListData]
    let listSize: Int?
    let nextId: Int?

}

struct ClubJoinListData: Codable, Hashable, Identifiable {
    var id = UUID()
    let createDate: String
    let joinId: Int
    let nickname: String
    let profileImg: String
    var isSelected: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        joinId = (try? container.decode(Int.self, forKey: .joinId)) ?? 0
        nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        isSelected = (try? container.decode(Bool.self, forKey: .isSelected)) ?? false
    }
}

struct ClubWithdrawMemberData: Codable {
    let withdrawList: [ClubWithdrawListData]
    let listSize: Int?
    let nextId: Int?
}

struct ClubWithdrawListData: Codable, Hashable, Identifiable {
    var id = UUID()
    let clubId: Int
    let clubWithdrawId: Int
//    let createDate: String
    let integUid: String
    let joinYn: Bool
    let nickname: String
//    let updateDate: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clubId = (try? container.decode(Int.self, forKey: .clubId)) ?? 0
        clubWithdrawId = (try? container.decode(Int.self, forKey: .clubWithdrawId)) ?? 0
//        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        joinYn = (try? container.decode(Bool.self, forKey: .joinYn)) ?? false
        nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
//        updateDate = (try? container.decode(String.self, forKey: .updateDate)) ?? ""
    }
}

struct ClubMemberCountData: Codable {
    let memberCount: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        memberCount = (try? container.decode(Int.self, forKey: .memberCount)) ?? 0
    }
}

struct ClubDelegateMemberData: Codable {
    
    //    let memberId: Int
    //      let nickname: String
    //      let nicknameChangeDate: String
    //      let profileImg: String
    //      let delegateRequestDate: String
    //      let delegateOkDate: String
    //      let delegateStatus: Int
    //
    //    init(from decoder: Decoder) throws {
    //        let container = try decoder.container(keyedBy: CodingKeys.self)
    //        memberId = (try? container.decode(Int.self, forKey: .memberId)) ?? 0
    //        nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
    //        nicknameChangeDate = (try? container.decode(String.self, forKey: .nicknameChangeDate)) ?? ""
    //        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
    //        delegateRequestDate = (try? container.decode(String.self, forKey: .delegateRequestDate)) ?? ""
    //        delegateOkDate = (try? container.decode(String.self, forKey: .delegateOkDate)) ?? ""
    //        delegateStatus = (try? container.decode(Int.self, forKey: .delegateStatus)) ?? 0
    //
    //    }
    
    let createDate: String
    let delegateCompleteDate: String
    let delegateOkDate: String
    let delegateRequestDate: String
    let delegateStatus: Int
    let expectCancelDate: String
    let expectCompleteDate: String
    let integUid: String
    let joinDate: String
    let joinStatus: Int
    let memberId: Int
    let memberLevel: Int
    let nickname: String
    let nicknameChangeDate: String
    let profileImg: String
    let visitDate: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        delegateCompleteDate = (try? container.decode(String.self, forKey: .delegateCompleteDate)) ?? ""
        delegateOkDate = (try? container.decode(String.self, forKey: .delegateOkDate)) ?? ""
        delegateRequestDate = (try? container.decode(String.self, forKey: .delegateRequestDate)) ?? ""
        delegateStatus = (try? container.decode(Int.self, forKey: .delegateStatus)) ?? 0
        expectCancelDate = (try? container.decode(String.self, forKey: .expectCancelDate)) ?? ""
        expectCompleteDate = (try? container.decode(String.self, forKey: .expectCompleteDate)) ?? ""
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        joinDate = (try? container.decode(String.self, forKey: .joinDate)) ?? ""
        joinStatus = (try? container.decode(Int.self, forKey: .joinStatus)) ?? 0
        memberId = (try? container.decode(Int.self, forKey: .memberId)) ?? 0
        memberLevel = (try? container.decode(Int.self, forKey: .memberLevel)) ?? 0
        nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        nicknameChangeDate = (try? container.decode(String.self, forKey: .nicknameChangeDate)) ?? ""
        profileImg = (try? container.decode(String.self, forKey: .profileImg)) ?? ""
        visitDate = (try? container.decode(String.self, forKey: .visitDate)) ?? ""
    }
    
}

struct ClubBlockMemberData: Codable {
    let blockYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        blockYn = (try? container.decode(Bool.self, forKey: .blockYn)) ?? false
    }
}

struct MyClubStorageReplyData: Codable {
    let replyList: [MyClubStorageReplyListData]
    let listSize: Int?
    let nextId: String?
}

struct MyClubStorageReplyListData: Codable, Hashable {
    
//    let replyId: Int?
//    let parentReplyId: Int?
//    let postId: Int?
//    let clubId: String?
//    let memberId: Int?
//    let content: String?
//    let createDate: String?
//    let attachList: [ClubStorageAttachListData?]
//    let replyCount: Int?
//    let nickname: String?
//    let status: Int?
//    let profileImg: String?
//    let like: ClubStoragePostLikeData?
//    let clubName: String?
//    let subject: String?
//    let categoryCode: String?
//    let deleteType: Int?
//    let categoryName1: String?
//    let categoryName2: String?
//    let langCode: String?
//    let level: Int?
//    let depth: Int?
    
    
    let replyId: Int?
         let parentReplyId: Int?
         let postId: Int?
         let clubId: String?
         let memberId: Int?
         let content: String?
         let langCode: String?
         let createDate: String?
         let attachList: [ClubStorageAttachListData?]
         let replyCount: Int?
         let nickname: String?
         let level: Int?
         let status: Int?
         let depth: Int?
         let profileImg: String?
         let clubName: String?
         let categoryCode: String?
         let deleteType: Int?
         let categoryName1: String?
         let categoryName2: String?
}
