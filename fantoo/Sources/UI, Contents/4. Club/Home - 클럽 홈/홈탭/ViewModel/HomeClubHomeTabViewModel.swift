//
//  HomeClubHomeTabViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/12.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class HomeClubHomeTabViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    @Published var homeClub_TabHomeModel: HomeClub_TabHomeModel?
    @Published var homeClub_TabHomeModel_Notice: [String]?
    @Published var homeClub_TabHomeModel_Ad: HomeClub_TabHomeModel_Ad?
    @Published var homeClub_TabHomeModel_BoardList = [HomeClub_TabHomeModel_BoardList]()
    
    func getTabHome() {
        ApiControl.getHomeClub_TabHome()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_TabHomeModel = value
                guard let NOhomeClub_TabHomeModel = self.homeClub_TabHomeModel else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_TabHomeModel_Notice = NOhomeClub_TabHomeModel.data.notice
                self.homeClub_TabHomeModel_Ad = NOhomeClub_TabHomeModel.data.ad
                self.homeClub_TabHomeModel_BoardList = NOhomeClub_TabHomeModel.data.board_list
            }
            .store(in: &canclelables)
    }
}
