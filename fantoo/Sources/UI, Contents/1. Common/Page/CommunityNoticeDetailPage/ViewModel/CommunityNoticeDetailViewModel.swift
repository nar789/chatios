//
//  CommunityNoticeDetailViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/11/03.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

enum CommunityNoticeDetailType: Int {
    case TotalNoticeDetail      // 전체공지 Detail
    case CategoryNoticeDetail   // 각 카테고리 Detail
}

class CommunityNoticeDetailViewModel: ObservableObject {
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    @Published var isAvailableVideo: Bool = false
    
    @Published var communityNoticeDetail: CommunityNoticeDetail?
    @Published var communityNoticeDetail_Notice: CommunityNoticeDetail_Notice?
    @Published var communityNoticeDetail_AttachList = [CommunityNoticeDetail_AttachList]()
    
    @Published var transData: TransData?
    @Published var transResultLists = [TransMessagesList]()
    @Published var isTransMode: Bool = false
    @Published var title_afterTrans: String = ""
    @Published var content_afterTrans: String = ""
    @Published var isTransFail: Bool = false
    
    
    func getCommunityNoticeDetail(type: CommunityNoticeDetailType, code: String?, postId: Int) {
        ApiControl.getCommunityNoticeDetail(type: type, code: code, postId: postId)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.communityNoticeDetail = value
                guard let NOcommunityNoticeDetail = self.communityNoticeDetail else {
                    // The 'value' is nil
                    return
                }
                
                self.communityNoticeDetail_Notice = NOcommunityNoticeDetail.notice
                self.communityNoticeDetail_AttachList = NOcommunityNoticeDetail.attachList
            }
            .store(in: &canclelables)
    }
    
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
                    
                    guard let NObodyContent = self.communityNoticeDetail_Notice else {
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
    
    
}
