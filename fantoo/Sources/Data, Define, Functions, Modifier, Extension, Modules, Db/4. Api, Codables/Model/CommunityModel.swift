//
//  TabCommunityModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/06/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

// Main Community - 카테고리
struct MainCommunity_Category: Codable {
    let listSize: Int
    let categoryList: [MainCommunity_Category_CategoryList]
}
struct MainCommunity_Category_CategoryList: Codable, Hashable {
    let code, codeNameKo, codeNameEn, categoryImage: String
    let depth, sort: Int
    var favorite: Bool
}

// Main Community - 공통, 전체 공지
struct MainCommunity_MainNotice: Codable {
    let listSize: Int
    let nextId: Int?
    let notice: [MainCommunity_MainNotice_NoticeList]
}
struct MainCommunity_MainNotice_NoticeList: Codable, Hashable {
    let postId: Int
    let title, userNick, userPhoto, createDate: String
    let topYn: Bool
}

// Main Community - 게시글
struct MainCommunity_Board: Codable {
    let hour: [Community_BoardItem]
    let week: [Community_BoardItem]
}

struct Community_BoardItem: Codable, Hashable {

    /**
     * 아래 주석처리한 코드와 같이, 옵셔널로 구분할 수도 있지만,
     * 만약 서버에서 응답값이 일방적으로 변경되거나 하면, 에러가 발생할 수 있기 때문에 안전하지 않은 거 같다.
     * 그래서 아래 적용한 코드와 같이, 디폴트값을 적용해줬음
     */
    
    
    /**
     * 비회원 / 회원 의 응답 값 차이는
     * 아래에서 옵셔널로 처리한 변수들이다.
     * 즉, 비회원도 동일한 모델을 사용하도록 하기 위해서 옵셔널로 적용했음.
     */
//    var postId, activeStatus, likeCnt, dislikeCnt, honorCnt, replyCnt: Int
//    let code, title, integUid, langCode, userNick, userPhoto, createDate: String
//    var anonymYn, likeYn, dislikeYn: Bool
//    let subCode, content, categoryImage: String?
//    let userBlockYn, pieceBlockYn, bookmarkYn, attachYn: Bool?
    
    var postId, activeStatus, likeCnt, dislikeCnt, honorCnt, replyCnt: Int
    var code, title, integUid, langCode, userNick, userPhoto, createDate, subCode, content, categoryImage: String
    var anonymYn, likeYn, dislikeYn, userBlockYn, pieceBlockYn, bookmarkYn, attachYn: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postId = (try? container.decode(Int.self, forKey: .postId)) ?? 0
        activeStatus = (try? container.decode(Int.self, forKey: .activeStatus)) ?? 0
        likeCnt = (try? container.decode(Int.self, forKey: .likeCnt)) ?? 0
        dislikeCnt = (try? container.decode(Int.self, forKey: .dislikeCnt)) ?? 0
        honorCnt = (try? container.decode(Int.self, forKey: .honorCnt)) ?? 0
        replyCnt = (try? container.decode(Int.self, forKey: .replyCnt)) ?? 0
        code = (try? container.decode(String.self, forKey: .code)) ?? ""
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        integUid = (try? container.decode(String.self, forKey: .integUid)) ?? ""
        langCode = (try? container.decode(String.self, forKey: .langCode)) ?? ""
        userNick = (try? container.decode(String.self, forKey: .userNick)) ?? ""
        userPhoto = (try? container.decode(String.self, forKey: .userPhoto)) ?? ""
        createDate = (try? container.decode(String.self, forKey: .createDate)) ?? ""
        subCode = (try? container.decode(String.self, forKey: .subCode)) ?? ""
        content = (try? container.decode(String.self, forKey: .content)) ?? ""
        categoryImage = (try? container.decode(String.self, forKey: .categoryImage)) ?? ""
        anonymYn = (try? container.decode(Bool.self, forKey: .anonymYn)) ?? false
        likeYn = (try? container.decode(Bool.self, forKey: .likeYn)) ?? false
        dislikeYn = (try? container.decode(Bool.self, forKey: .dislikeYn)) ?? false
        userBlockYn = (try? container.decode(Bool.self, forKey: .userBlockYn)) ?? false
        pieceBlockYn = (try? container.decode(Bool.self, forKey: .pieceBlockYn)) ?? false
        bookmarkYn = (try? container.decode(Bool.self, forKey: .bookmarkYn)) ?? false
        attachYn = (try? container.decode(Bool.self, forKey: .attachYn)) ?? false
    }
}

// 메인 커뮤니티 검색 목록
// 각 카테고리 게시판 목록
struct Community_List: Codable {
    let listSize, nextId: Int
    let post: [Community_BoardItem]
}







/**
 * 광고 서버에서 임시로 만든 API 모델 (fantoo api 적용 후 삭제할 것)
 */

// 카테고리 카테고리
struct MainCommunityCategory: Codable {
    let code: Int
    let data: [String]
}

// 카테고리 팬투 추천순 (회원)
struct CommunityCategoryFantooMember: Codable {
    let code: String
    let msg: String
    let dataObj: DataObj_CategoryFantooMember
}
struct DataObj_CategoryFantooMember: Codable {
    let categoryList: [CategoryList_CategoryFantooMember]
    let listSize: Int
}
struct CategoryList_CategoryFantooMember: Codable, Hashable {
    let code, codeNameKo, codeNameEn, categoryImage: String
    let depth, sort: Int
    let favorite: Bool
}

// 카테고리 인기순 (회원)
struct CommunityCategoryPopularMember: Codable {
    let code: String
    let msg: String
    let dataObj: DataObj_CategoryPopularMember
}
struct DataObj_CategoryPopularMember: Codable {
    let categoryList: [CategoryList_CategoryPopularMember]
    let size: Int
}
struct CategoryList_CategoryPopularMember: Codable, Hashable {
    let code, codeNameKo, codeNameEn: String
    let depth, sort: Int
}

// Sub 카테고리 (회원)
struct CommunitySubcategoryMember: Codable {
    let listSize: Int
    let category: Category_SubcategoryMember
    let categoryList: [CategoryList_SubcategoryMember]
}
struct Category_SubcategoryMember: Codable {
    let code, codeNameKo, codeNameEn: String
    let depth, sort: Int
    let favorite: Bool
}
struct CategoryList_SubcategoryMember: Codable, Hashable {
    let code, parentCode, codeNameKo, codeNameEn: String
    let depth, sort: Int
}

// 카테고리 팬투 추천순 (비회원)
struct CommunityCategoryFantooNonmember: Codable {
    let code: String
    let msg: String
    let dataObj: DataObj_CategoryFantooNonmember
}
struct DataObj_CategoryFantooNonmember: Codable {
    let categoryList: [CategoryList_CategoryFantooNonmember]
    let listSize: Int
}
struct CategoryList_CategoryFantooNonmember: Codable, Hashable {
    let code: String
    let codeNameKo: String
    let codeNameEn: String
    let depth: Int
    let sort: Int
}

// Sub 카테고리 (비회원)
struct CommunitySubcategoryNonmember: Codable {
    let code: String
    let msg: String
    let dataObj: DataObj_SubcategoryNonmember
}
struct DataObj_SubcategoryNonmember: Codable {
    let categoryList: [CategoryList_SubcategoryNonmember]
    let size: Int
}
struct CategoryList_SubcategoryNonmember: Codable, Hashable {
    let code: String
    let codeNameKo: String
    let codeNameEn: String
    let depth: Int
    let sort: Int
}

// 전체공지 TOP고정 List
// 전체공지 List (Paging)
struct Community_Notice: Codable {
    let listSize: Int
    let nextId: Int?
    let notice: [Community_Notice_List]
}
struct Community_Notice_List: Codable, Hashable {
    let postId: Int
    let title, userNick, langCode, userPhoto, createDate: String
    let topYn: Bool
}

// 커뮤니티 공지 Detail Page
struct CommunityNoticeDetail: Codable {
    let notice: CommunityNoticeDetail_Notice
    let attachList: [CommunityNoticeDetail_AttachList]
}
struct CommunityNoticeDetail_Notice: Codable {
    let postId: Int
    let title, content, userNick, langCode, userPhoto, createDate: String
    let topYn: Bool
}
struct CommunityNoticeDetail_AttachList: Codable, Hashable {
    let attachType, id: String
}


// 각 카테고리 공지
struct CommunityCategoryNotice: Codable {
    let code: String
    let msg: String
    let dataObj: DataObj_CategoryNotice
}
struct DataObj_CategoryNotice: Codable {
    let notice: [Notice_CategoryNotice]
    let size: Int
}
struct Notice_CategoryNotice: Codable, Hashable {
    let comNoticeId: Int
    let title: String
    let topYn: Bool
    let commentCnt: Int
    let userNick: String
    let userPhoto: String
    let createDate: String
}

// 실시간 이슈 TOP 5 - 주간 TOP 5
struct CommunityTopFive: Codable {
    let code: Int
    let data: Data_TopFive
}
struct Data_TopFive: Codable {
    let issueTop5: [CommunityBoardItem]
    let weekTop5: [CommunityBoardItem]
}
struct CommunityBoardItem: Codable, Hashable {
    let board_id: Int
    let board_name: String
    let author_id: String
    let author_uid: String
    let author_nickname: String
    let author_profile: String
    let post_id: Int
    let post_thumbnail: [Post_Thumbnail]
    let post_video: itemCardVideo
    let anonymous: Int
    let use_notice: Int
    let title: String
    let subject: String
    let contents: String
    let date: String
    let like_count: Int
    let un_like_count: Int
    let honor_count: Int
    let story_count: Int
    let my: My_TopFive
    let tags: [String]
    let comment: [Comment_Community]
}
struct My_TopFive: Codable, Hashable {
    let like_yn: Int
    let honor_yn: Int
    let club_join_yn: Int
    let voting_yn: Int
    let voting_pos: Int
    let blind_yn: Int
    let block_yn: Int
    let favorite_yn: Int
}
struct Comment_Community: Codable, Hashable {
    let id: Int
    let content: String
    let image: String
    let createAt: String
    let updateAt: String
    let comment_uid: String
    let comment_nickname: String
    let comment_profile: String
    let comment_like_count: Int
    let recomment: [Recomment_Community]
}
struct Recomment_Community: Codable, Hashable {
    let id: Int
    let content: String
    let image: String
    let createAt: String
    let updateAt: String
    let comment_uid: String
    let comment_nickname: String
    let comment_profile: String
    let comment_like_count: Int
}
