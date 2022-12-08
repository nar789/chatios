//
//  ReplyDetailViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class ReplyDetailViewModel: ObservableObject {
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    // 게시글 댓글 상세 List (회원)
    @Published var communityDetailReplyDetailModel: CommunityDetailReplyModel?
    @Published var communityDetailReplyDetailModel_Reply = [CommonReplyModel]()
    
    /**
     * 게시글 댓글 상세 List (회원)
     */
    func getCommunityDetailReplyDetail(integUid: String, access_token: String, postId: Int, replyId: Int) {
        ApiControl.getCommunityDetailReplyDetail(integUid: integUid, access_token: access_token, postId: postId, replyId: replyId)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                
                self.communityDetailReplyDetailModel = value
                guard let NOcommunityDetailReplyDetailModel = self.communityDetailReplyDetailModel else {
                    // The 'value' is nil
                    return
                }
                
                self.communityDetailReplyDetailModel_Reply = NOcommunityDetailReplyDetailModel.reply
            }
            .store(in: &canclelables)
    }
}
