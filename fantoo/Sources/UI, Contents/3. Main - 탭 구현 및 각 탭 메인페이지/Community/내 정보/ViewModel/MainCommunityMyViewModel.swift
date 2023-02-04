//
//  MainCommunityMyViewModel.swift
//  fantooUITests
//
//  Created by kimhongpil on 2022/07/23.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import CoreData

class MainCommunityMyViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    
    
    /**
     * 지울것
     */
    @Published var isPageLoading: Bool = false
    @Published var communityTopFive: CommunityTopFive?
    @Published var data_TopFive: Data_TopFive?
    @Published var issueTop5_listTopFive = [CommunityBoardItem]()
    
    
    
    
    
    
    
    
    
    
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var userCommunityReplyData: UserCommunityReplyData?
    @Published var userCommunityReplyListData = [UserCommunityReplyListData]()
    
    @Published var userCommunityPostData: UserCommunityPostData?
    @Published var userCommunityPostListData = [UserCommunityPostListData]()
    
    @Published var userCommunityBookmarkData: UserCommunityBookmarkData?
    @Published var userCommunityBookmarkListData = [UserCommunityBookmarkListData]()
    
    @Published var currentTag: Int?
    
    // 페이징
    var comuPostFetchMoreActionSubject = PassthroughSubject<(), Never>()
    var comuReplyFetchMoreActionSubject = PassthroughSubject<(), Never>()
    var comuBookmarkFetchMoreActionSubject = PassthroughSubject<(), Never>()
    
    
    init() {
        comuPostFetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchMore(type: .ComuPost)
        }.store(in: &canclelables)
        
        comuReplyFetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchMore(type: .ComuReply)
        }.store(in: &canclelables)
        
        comuBookmarkFetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchMore(type: .ComuBookmark)
        }.store(in: &canclelables)
    }
    
    fileprivate func fetchMore(type: StorageType) {
        
        if type == .ComuPost {
            guard let nextPage = userCommunityPostData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.requestUserCommunityStoragePost(nextId: nextPage, size: DefineSize.ListSize.Common) { success in
                    
                }
            }
        }
        else if type == .ComuReply {
            guard let nextPage = userCommunityReplyData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.requestUserCommunityStorageReply(nextId: nextPage, size: DefineSize.ListSize.Common) { success in
                    
                }
                
            }
        }
        else if type == .ComuBookmark {
            guard let nextPage = userCommunityBookmarkData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.requestUserCommunityStorageBookmark(nextId: nextPage, size: DefineSize.ListSize.Common) { success in
                    
                }
            }
        }
    }
    
    
    func requestUserCommunityStorageReply(nextId: Int, size: Int, result:@escaping(Bool) -> Void) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.userCommunityStorageReply(integUid: UserManager.shared.uid, nextId: nextId, size: size)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                
                print("userCommunityStorageReply error : \(error)")
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                result(true)
                
                self.userCommunityReplyData = value
                guard let noUserCommunityReplyData = self.userCommunityReplyData else {
                    return
                }
                
                print("listCount :\(noUserCommunityReplyData.reply.count)")
                
                // 첫 페이지만 해당 (페이징 X)
                if nextId == 0 {
                    self.userCommunityReplyListData = noUserCommunityReplyData.reply
                }
                // 페이징으로 받아오는 데이터
                else {
                    self.userCommunityReplyListData.append(contentsOf: noUserCommunityReplyData.reply)
                }
                
                print("userCommunityStorageReply value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestUserCommunityStoragePost(nextId: Int, size: Int, result:@escaping(Bool) -> Void) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.userCommunityStoragePost(integUid: UserManager.shared.uid, nextId: nextId, size: size)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("userCommunityStoragePost error : \(error)")
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                
                result(true)
                self.userCommunityPostData = value
                guard let noUserCommunityPostData = self.userCommunityPostData else {
                    return
                }
                
                print("listCount :\(noUserCommunityPostData.post.count)")
                
                // 첫 페이지만 해당 (페이징 X)
                if nextId == 0 {
                    self.userCommunityPostListData = noUserCommunityPostData.post
                }
                // 페이징으로 받아오는 데이터
                else {
                    self.userCommunityPostListData.append(contentsOf: noUserCommunityPostData.post)
                }
                print("userCommunityStoragePost value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestUserCommunityStorageBookmark(nextId: Int, size: Int, result:@escaping(Bool) -> Void) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.userCommunityStorageBookmark(integUid: UserManager.shared.uid, nextId: nextId, size: size)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                
                print("userCommunityStorageBookmark error : \(error)")
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                result(true)
                
                self.userCommunityBookmarkData = value
                guard let noUserCommunityBookmarkData = self.userCommunityBookmarkData else {
                    return
                }
                print("listCount :\(noUserCommunityBookmarkData.post.count)")
                
                // 첫 페이지만 해당 (페이징 X)
                if nextId == 0 {
                    self.userCommunityBookmarkListData = noUserCommunityBookmarkData.post
                }
                // 페이징으로 받아오는 데이터
                else {
                    self.userCommunityBookmarkListData.append(contentsOf: noUserCommunityBookmarkData.post)
                }
                print("userCommunityStorageBookmark value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    
    func onMorePageLoading() {
        // 페이지 내에서 로딩
        StatusManager.shared.loadingStatus = .ShowWithTouchable
    }
    func offMorePageLoading() {
        // 로딩 종료
        StatusManager.shared.loadingStatus = .Close
    }
    
    
    
    
    
    /**
     * 지울것
     */
    /**
     * 작성 글
     */
    func getMyBoardList() {
        // 로딩 시작
        self.isPageLoading = true

        ApiControl.getCommunitySearch()
            .sink { error in

            } receiveValue: { value in
                self.communityTopFive = value
                guard let NOcommunitySearch = self.communityTopFive else {
                    // The 'value' is nil
                    return
                }

                // 로딩 종료
                self.isPageLoading = false
                StatusManager.shared.loadingStatus = .Close

                self.data_TopFive = NOcommunitySearch.data
                guard let NOdata_TopFive = self.data_TopFive else {
                    return
                }
                self.issueTop5_listTopFive = NOdata_TopFive.issueTop5
            }
            .store(in: &canclelables)
    }

    /**
     * 작성 댓글
     */
    func getCommentList() {
        // 로딩 시작
        self.isPageLoading = true

        ApiControl.getCommunitySearch()
            .sink { error in

            } receiveValue: { value in
                self.communityTopFive = value
                guard let NOcommunitySearch = self.communityTopFive else {
                    // The 'value' is nil
                    return
                }

                // 로딩 종료
                self.isPageLoading = false
                StatusManager.shared.loadingStatus = .Close

                self.data_TopFive = NOcommunitySearch.data
                guard let NOdata_TopFive = self.data_TopFive else {
                    return
                }
                self.issueTop5_listTopFive = NOdata_TopFive.issueTop5
            }
            .store(in: &canclelables)
    }

    /**
     * 저장
     */
    func getLocalBoardList() {

    }
}
