//
//  HomeClubArchiveViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class HomeClubArchiveViewModel: ObservableObject {
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    /**
     * noImageView
     */
    let objectWillChange = ObservableObjectPublisher()
    @Published var homeClub_TabFreeboardModel: HomeClub_TabFreeboardModel?
    @Published var homeClub_TabFreeboardModel_FreeBoard = [HomeClub_TabFreeboardModel_FreeBoard]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var homeClub_Board: HomeClub_Board_Model?
    @Published var homeClub_BoardList = [HomeClub_Board_Post_Model]()
    
    func getNoImageView() {
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
                
                self.homeClub_TabFreeboardModel_FreeBoard = NOhomeClub_TabFreeboardModel.data.free_board
            }
            .store(in: &canclelables)
    }
    
    func getArchiveBoard(clubId: String, categoryCode: String = "archive", nextId: Int? = nil) {
        print("getArchiveBoard : \(clubId) categoryCode : \(categoryCode)")
        ApiControl.getHomeClub_Board(clubId: clubId, categoryCode: categoryCode, nextId: nextId)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_Board = value
                guard let model = self.homeClub_Board else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_BoardList = model.postList ?? []
            }
            .store(in: &canclelables)
    }
}
