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

enum StorageType {
    case ComuPost
    case ComuReply
    case ComuBookmark
    case ClubPost
    case ClubReply
    case ClubBookmark
}


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
    
    @Published var clubStorageReplyData: ClubStorageReplyData?
    @Published var clubStorageReplyListData = [ClubStorageReplyListData]()
    
    @Published var clubStorageBookmarkData: ClubStorageBookmarkData?
    @Published var clubStorageBookmarkListData = [ClubStorageBookmarkListData]()
    
    @Published var clubStoragePostData: ClubStoragePostData?
    @Published var clubStoragePostListData = [ClubStoragePostListData]()
    
    
    @Published var currentTag: Int?
    
    var comuPostFetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    var comuReplyFetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    var comuBookmarkFetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    
    var clubPostFetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    var clubReplyFetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    var clubBookmarkFetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    
    @Published var postSuccess: Bool = false
    @Published var replySuccess: Bool = false
    @Published var bookmarkSuccess: Bool = false
    
    
    //MARK: - init
    
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
        
        clubPostFetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchMore(type: .ClubPost)
        }.store(in: &canclelables)
        
        clubReplyFetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchMore(type: .ClubReply)
        }.store(in: &canclelables)
        
        clubBookmarkFetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchMore(type: .ClubBookmark)
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
        else if type == .ClubPost {
            guard let nextPage = clubStoragePostData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.requestMyClubStoragePost(nextId: "\(nextPage)", size: "\(DefineSize.ListSize.Common)") { success in
                    
                }
            }
        }
        else if type == .ClubReply {
            guard let nextPage = clubStorageReplyData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.requestMyClubStorageReply(nextId: "\(nextPage)", size: "\(DefineSize.ListSize.Common)") { success in
                    
                }
                
            }
        }
        else if type == .ClubBookmark {
            guard let nextPage = clubStorageBookmarkData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.requestMyClubStorageBookmark(nextId: "\(nextPage)", size: "\(DefineSize.ListSize.Common)") { success in
                    
                }
            }
        }
    }
    
    func onMorePageLoading() {
        // 페이지 내에서 로딩
        StatusManager.shared.loadingStatus = .ShowWithTouchable
    }
    func offMorePageLoading() {
        // 로딩 종료
        StatusManager.shared.loadingStatus = .Close
    }
    
    
    //MARK: - Request
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
                self.replySuccess = true
                result(true)
                
                self.userCommunityReplyData = value
                guard let noUserCommunityReplyData = self.userCommunityReplyData else {
                    return
                }
                                
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
                self.postSuccess = true

                result(true)
                self.userCommunityPostData = value
                guard let noUserCommunityPostData = self.userCommunityPostData else {
                    return
                }
                                
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
                self.bookmarkSuccess = true

                result(true)
                
                self.userCommunityBookmarkData = value
                guard let noUserCommunityBookmarkData = self.userCommunityBookmarkData else {
                    return
                }
                
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
    
    func requestMyClubStorageReply(nextId: String, size: String, result:@escaping(Bool) -> Void) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.myClubStorageReply(integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("ClubStorageReply error : \(error)")
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                self.replySuccess = true

                result(true)
                
                self.clubStorageReplyData = value
                guard let noClubStorageReplyData = self.clubStorageReplyData else {
                    return
                }
                                
                // 첫 페이지만 해당 (페이징 X)
                if nextId == "" {
                    self.clubStorageReplyListData = noClubStorageReplyData.replyList
                }
                // 페이징으로 받아오는 데이터
                else {
                    self.clubStorageReplyListData.append(contentsOf: noClubStorageReplyData.replyList)
                }
                print("ClubStorageReply value : \(value)")
            }
            .store(in: &canclelables)
        
    }
    
    func requestMyClubStorageBookmark(nextId: String, size: String, result:@escaping(Bool) -> Void) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.myClubStorageBookmark(integUid: UserManager.shared.uid, nextId: nextId, size: size)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                
                print("ClubStorageBookmark error : \(error)")
            } receiveValue: { value in
                
                StatusManager.shared.loadingStatus = .Close
                self.bookmarkSuccess = true
                result(true)
                
                self.clubStorageBookmarkData = value
                guard let noClubStorageBookmarkData = self.clubStorageBookmarkData else {
                    return
                }
//                self.clubStorageBookmarkListData = noClubStorageBookmarkData.postList

                if nextId == "0" {
                    self.clubStorageBookmarkListData = noClubStorageBookmarkData.postList
                }
                // 페이징으로 받아오는 데이터
                else {
                    self.clubStorageBookmarkListData.append(contentsOf: noClubStorageBookmarkData.postList)
                }
                
                print("ClubStorageBookmark value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestMyClubStoragePost(nextId: String, size: String, result:@escaping(Bool) -> Void) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.myClubStoragePost(integUid: UserManager.shared.uid, nextId: nextId, size: size)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                
                print("ClubStoragePost error : \(error)")
            } receiveValue: { value in
                
                StatusManager.shared.loadingStatus = .Close
                self.postSuccess = true

                result(true)
                
                self.clubStoragePostData = value
                guard let noClubStoragePostData = self.clubStoragePostData else {
                    return
                }
//                self.clubStoragePostListData = noClubStoragePostData.postList
                if nextId == "" {
                    self.clubStoragePostListData = noClubStoragePostData.postList
                }
                // 페이징으로 받아오는 데이터
                else {
                    self.clubStoragePostListData.append(contentsOf: noClubStoragePostData.postList)
                }
                print("ClubStoragePost value : \(value)")
            }
            .store(in: &canclelables)
    }
}
