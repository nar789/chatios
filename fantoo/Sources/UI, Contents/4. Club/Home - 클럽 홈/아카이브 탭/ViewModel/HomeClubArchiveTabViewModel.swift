//
//  HomeClubArchiveTabViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class HomeClubArchiveTabViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    @Published var homeClub_TabArchiveModel: HomeClub_TabArchiveModel?
    @Published var homeClub_TabArchiveModel_Data = [HomeClub_TabArchiveModel_Data]()
    
    @Published var homeClub_Archive: HomeClub_CategoryModel?
    @Published var homeClub_ArchiveList = [HomeClub_Category_Item]()
    
    
    func getTabArchive() {
        ApiControl.getHomeClub_TabArchive()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_TabArchiveModel = value
                guard let NOhomeClub_TabArchiveModel = self.homeClub_TabArchiveModel else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_TabArchiveModel_Data = NOhomeClub_TabArchiveModel.data
            }
            .store(in: &canclelables)
    }
    
    func getArchive(clubId: String, categoryCode: String = "archive", nextId: Int? = nil) {
        print("getArchive : \(clubId) categoryCode : \(categoryCode)")
        ApiControl.getHomeClub_Category(clubId: clubId, categoryCode: categoryCode)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_Archive = value
                guard let model = self.homeClub_Archive else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_ArchiveList = model.categoryList ?? []
            }
            .store(in: &canclelables)
    }
}
