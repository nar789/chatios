//
//  MyStorageViewModel.swift
//  fantooUITests
//
//  Created by fns on 2022/10/26.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
//UserCommunityReplyListData
import Foundation
import Combine
import SwiftUI

class MyStorageViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = false
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var userCommunityReplyData: UserCommunityReplyData?
    @Published var userCommunityReplyListData = [UserCommunityReplyListData]()
    
    @Published var userCommunityPostData: UserCommunityPostData?
    @Published var userCommunityPostListData = [UserCommunityPostListData]()
    
    @Published var userCommunityBookmarkData: UserCommunityBookmarkData?
    @Published var userCommunityBookmarkListData = [UserCommunityBookmarkListData]()
    
    
    //MARK: - Request
    func requestUserCommunityStorageReply(result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.userCommunityStorageReply(integUid: UserManager.shared.uid, nextId: 0, size: 10)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)

                print("userCommunityStorageReply error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                result(true)

                self.userCommunityReplyData = value
                guard let noUserCommunityReplyData = self.userCommunityReplyData else {
                    return
                }
                self.userCommunityReplyListData = noUserCommunityReplyData.reply
               
                print("userCommunityStorageReply value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestUserCommunityStoragePost(result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.userCommunityStoragePost(integUid: UserManager.shared.uid, nextId: 0, size: 10)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("userCommunityStoragePost error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                result(true)
                self.userCommunityPostData = value
                guard let noUserCommunityPostData = self.userCommunityPostData else {
                    return
                }
                self.userCommunityPostListData = noUserCommunityPostData.post

                print("userCommunityStoragePost value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestUserCommunityStorageBookmark(result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.userCommunityStorageBookmark(integUid: UserManager.shared.uid, nextId: 0, size: 10)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)

                print("userCommunityStorageBookmark error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                result(true)

                self.userCommunityBookmarkData = value
                guard let noUserCommunityBookmarkData = self.userCommunityBookmarkData else {
                    return
                }
                self.userCommunityBookmarkListData = noUserCommunityBookmarkData.post
               
                print("userCommunityStorageBookmark value : \(value)")
            }
            .store(in: &canclelables)
    }
}
