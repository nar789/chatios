//
//  StandByJoinClubMemberViewModel.swift
//  fantoo
//
//  Created by fns on 2023/01/31.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class StandByJoinClubMemberViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = false
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var clubJoinMemberData: ClubJoinMemberData?
    @Published var clubJoinListData = [ClubJoinListData]()
    @Published var approvalMemberCount: Int = 0
    
    @Published var isSelectedAll: Bool = false
    
    func requestClubJoinMemberList(clubId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubJoinMemberList(clubId: clubId, integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                print("ClubJoinMemberList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.clubJoinMemberData = value
                self.approvalMemberCount = value.listSize ?? 0
                guard let noclubJoinMemberData = self.clubJoinMemberData else {
                    return
                }
                self.clubJoinListData = noclubJoinMemberData.joinList
            }
            .store(in: &canclelables)
    }
    
    func requestClubJoinMemberApproval(clubId: String, joinIdList: [Int]) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubJoinMemberApproval(clubId: clubId, integUid: UserManager.shared.uid, joinIdList: joinIdList)
            .sink { error in
                self.loadingStatus = .Close
                self.requestClubJoinMemberList(clubId: clubId)
                guard case let .failure(error) = error else { return }
                
                print("ClubJoinMemberApproval error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                //print("ClubJoinMemberApproval value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubJoinMemberRejection(clubId: String, joinIdList: [Int]) {
        loadingStatus = .ShowWithTouchable
        ApiControl.ClubJoinMemberRejection(clubId: clubId, integUid: UserManager.shared.uid, joinIdList: joinIdList)
            .sink { error in
                self.loadingStatus = .Close
                self.requestClubJoinMemberList(clubId: clubId)
                guard case let .failure(error) = error else { return }
                
                print("ClubJoinMemberApproval error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                //print("ClubJoinMemberApproval value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    
    
    func selectedListItem(index: Int) {
        self.clubJoinListData[index].isSelected.toggle()
        
        
        self.checkIsSelectedAll()
    }
    
    func changeAllListIsSelected(isSelectedAll: Bool) {
        for (index, _) in self.clubJoinListData.enumerated() {
            self.clubJoinListData[index].isSelected = isSelectedAll
        }
    }
    
    func checkIsSelectedAll() {
        var isCheck = false
        
        // '전체'가 클릭되어 있고, 클릭한 목록 아이템 중 하나라도 '클릭 안 된 아이템'이 있으면 -> '전체' 클릭 해제
        if self.isSelectedAll {
            for item in self.clubJoinListData {
                if !item.isSelected {
                    isCheck = true
                }
            }
        }
        // '전체'가 클릭 해제되어 있고, 모든 목록 아이템이 클릭되어 있으면 -> '클릭' 클릭 설정
        else {
            var isAllClick = true
            
            for item in self.clubJoinListData {
                if !item.isSelected {
                    isAllClick = false
                }
            }
            
            if isAllClick {
                isCheck = true
            }
        }
        
        if isCheck {
            self.isSelectedAll.toggle()
        }
    }
    
}
