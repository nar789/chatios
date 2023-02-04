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
    
enum ClubStorageType {
    case ClubPost
    case ClubReply
    case ClubBookmark
}

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
    
    @Published var clubId: String = ""
    @Published var memberId: Int = 0
    
    var clubPostFetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    var clubReplyFetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    var clubBookmarkFetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    
    //MARK: - init
    
    init() {
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
    
    fileprivate func fetchMore(type: ClubStorageType) {
        if type == .ClubPost {
            guard let nextPage = clubStoragePostData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.requestMyClubStoragePost(clubId: self.clubId, memberId: "\(self.memberId)", nextId: "\(nextPage)", size: "\(DefineSize.ListSize.Common)") { success in
                    if success {
                        
                    }
                }
            }
        }
        else if type == .ClubReply {
            guard let nextPage = clubStorageReplyData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.requestMyClubStorageReply(clubId: self.clubId, memberId: "\(self.memberId)", nextId: "\(nextPage)", size: "\(DefineSize.ListSize.Common)") { success in

                }
                
            }
        }
        else if type == .ClubBookmark {
            guard let nextPage = clubStorageBookmarkData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.requestMyClubStorageBookmark(clubId: self.clubId, memberId: "\(self.memberId)", nextId: "\(nextPage)", size: "\(DefineSize.ListSize.Common)") { success in
                    
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
    
    
    func requestMyClubStorageBookmark(clubId: String, memberId: String, nextId: String, size: String, result:@escaping(Bool) -> Void) {
        
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubMemberBookmarkList(clubId: clubId, integUid: UserManager.shared.uid, memberId: memberId, nextId: nextId, size: size)
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
                
                // 첫 페이지만 해당 (페이징 X)
                if nextId == "" {
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
    
    func requestMyClubStoragePost(clubId: String, memberId: String, nextId: String, size: String, result:@escaping(Bool) -> Void) {
        
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubMemberPostList(clubId: clubId, integUid: UserManager.shared.uid, memberId: memberId, nextId: nextId, size: size)
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

                // 첫 페이지만 해당 (페이징 X)
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
    
    func requestMyClubStorageReply(clubId: String, memberId: String, nextId: String, size: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubMemberReplyList(clubId: clubId, integUid: UserManager.shared.uid, memberId: memberId, nextId: nextId, size: size)
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
}
