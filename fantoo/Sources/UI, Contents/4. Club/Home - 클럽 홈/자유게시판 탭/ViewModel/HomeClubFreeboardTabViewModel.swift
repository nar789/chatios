//
//  HomeClubFreeboardTabViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class HomeClubFreeboardTabViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    @Published var homeClub_TabFreeboardModel: HomeClub_TabFreeboardModel?
    @Published var homeClub_TabFreeboardModel_Category: [String]?
    @Published var homeClub_TabFreeboardModel_FreeBoard = [HomeClub_TabFreeboardModel_FreeBoard]()
    
    func getTabFreeboard() {
        ApiControl.getHomeClub_TabFreeboard()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_TabFreeboardModel = value
                guard let NOhomeClub_TabFreeboardModel = self.homeClub_TabFreeboardModel else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_TabFreeboardModel_Category = NOhomeClub_TabFreeboardModel.data.category
                self.homeClub_TabFreeboardModel_FreeBoard = NOhomeClub_TabFreeboardModel.data.free_board
            }
            .store(in: &canclelables)
    }
}
