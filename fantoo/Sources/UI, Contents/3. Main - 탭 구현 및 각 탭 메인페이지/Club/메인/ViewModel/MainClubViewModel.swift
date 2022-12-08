//
//  MainClubViewModel.swift
//  fantooUITests
//
//  Created by kimhongpil on 2022/08/01.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class MainClubViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    @Published var mainClub_MainPage: MainClub_MainPage?
    @Published var mainClub_MainPage_Ad: MainClub_MainPage_Ad?
    @Published var mainClub_MainPage_MyClub = [MainClub_MainPage_MyClub]()
    @Published var mainClub_MainPage_Challenge = [String]()
    @Published var mainClub_MainPage_PopularClub: MainClub_MainPage_PopularClub?
    @Published var mainClub_MainPage_NewClub = [MainClub_MainPage_NewClub]()
    @Published var mainClub_MainPage_Top10 = [MainClub_MainPage_PopularTop10]()
    
    func getMainClub_MainPage() {
        ApiControl.getMainClub_MainPage()
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
                
                self.mainClub_MainPage_Ad = NOmainClub_MainPage.data.ad
                self.mainClub_MainPage_MyClub = NOmainClub_MainPage.data.myclub
                self.mainClub_MainPage_Challenge = NOmainClub_MainPage.data.challenge
                self.mainClub_MainPage_PopularClub = NOmainClub_MainPage.data.popular_club
                self.mainClub_MainPage_NewClub = NOmainClub_MainPage.data.new_club
                self.mainClub_MainPage_Top10 = NOmainClub_MainPage.data.popular_top10
            }
            .store(in: &canclelables)
    }
}
