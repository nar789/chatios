//
//  MainClubChallengeViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/01.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class MainClubChallengeViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    @Published var mainClub_MainPage: MainClub_MainPage?
    @Published var mainClub_MainPage_Top10 = [MainClub_MainPage_PopularTop10]()
    
    func getMainClub_Challenge() {
        ApiControl.getMainClub_MyPage()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                StatusManager.shared.loadingStatus = .Close
                
                self.mainClub_MainPage = value
                guard let NOmainClub_MainPage = self.mainClub_MainPage else {
                    // The 'value' is nil
                    return
                }
                
                self.mainClub_MainPage_Top10 = NOmainClub_MainPage.data.popular_top10
            }
            .store(in: &canclelables)
    }
    
}
