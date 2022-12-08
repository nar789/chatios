//
//  CommunityDetailPageViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class CommunityDetailPageViewModel: ObservableObject {
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    // 게시글 Detail (회원)
    @Published var communityDetailModel: CommunityDetailModel?
    @Published var communityDetail_Post: CommunityDetailModel_Post?
    // 게시글 댓글 List (회원)
    @Published var communityDetailReplyModel: CommunityDetailReplyModel?
    @Published var communityDetailReplyModel_Reply = [CommonReplyModel]()
    
    // 좋아요/싫어요
    @Published var community_Like: Community_Like?
    
    // 댓글 쓰기
    @Published var txtReply: String = ""
    @Published var isPostLoading: Bool = false
    @Published var postResultModel: ResultModel?
    // 댓글 작성 후, 리스트 밑으로 내리기
    @Published var isReplyComplete: Bool = false
    
    // 번역
    @Published var transData: TransData?
    @Published var transResultLists = [TransMessagesList]()
    @Published var isTransMode: Bool = false
    @Published var title_afterTrans: String = ""
    @Published var content_afterTrans: String = ""
    @Published var isTransFail: Bool = false
    
    
    /**
     * 게시글 Detail (회원)
     */
    func getCommunityDetail(integUid: String, access_token: String, code: String, postId: Int) {
        ApiControl.getCommunityDetail(integUid: integUid, access_token: access_token, code: code, postId: postId)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                
                self.communityDetailModel = value
                guard let NOcommunityDetailModel = self.communityDetailModel else {
                    // The 'value' is nil
                    return
                }
                
                self.communityDetail_Post = NOcommunityDetailModel.post
            }
            .store(in: &canclelables)
    }
    /**
     * 게시글 댓글 List (회원)
     */
    func getCommunityDetailReply(integUid: String, access_token: String, postId: Int, size: Int, isReplyWrite: Bool) {
        ApiControl.getCommunityDetailReply(integUid: integUid, access_token: access_token, postId: postId, size: size)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                
                self.communityDetailReplyModel = value
                guard let NOcommunityDetailReplyModel = self.communityDetailReplyModel else {
                    // The 'value' is nil
                    return
                }
                
                self.communityDetailReplyModel_Reply = NOcommunityDetailReplyModel.reply
                
                if isReplyWrite {
                    if self.communityDetailReplyModel_Reply.count > 0 {
                        self.isReplyComplete = true
                    }
                }
            }
            .store(in: &canclelables)
    }
    
    
    /**
     * 좋아요/싫어요
     */
    func postCommunityLike(likeType: String, targetType: String, targetId: Int, integUid: String, access_token: String, postId: Int, boardType: BoardType) {
        ApiControl.postCommunityLike(likeType: likeType, targetType: targetType, targetId: targetId, integUid: integUid, access_token: access_token)
            .sink { error in
                
            } receiveValue: { value in
                
                self.community_Like = value
                guard let NOcommunity_Like = self.community_Like else {
                    // The 'value' is nil
                    return
                }
                
                if var NOcommunityDetail_Post = self.communityDetail_Post {
                    
                    NOcommunityDetail_Post.likeCnt = NOcommunity_Like.like
                    NOcommunityDetail_Post.dislikeCnt = NOcommunity_Like.disLike

                    if likeType == "like" {
                        NOcommunityDetail_Post.likeYn.toggle()
                        NOcommunityDetail_Post.dislikeYn = false
                    } else if likeType == "dislike" {
                        NOcommunityDetail_Post.dislikeYn.toggle()
                        NOcommunityDetail_Post.likeYn = false
                    }
                    
                    /**
                     * 상세화면에서 변경된 결과를 바로 볼 수 있도록, self.communityDetail_Post 의 복사본(NOcommunityDetail_Post) 를 self.communityDetail_Post 에 적용해서, 업데이트 해줌
                     */
                    self.communityDetail_Post = NOcommunityDetail_Post
                    
                }
            }
            .store(in: &canclelables)
    }
    
    /**
     * 좋아요/싫어요 취소
     */
    func deleteCommunityLike(targetType: String, targetId: Int, integUid: String, access_token: String, postId: Int, boardType: BoardType) {
        ApiControl.deleteCommunityLike(targetType: targetType, targetId: targetId, integUid: integUid, access_token: access_token)
            .sink { error in
                
            } receiveValue: { value in
                
                self.community_Like = value
                guard let NOcommunity_Like = self.community_Like else {
                    // The 'value' is nil
                    return
                }
                
                if var NOcommunityDetail_Post = self.communityDetail_Post {
                    
                    NOcommunityDetail_Post.likeCnt = NOcommunity_Like.like
                    NOcommunityDetail_Post.dislikeCnt = NOcommunity_Like.disLike
                    NOcommunityDetail_Post.likeYn = false
                    NOcommunityDetail_Post.dislikeYn = false
                    
                    /**
                     * 상세화면에서 변경된 결과를 바로 볼 수 있도록, self.communityDetail_Post 의 복사본(NOcommunityDetail_Post) 를 self.communityDetail_Post 에 적용해서, 업데이트 해줌
                     */
                    self.communityDetail_Post = NOcommunityDetail_Post
                    
                }
            }
            .store(in: &canclelables)
    }
    
    
    
    /**
     * 댓글 글쓰기
     */
    func postReply(postId: Int, anonymYn: Bool, attachList: [CommonReplyModel_AttachList], content: String, integUid: String, access_token: String, isPostComplete: ((Bool) -> Void)?) {
        
        self.isPostLoading = true
        
        ApiControl.postCommunityReply(postId: postId, anonymYn: anonymYn, attachList: attachList, content: content, integUid: integUid, access_token: access_token)
            .sink { error in
                // 로딩 종료
                StatusManager.shared.loadingStatus = .Close
            } receiveValue: { value in
                
                self.postResultModel = value
                guard let NOpostResultModel = self.postResultModel else {
                    // The 'value' is nil
                    return
                }
                
                if NOpostResultModel.success {
                    // 로딩 종료
                    StatusManager.shared.loadingStatus = .Close
                    
                    guard let NOisPostComplete = isPostComplete else { return }
                    NOisPostComplete(true)
                }
            }
            .store(in: &canclelables)
    }
    
    // 북마크 등록/삭제 적용
    func completeBookmark() {
        if var NOcommunityDetail_Post = self.communityDetail_Post {
            NOcommunityDetail_Post.bookmarkYn.toggle()
            
            // UI 적용
            self.communityDetail_Post = NOcommunityDetail_Post
        }
    }
    
    /**
     * 북마크 등록
     */
    func postBookmark(postId: Int, integUid: String, access_token: String, isPostComplete: ((Bool) -> Void)?) {
        ApiControl.postCommunityBookmark(postId: postId, integUid: integUid, access_token: access_token)
            .sink { error in
                
            } receiveValue: { value in
                
                self.postResultModel = value
                guard let NOpostResultModel = self.postResultModel else {
                    // The 'value' is nil
                    return
                }
                
                if NOpostResultModel.success {
                    guard let NOisPostComplete = isPostComplete else { return }
                    NOisPostComplete(true)
                }
            }
            .store(in: &canclelables)
    }
    
    /**
     * 북마크 삭제
     */
    func deleteBookmark(postId: Int, integUid: String, access_token: String, isPostComplete: ((Bool) -> Void)?) {
        ApiControl.deleteCommunityBookmark(postId: postId, integUid: integUid, access_token: access_token)
            .sink { error in
                
            } receiveValue: { value in
                
                self.postResultModel = value
                guard let NOpostResultModel = self.postResultModel else {
                    // The 'value' is nil
                    return
                }
                
                if NOpostResultModel.success {
                    guard let NOisPostComplete = isPostComplete else { return }
                    NOisPostComplete(true)
                }
            }
            .store(in: &canclelables)
    }
    
    /**
     * 번역
     */
    func getTrans(language: String, messages: [TransMessagesReq]) {
        ApiControl.trans(language: language, messages: messages)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.transData = value
                guard let NOtransData = self.transData else {
                    // The 'value' is nil
                    return
                }
                
                if NOtransData.status == "success" {
                    self.transResultLists = NOtransData.messages
                    
                    guard let NObodyContent = self.communityDetail_Post else {
                        return
                    }
                    
                    for (index, element) in self.transResultLists.enumerated() {
                        
                        if index == 0, NObodyContent.title == element.origin {
                            self.title_afterTrans = element.text
                        }
                        else if index == 1, NObodyContent.content == element.origin {
                            self.content_afterTrans = element.text
                        }
                            }
                    
                    self.isTransMode = true
                }
                else {
                    // 번역 실패
                    self.isTransFail = true
                }
            }
            .store(in: &canclelables)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**
     * 아래는 더비 API용이다.
     * 팬투2.0 API 적용 후, 삭제할 것.
     */
    @Published var communityDetailPageModel: CommunityDetailPageModel?
    @Published var communityDetailPageData: CommunityDetailPageData?
    
    func getCommunityDetailPage() {
        ApiControl.getCommunityDetailPage()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.communityDetailPageModel = value
                guard let NOcommunityDetailPageModel = self.communityDetailPageModel else {
                    // The 'value' is nil
                    return
                }
                
                self.communityDetailPageData = NOcommunityDetailPageModel.data
            }
            .store(in: &canclelables)
    }
    
}
