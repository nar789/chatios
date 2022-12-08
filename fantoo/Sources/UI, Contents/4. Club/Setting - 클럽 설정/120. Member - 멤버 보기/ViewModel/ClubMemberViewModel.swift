//
//  ClubMemberViewModel.swift
//  fantoo
//
//  Created by fns on 2022/11/17.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine


class ClubMemberViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var clubMemberData: ClubMemberData?
    @Published var clubMemberListData = [ClubMemberListData]()
    
    @Published var clubStorageMemberPostData: ClubStoragePostData?
    @Published var clubStorageMemberPostListData = [ClubStoragePostListData]()
    
    @Published var clubStorageMemberReplyData: ClubStorageReplyData?
    @Published var clubStorageMemberReplyListData = [ClubStorageReplyListData]()
    
    @Published var blockYn: Bool = false

    
    func myClubMemberPostList(memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubMemberPostList(clubId: "58", integUid: UserManager.shared.uid, memberId: memberId, nextId: "1", size: "10")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberPostList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.clubStorageMemberPostData = value
                guard let noClubStorageMemberPostData = self.clubStorageMemberPostData else {
                    return
                }
                self.clubStorageMemberPostListData = noClubStorageMemberPostData.postList
                
                print("ClubMemberPostList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func myClubMemberReplyList(memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubMemberReplyList(clubId: "58", integUid: UserManager.shared.uid, memberId: memberId, nextId: "1", size: "10")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberReplyList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.clubStorageMemberReplyData = value
                guard let noClubStorageMemberReplyData = self.clubStorageMemberReplyData else {
                    return
                }
                self.clubStorageMemberReplyListData = noClubStorageMemberReplyData.replyList
                
                print("ClubMemberReplyList value : \(value)")
            }
            .store(in: &canclelables)
        
    }
    
    func requestClubBlockCheck(memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubBlockCheck(clubId: "64", memberId: memberId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubBlockCheck error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.blockYn = value.blockYn
                print("ClubBlockCheck value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    
    func requestClubBlockMember(memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubBlockMember(clubId: "58", memberId: memberId, categoryCode: "", integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubBlockMember error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                print("ClubBlockMember value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    
}
