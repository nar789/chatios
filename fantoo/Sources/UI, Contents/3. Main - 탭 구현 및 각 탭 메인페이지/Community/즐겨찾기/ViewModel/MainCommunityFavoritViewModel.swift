//
//  MainCommunityFavoritViewModel.swift
//  NotificationService
//
//  Created by kimhongpil on 2022/07/24.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class MainCommunityFavoritViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    // 카테고리
    @Published var category: MainCommunity_Category?
    @Published var category_CategoryList = [MainCommunity_Category_CategoryList]()
    @Published var clickedCategory: MainCommunity_Category_CategoryList?
    
    // 즐겨찾기 등록
    @Published var postResultModel: ResultModel?
    
    
    /**
     * 비회원 카테고리
     */
    func getMainCommunity_GuestCategory() {
        ApiControl.getMainCommunity_GuestCategory()
            .sink { error in
                
            } receiveValue: { value in
                
                self.category = value
                guard let NOcategory = self.category else {
                    return
                }
                
                self.category_CategoryList = NOcategory.categoryList
                self.isPageLoading = false
            }
            .store(in: &canclelables)
    }
    
    /**
     * 회원 카테고리 (팬투 추천순)
     */
    func getMainCommunity_UserCategory_Recog() {
        ApiControl.getMainCommunity_UserCategory_Recog(integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken)
            .sink { error in
            } receiveValue: { value in
                
                self.category = value
                guard let NOcategory = self.category else {
                    return
                }
                
                self.category_CategoryList = NOcategory.categoryList
                self.isPageLoading = false
                
            }
            .store(in: &canclelables)
    }
    
    /**
     * 회원 카테고리 (인기순)
     */
    func getMainCommunity_UserCategory_Popular() {
        ApiControl.getMainCommunity_UserCategory_Popular(integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken)
            .sink { error in
            } receiveValue: { value in
                
                self.category = value
                guard let NOcategory = self.category else {
                    return
                }
                
                self.category_CategoryList = NOcategory.categoryList
                self.isPageLoading = false
                
            }
            .store(in: &canclelables)
    }
    
    // 즐겨찾기 등록/삭제 적용
    func completeFavorite(position: Int) {
        category_CategoryList[position].favorite.toggle()
    }
    
    /**
     * 즐겨찾기 등록
     */
    func postCategoryFavorite(code: String, integUid: String, access_token: String, isComplete: ((Bool) -> Void)?) {
        
        ApiControl.postCommunityCategoryFavorite(code: code, integUid: integUid, access_token: access_token)
            .sink { error in
            } receiveValue: { value in
                
                self.postResultModel = value
                guard let NOpostResultModel = self.postResultModel else {
                    // The 'value' is nil
                    return
                }
                
                if NOpostResultModel.success {
                    guard let NOisComplete = isComplete else { return }
                    NOisComplete(true)
                }
            }
            .store(in: &canclelables)
    }
    
    /**
     * 즐겨찾기 삭제
     */
    func deleteCategoryFavorite(code: String, integUid: String, access_token: String, isComplete: ((Bool) -> Void)?) {
        
        ApiControl.deleteCommunityCategoryFavorite(code: code, integUid: integUid, access_token: access_token)
            .sink { error in
            } receiveValue: { value in
                
                self.postResultModel = value
                guard let NOpostResultModel = self.postResultModel else {
                    // The 'value' is nil
                    return
                }
                
                if NOpostResultModel.success {
                    guard let NOisComplete = isComplete else { return }
                    NOisComplete(true)
                }
            }
            .store(in: &canclelables)
    }
    
}
