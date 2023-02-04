//
//  HomeClubNoticeViewModel.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/19.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import Combine

class HomeClubNoticeViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    @Published var homeClub_Notice: HomeClub_Board_Model?
    @Published var homeClub_NoticeList = [HomeClub_Board_Post_Model]()

    
    func getNotice(clubId: String, nextId: Int? = nil) {
        print("getNotice : \(clubId)")
        ApiControl.getHomeClub_Board(clubId: clubId, categoryCode: "notice", nextId: nextId)
            .sink { completion in
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_Notice = value
                guard let model = self.homeClub_Notice else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_NoticeList = model.postList ?? []
                
            }
            .store(in: &canclelables)
    }
}
