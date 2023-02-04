//
//  ClubMemberListViewModel.swift
//  fantoo
//
//  Created by fns on 2022/11/17.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine


class ClubMemberListViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var clubMemberData: ClubMemberData?
    @Published var clubMemberListData = [ClubMemberListData]()

    @Published var memberListSize: Int = 0
    
    func requestClubMemberList(clubId: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberList(clubId: clubId, integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("ClubMemberList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                result(true)
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
}
