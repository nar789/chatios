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
    
    @Published var homeClub_Category: HomeClub_CategoryModel?
    @Published var homeClub_CategoryList = [HomeClub_Category_Item]()
    
    @Published var homeClub_Board: HomeClub_Board_Model?
    @Published var homeClub_BoardList = [HomeClub_Board_Post_Model]()
    
    @Published var boardError: ErrorModel?
    
    func isBoardError() -> Bool {
        return boardError != nil
    }
    
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
    
    func getCategory(clubId: String, categoryCode: String = "freeboard", nextId: Int? = nil) {
        print("getCategory : \(clubId) categoryCode : \(categoryCode)")
        ApiControl.getHomeClub_Category(clubId: clubId, categoryCode: categoryCode)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_Category = value
                guard let model = self.homeClub_Category else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_CategoryList = model.categoryList ?? []
                
                self.getBoard(clubId: clubId, categoryCode: self.homeClub_CategoryList.first?.categoryCode ?? "freeboard_all")
            }
            .store(in: &canclelables)
    }
    
    func getBoard(clubId: String, categoryCode: String = "freeboard", nextId: Int? = nil) {
        print("getBoard : \(clubId) categoryCode : \(categoryCode)")
        ApiControl.getHomeClub_Board(clubId: clubId, categoryCode: categoryCode, nextId: nextId)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.boardError = error
                }
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_Board = value
                guard let model = self.homeClub_Board else {
                    // The 'value' is nil
                    return
                }
                
                self.boardError = nil
                self.homeClub_BoardList = model.postList ?? []
            }
            .store(in: &canclelables)
    }
    
    
}
