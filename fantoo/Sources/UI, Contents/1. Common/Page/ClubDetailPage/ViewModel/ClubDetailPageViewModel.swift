//
//  ClubDetailPageViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class ClubDetailPageViewModel: ObservableObject {
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    @Published var clubDetailPageModel: ClubDetailPageModel?
    @Published var clubDetailPageData: ClubDetailPageData?
    
    func getClubDetail() {
        ApiControl.getClubDetailPage()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.clubDetailPageModel = value
                guard let NOclubDetailPageModel = self.clubDetailPageModel else {
                    // The 'value' is nil
                    return
                }
                
                self.clubDetailPageData = NOclubDetailPageModel.data
            }
            .store(in: &canclelables)
    }
}
