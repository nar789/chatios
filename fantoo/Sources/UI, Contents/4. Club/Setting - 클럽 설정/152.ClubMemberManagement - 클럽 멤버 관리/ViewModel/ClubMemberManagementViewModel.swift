//
//  ClubMemberManagementViewModel.swift
//  fantoo
//
//  Created by fns on 2022/11/07.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ClubMemberManagementViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = false
    
    @Published var loadingStatus: LoadingStatus = .Close

    
    @Published var clubWithdrawMemberData: ClubWithdrawMemberData?
    @Published var clubWithdrawListData = [ClubWithdrawListData]()
    @Published var withdrawListSize: Int = 0
    

    @Published var clubMemberData: ClubMemberData?
    @Published var clubMemberListData = [ClubMemberListData]()
    @Published var memberListSize: Int = 0
    
    @Published var selectedJoinYn: Bool = false
    @Published var rejoinText: String = ""
    @Published var withdrawId: String = ""

    

    func clubMemberForceLeaveList() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberForceLeaveList(clubId: "64", integUid: "ft_u_b2f5a8c4f29711ecaeec3b31eda63f19_2022_06_23_01_56_29_807", nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberForceLeaveList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.clubWithdrawMemberData = value
                guard let noClubWithdrawListData = self.clubWithdrawMemberData else {
                    return
                }
                self.clubWithdrawListData = noClubWithdrawListData.withdrawList
                self.withdrawListSize = value.listSize ?? 0
//                self.selectedJoinYn = clubWithdrawListData[].joinYn
                
                print("ClubMemberForceLeaveList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestclubMemberForceLeaveListCount() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberForceLeaveListCount(clubId: "64", integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberForceLeaveListCount error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.memberListSize = value.memberCount
                
                print("ClubMemberForceLeaveListCount value : \(value)")
            }
            .store(in: &canclelables)
    }
        
    func requestWithdrawClubMemberList() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberList(clubId: "64", integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.clubMemberData = value
                guard let noclubMemberListData = self.clubMemberData else {
                    return
                }
                self.clubMemberListData = noclubMemberListData.memberList
                self.memberListSize = value.listSize ?? 0
                
                print("ClubMemberList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubMemberForceLeaveEdit(joinYn: Bool, withdrawId: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberForceLeaveEdit(clubId: "64", integUid: UserManager.shared.uid, joinYn: joinYn, withdrawId: withdrawId)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("ClubMemberListEdit error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                result(true)
                print("ClubMemberListEdit value : \(value)")
            }
            .store(in: &canclelables)
    }
    
   

}
