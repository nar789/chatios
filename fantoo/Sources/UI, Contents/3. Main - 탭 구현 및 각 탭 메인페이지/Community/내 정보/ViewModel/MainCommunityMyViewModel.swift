//
//  MainCommunityMyViewModel.swift
//  fantooUITests
//
//  Created by kimhongpil on 2022/07/23.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import CoreData

class MainCommunityMyViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = false
    @Published var communityTopFive: CommunityTopFive?
    @Published var data_TopFive: Data_TopFive?
    @Published var issueTop5_listTopFive = [CommunityBoardItem]()
    
    
    /**
     * 작성 글
     */
    func getMyBoardList() {
        // 로딩 시작
        self.isPageLoading = true
        
        ApiControl.getCommunitySearch()
            .sink { error in
                
            } receiveValue: { value in
                self.communityTopFive = value
                guard let NOcommunitySearch = self.communityTopFive else {
                    // The 'value' is nil
                    return
                }
                
                // 로딩 종료
                self.isPageLoading = false
                StatusManager.shared.loadingStatus = .Close
                
                self.data_TopFive = NOcommunitySearch.data
                guard let NOdata_TopFive = self.data_TopFive else {
                    return
                }
                self.issueTop5_listTopFive = NOdata_TopFive.issueTop5
            }
            .store(in: &canclelables)
    }
    
    /**
     * 작성 댓글
     */
    func getCommentList() {
        // 로딩 시작
        self.isPageLoading = true
        
        ApiControl.getCommunitySearch()
            .sink { error in
                
            } receiveValue: { value in
                self.communityTopFive = value
                guard let NOcommunitySearch = self.communityTopFive else {
                    // The 'value' is nil
                    return
                }
                
                // 로딩 종료
                self.isPageLoading = false
                StatusManager.shared.loadingStatus = .Close
                
                self.data_TopFive = NOcommunitySearch.data
                guard let NOdata_TopFive = self.data_TopFive else {
                    return
                }
                self.issueTop5_listTopFive = NOdata_TopFive.issueTop5
            }
            .store(in: &canclelables)
    }
    
    /**
     * 저장
     */
    func getLocalBoardList() {
        
    }
}
