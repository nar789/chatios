//
//  CommunityDetailPageModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct CommunityDetailModel: Codable {
    let post: CommunityDetailModel_Post
}
struct CommunityDetailModel_Post: Codable {
    var postId, activeStatus, likeCnt, dislikeCnt, honorCnt, replyCnt: Int
    let code, subCode, title, content, integUid, langCode, userNick, userPhoto, createDate: String
    var anonymYn, likeYn, dislikeYn, userBlockYn, pieceBlockYn, bookmarkYn: Bool
}

struct CommunityDetailReplyModel: Codable {
    let listSize: Int
    let nextId: Int
    let reply: [CommonReplyModel]
}
//struct CommunityDetailReplyModel_Reply: Codable, Hashable {
//    let replyId, parentReplyId, comPostId, activeStatus, depth, likeCnt, dislikeCnt, replyCnt: Int
//    let integUid, content, langCode, userNick, userPhoto, createDate: String
//    let anonymYn, likeYn, dislikeYn, userBlockYn, pieceBlockYn: Bool
//    let attachList: [CommunityDetailReplyModel_Reply_AttachList]
//    let childReplyList: [CommunityDetailReplyModel_Reply_ChildReplyList]
//}
//struct CommunityDetailReplyModel_Reply_AttachList: Codable, Hashable {
//    let attachType, id: String
//}
//struct CommunityDetailReplyModel_Reply_ChildReplyList: Codable, Hashable {
//    let replyId, parentReplyId, comPostId, activeStatus, depth, likeCnt, dislikeCnt, replyCnt: Int
//    let integUid, content, langCode, userNick, createDate: String
//    let anonymYn, likeYn, dislikeYn, userBlockYn, pieceBlockYn: Bool
//    let attachList: [CommunityDetailReplyModel_Reply_ChildReplyList_AttachList]
//}
//struct CommunityDetailReplyModel_Reply_ChildReplyList_AttachList: Codable, Hashable {
//    let attachType, id: String
//}









/**
 * 아래는 더비 API용 Model 이다.
 * 팬투2.0 API 적용 후, 삭제할 것.
 */
struct CommunityDetailPageModel: Codable {
    let code: Int
    let data: CommunityDetailPageData
}
struct CommunityDetailPageData: Codable {
    let board_id, post_id, anonymous, use_notice, like_count, un_like_count, honor_count, story_count: Int
    let board_name, author_id, author_uid, author_nickname, author_profile, title, subject, contents, date: String
    //let post_thumbnail: [CommunityDetailPage_Thumbnail]
    let post_thumbnail: [Post_Thumbnail]
    let post_video: CommunityDetailPage_Video
    let my: CommunityDetailPage_My
    let tags: [String]
    //let comment: [CommunityDetailPage_Comment]
    let comment: [Comment_Community]
}
struct CommunityDetailPage_Thumbnail: Codable, Hashable {
    let type, url: String
}
struct CommunityDetailPage_Video: Codable {
    let video_url, video_thumbnail: String
}
struct CommunityDetailPage_My: Codable {
    let like_yn, honor_yn, club_join_yn, voting_yn, voting_pos, blind_yn, block_yn, favorite_yn: Int
}
struct CommunityDetailPage_Comment: Codable, Hashable {
    let id, comment_like_count: Int
    let content, image, createAt, updateAt, comment_uid, comment_nickname, comment_profile: String
    let recomment: [CommunityDetailPage_Comment_Recomment]
}
struct CommunityDetailPage_Comment_Recomment: Codable, Hashable {
    let id, comment_like_count: Int
    let content, image, createAt, updateAt, comment_uid, comment_nickname, comment_profile: String
}
