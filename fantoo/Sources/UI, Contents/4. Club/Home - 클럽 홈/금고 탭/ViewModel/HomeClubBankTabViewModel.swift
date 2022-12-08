//
//  HomeClubBankTabViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class HomeClubBankTabViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    @Published var homeClub_TabBankModel: HomeClub_TabBankModel?
    @Published var homeClub_TabBankModel_Header: HomeClub_TabBankModel_Header?
    @Published var homeClub_TabBankModel_Body: HomeClub_TabBankModel_Body?
    @Published var homeClub_TabBankModel_Footer: HomeClub_TabBankModel_Footer?
    
    func getTabBank() {
        ApiControl.getHomeClub_TabBank()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_TabBankModel = value
                guard let NOhomeClub_TabBankModel = self.homeClub_TabBankModel else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_TabBankModel_Header = NOhomeClub_TabBankModel.data.header
                self.homeClub_TabBankModel_Body = NOhomeClub_TabBankModel.data.body
                self.homeClub_TabBankModel_Footer = NOhomeClub_TabBankModel.data.footer
            }
            .store(in: &canclelables)
    }
}
