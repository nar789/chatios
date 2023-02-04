//
//  CommunityHomeViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class CommunityHomeViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    var fetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    
    // 통신이 완료되기 전까지, '데이터가 있는 뷰' 또는 '데이터가 없는 뷰' 둘 다 안 보여주기
    @Published var isLoadingFinish = false
    
    @Published var categoryCode: String?
    @Published var isClickCategoryLike = false
    
    //alert
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    // 공지
    @Published var communityNotice: Community_Notice?
    @Published var communityNoticeList = [Community_Notice_List]()
    
    // Sub 카테고리
    @Published var selectedSubCategoryCode: String?
    @Published var communitySubcategoryMember: CommunitySubcategoryMember?
    @Published var category_SubcategoryMember: Category_SubcategoryMember?
    @Published var categoryList_SubcategoryMember = [CategoryList_SubcategoryMember]()
    
    // 게시판 목록
    @Published var community_List: Community_List?
    @Published var community_BoardItem = [Community_BoardItem]()
    
    // 최초 ScrollView 로딩 시, 아이템 목록이 화면에 꽉 찼는지 유무 확인
    // 리프레시하면 onAppear 가 호출되지 않기 때문에 페이징 기능을 적용시켜줘야 하는데,
    // "아이템 목록이 화면에 꽉 차지 않은 경우에만" 페이징 작업을 해주면 됨
    @Published var isScrollViewShort = false
    
    // 좋아요/싫어요
    @Published var community_Like: Community_Like?
    
    // 즐겨찾기 등록
    @Published var postResultModel: ResultModel?
    
    // popup
    @Published var currentPopupType: GlobalLanType = .Global
    
    
    
    init() {
        fetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchMore()
        }.store(in: &canclelables)
    }
    
    fileprivate func fetchMore() {
        guard let nextPage = community_List?.nextId else {
            print("페이지 정보가 없습니다.")
            return
        }
        //print("다음 페이지 : \(nextPage)" as String)
        
        // 0.3초 지연 (너무 빨리 넘어가면 페이징 효과 안 날까봐)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            
            self.callBoardListFunc(nextId: nextPage)
        }
    }
    
    
    
    /**
     * 공지
     */
    func getHomeCommunityNotice(code: String) {
        ApiControl.getCommunityTopNoticeCategory(code: code)
            .sink { error in
            } receiveValue: { value in
                self.communityNotice = value
                guard let NOcommunityNotice = self.communityNotice else {
                    // The 'value' is nil
                    return
                }
                
                // The 'nonOptionalValue' is not nil
                self.communityNoticeList = NOcommunityNotice.notice
            }
            .store(in: &canclelables)
    }
    
    /**
     * 카테고리 Sub (회원)
     */
    func getSubCategory(code: String, integUid: String, access_token: String) {
        ApiControl.getMemberSubCategory(code: code, integUid: integUid, access_token: access_token)
            .sink { error in
            } receiveValue: { value in
                self.communitySubcategoryMember = value
                guard let NOcommunitySubcategoryMember = self.communitySubcategoryMember else {
                    return
                }
                
                self.category_SubcategoryMember = NOcommunitySubcategoryMember.category
                
                // 카테고리 즐겨찾기 유무 및 카테고리 코드
                if let NOcategory_SubcategoryMember = self.category_SubcategoryMember {
                    
                    self.isClickCategoryLike = NOcategory_SubcategoryMember.favorite
                    
                    self.categoryCode = NOcategory_SubcategoryMember.code
                }
                
                // '전체' subCategory 추가
                self.categoryList_SubcategoryMember =
                [
                    CategoryList_SubcategoryMember(
                        code: "All",
                        parentCode: "All",
                        codeNameKo: "전체",
                        codeNameEn: "All",
                        depth: 0,
                        sort: 0
                    )
                ]
                // 받아온 subCategory 추가
                for element in NOcommunitySubcategoryMember.categoryList {
                    self.categoryList_SubcategoryMember.append(element)
                }
                
                // 첫 번째 카테고리인 '전체'로 선택
                if self.categoryList_SubcategoryMember.count > 0 {
                    self.selectedSubCategoryCode = self.categoryList_SubcategoryMember[0].code
                }
                
                self.callBoardListFunc(nextId: 0)
            }
            .store(in: &canclelables)
    }
    
    
    func callBoardListFunc(nextId: Int, selectedLanCode: String = "") {
        
        var globalYn = true
        if currentPopupType == .Global {
            globalYn = true
        } else if currentPopupType == .MyLan {
            globalYn = false
        } else if currentPopupType == .AnotherLan {
            globalYn = false
        }
        
        if let NOcategory_SubcategoryMember = self.category_SubcategoryMember, let NOselectedSubCategoryCode = self.selectedSubCategoryCode {
            self.getBoardList(
                code: NOcategory_SubcategoryMember.code,
                globalYn: globalYn,
                integUid: UserManager.shared.uid,
                nextId: nextId,
                size: DefineSize.ListSize.Common,
                subCode: NOselectedSubCategoryCode,
                access_token: UserManager.shared.accessToken,
                currentPopupType: currentPopupType,
                selectedLanCode: selectedLanCode
            )
        }
    }
    
    
    /**
     * 게시판 목록
     */
    func getBoardList(code: String, globalYn: Bool, integUid: String, nextId: Int, size: Int, subCode: String, access_token: String, currentPopupType: GlobalLanType, selectedLanCode: String) {
        
        CommonFunction.onPageLoading()
        
        ApiControl.getEachCategoryBoards(code: code, globalYn: globalYn, integUid: integUid, nextId: nextId, size: size, subCode: subCode, access_token: access_token, currentPopupType: currentPopupType, selectedLanCode: selectedLanCode)
            .sink { error in
                CommonFunction.offPageLoading()
                
                guard case let .failure(error) = error else { return }
                print("api call error : \(error)")
                
                self.community_BoardItem = []
                
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                self.community_List = value
                guard let NOcommunity_List = self.community_List else {
                    // The 'value' is nil
                    return
                }

                // 첫 페이지만 해당 (페이징 X)
                if nextId == 0 {
                    self.community_BoardItem = NOcommunity_List.post
                    
                    // for test (Array Slice)
                    //self.community_BoardItem = Array(NOcommunity_List.post[0...2])
                }
                // 페이징으로 받아오는 데이터
                else {
                    self.community_BoardItem.append(contentsOf: NOcommunity_List.post)
                }
                
                self.isLoadingFinish = true
            }
            .store(in: &canclelables)
    }
    
    /**
     * 좋아요/싫어요
     */
    func postCommunityLike(likeType: String, targetType: String, targetId: Int, integUid: String, access_token: String, clickedIndex: Int) {
        ApiControl.postCommunityLike(likeType: likeType, targetType: targetType, targetId: targetId, integUid: integUid, access_token: access_token)
            .sink { error in

            } receiveValue: { value in

                self.community_Like = value
                guard let NOcommunity_Like = self.community_Like else {
                    // The 'value' is nil
                    return
                }

                self.community_BoardItem[clickedIndex].likeCnt = NOcommunity_Like.like
                self.community_BoardItem[clickedIndex].dislikeCnt = NOcommunity_Like.disLike

                if likeType == "like" {
                    self.community_BoardItem[clickedIndex].likeYn.toggle()
                    self.community_BoardItem[clickedIndex].dislikeYn = false
                } else if likeType == "dislike" {
                    self.community_BoardItem[clickedIndex].dislikeYn.toggle()
                    self.community_BoardItem[clickedIndex].likeYn = false
                }
            }
            .store(in: &canclelables)
    }

    /**
     * 좋아요/싫어요 취소
     */
    func deleteCommunityLike(targetType: String, targetId: Int, integUid: String, access_token: String, clickedIndex: Int) {
        ApiControl.deleteCommunityLike(targetType: targetType, targetId: targetId, integUid: integUid, access_token: access_token)
            .sink { error in

            } receiveValue: { value in

                self.community_Like = value
                guard let NOcommunity_Like = self.community_Like else {
                    // The 'value' is nil
                    return
                }

                self.community_BoardItem[clickedIndex].likeCnt = NOcommunity_Like.like
                self.community_BoardItem[clickedIndex].dislikeCnt = NOcommunity_Like.disLike

                self.community_BoardItem[clickedIndex].likeYn = false
                self.community_BoardItem[clickedIndex].dislikeYn = false
            }
            .store(in: &canclelables)
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
