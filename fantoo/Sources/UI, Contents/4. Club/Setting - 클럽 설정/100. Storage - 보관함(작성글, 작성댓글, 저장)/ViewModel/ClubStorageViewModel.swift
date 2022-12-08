//
//  ClubStorageViewModel.swift
//  fantoo
//
//  Created by fns on 2022/11/07.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ClubStorageViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = false
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var clubStorageReplyData: ClubStorageReplyData?
    @Published var clubStorageReplyListData = [ClubStorageReplyListData]()
    
    @Published var clubStorageBookmarkData: ClubStorageBookmarkData?
    @Published var clubStorageBookmarkListData = [ClubStorageBookmarkListData]()
    
    @Published var clubStoragePostData: ClubStoragePostData?
    @Published var clubStoragePostListData = [ClubStoragePostListData]()
    
    func requestMyClubStorageBookmark(result:@escaping(Bool) -> Void) {
        
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubStorageBookmark(integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                
                print("ClubStorageBookmark error : \(error)")
            } receiveValue: { value in
                
                self.loadingStatus = .Close
                result(true)
                
                self.clubStorageBookmarkData = value
                guard let noClubStorageBookmarkData = self.clubStorageBookmarkData else {
                    return
                }
                self.clubStorageBookmarkListData = noClubStorageBookmarkData.postList
                
                print("ClubStorageBookmark value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestMyClubStoragePost(result:@escaping(Bool) -> Void) {
        
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubStoragePost(integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                
                print("ClubStoragePost error : \(error)")
            } receiveValue: { value in
                
                self.loadingStatus = .Close
                result(true)
                
                self.clubStoragePostData = value
                guard let noClubStoragePostData = self.clubStoragePostData else {
                    return
                }
                self.clubStoragePostListData = noClubStoragePostData.postList
                
                print("ClubStoragePost value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestMyClubStorageReply(result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubStorageReply(integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("ClubStorageReply error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                result(true)

                self.clubStorageReplyData = value
                guard let noClubStorageReplyData = self.clubStorageReplyData else {
                    return
                }
                self.clubStorageReplyListData = noClubStorageReplyData.replyList
                
                print("ClubStorageReply value : \(value)")
            }
            .store(in: &canclelables)
    }
}
