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
    
    @Published var clickedClubCategoryPosition = 0
    @Published var myclub_clubList: [MainClub_MyClub_ClubList] = []
    @Published var myclub_listSize: Int = 0
    @Published var myclub_favoriteYn: Bool?
    @Published var myclub_nextId: Int?
    @Published var popularCategory_list: [MainClub_Popular_Category_PopularList] = []
    @Published var popularCategory_list_last: Int = 0
    @Published var popularList: [ClubListCommonModel_ClubList] = []
    @Published var newList: [ClubListCommonModel_ClubList] = []
    @Published var popularListTop10: [MainClub_Popular10_PostList] = []
    @Published var popularListTop10_date: String = ""
    @Published var clickedClubId: Int? = nil
    
    /**
     * 내 클럽
     */
    func getMyClub(integUid: String, nextId: String, size: String) {
        ApiControl.getMainClub_MyPage(integUid: integUid, nextId: nextId, size: size)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                self.myclub_clubList = value.clubList
                self.myclub_listSize = value.listSize
                self.myclub_favoriteYn = value.favoriteYn
                self.myclub_nextId = value.nextId
            }
            .store(in: &canclelables)
    }
    
    /**
     * 인기 클럽 추천 - 카테고리 리스트
     */
    func getPopular_Category(integUid: String) {
        ApiControl.getMainClub_Popular_Category(integUid: integUid)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                self.popularCategory_list = value.popularList
                
                if !self.popularCategory_list.isEmpty {
                    self.popularCategory_list_last = self.popularCategory_list.count-1
                    
                    self.getPopular_PopularList(categoryIndex: 0, categoryCode: self.popularCategory_list[0].categoryCode, integUid: UserManager.shared.uid)
                }
            }
            .store(in: &canclelables)
    }
    
    /**
     * 인기 클럽 추천 - 카테고리별 리스트
     */
    func getPopular_PopularList(categoryIndex: Int, categoryCode: String, integUid: String) {
        ApiControl.getMainClub_PopularList(categoryCode: categoryCode, integUid: integUid)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                self.clickedClubCategoryPosition = categoryIndex
                
                self.popularList = value.clubList
            }
            .store(in: &canclelables)
    }
    
    /**
     * 신규 클럽 추천
     */
    func getPopular_NewList(integUid: String) {
        ApiControl.getMainClub_NewList(integUid: integUid)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                self.newList = value.clubList
            }
            .store(in: &canclelables)
    }
    
    /**
     * 인기 게시글 TOP10
     */
    func getPopular_PopularTop10(integUid: String) {
        ApiControl.getMainClub_PopularTop10(integUid: integUid)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                self.popularListTop10 = value.postList
                self.popularListTop10_date = value.date
            }
            .store(in: &canclelables)
    }
}
