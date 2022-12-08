//
//  MainCommunityViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/06/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class MainCommunityViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    // 통신이 완료되기 전까지, '데이터가 있는 뷰' 또는 '데이터가 없는 뷰' 둘 다 안 보여주기
    @Published var isLoadingFinish: Bool = false
    
    // 공지
    @Published var communityTotalNotice: Community_Notice?
    @Published var communityTotalNoticeList = [Community_Notice_List]()
    
    // 카테고리
    @Published private var category: MainCommunity_Category?
    @Published var category_CategoryList = [MainCommunity_Category_CategoryList]()
    @Published var clickedCategory: MainCommunity_Category_CategoryList?
    
    // 게시글
    @Published var board: MainCommunity_Board?
    @Published var board_hourList = [Community_BoardItem]()
    @Published var board_weekList = [Community_BoardItem]()
    
    // 좋아요/싫어요
    @Published var community_Like: Community_Like?
    
    
    /**
     * 최초 화면 진입시에만 로딩뷰를 띄우기 위한 설정값
     * [!] init() 은 최초 한 번 호출되고, onAppear() 는 매번 호출됨. 그래서 init() 사용함
     */
    @Published var isInit: Bool = false
    init() {
        self.isInit = true
    }
    
    
    // 회원 API 호출
    func FantooUserApiCall() {
        self.getCommunityTotalNotice()
        self.getMainCommunity_UserCategory()
        self.getMainCommunity_UserBoard()
    }
    
    // 비회원 API 호출
    func FantooGuestApiCall() {
        self.getCommunityTotalNotice()
        self.getMainCommunity_GuestCategory()
        self.getMainCommunity_GuestBoard()
    }
    
    /**
     * 전체공지 TOP고정 List
     */
    func getCommunityTotalNotice() {
        ApiControl.getCommunityTopNotice()
            .sink { error in
            } receiveValue: { value in
                self.communityTotalNotice = value
                guard let NOcommunityTotalNotice = self.communityTotalNotice else {
                    return
                }
                self.communityTotalNoticeList = NOcommunityTotalNotice.notice
            }
            .store(in: &canclelables)
    }
    
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
            }
            .store(in: &canclelables)
    }
    
    /**
     * 비회원 인기 게시글
     */
    func getMainCommunity_GuestBoard() {
        ApiControl.getMainCommunity_GuestBoard()
            .sink { error in
                
            } receiveValue: { value in
                
                self.board = value
                guard let NOboard = self.board else {
                    return
                }
                
                self.board_hourList = NOboard.hour
                self.board_weekList = NOboard.week
            }
            .store(in: &canclelables)
    }
    /**
     * 회원 카테고리
     */
    func getMainCommunity_UserCategory() {
        ApiControl.getMainCommunity_UserCategory_Recog(integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken)
            .sink { error in
            } receiveValue: { value in
                
                self.category = value
                guard let NOcategory = self.category else {
                    return
                }
                
                self.category_CategoryList = NOcategory.categoryList
            }
            .store(in: &canclelables)
    }
    /**
     * 회원 인기 게시글
     */
    func getMainCommunity_UserBoard() {
        ApiControl.getMainCommunity_UserBoard(integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken)
            .sink { error in
            } receiveValue: { value in
                self.offMorePageLoading()
                
                self.board = value
                guard let NOboard = self.board else {
                    return
                }
                
                self.board_hourList = NOboard.hour
                self.board_weekList = NOboard.week
                
                self.isInit = false
                self.isLoadingFinish = true
            }
            .store(in: &canclelables)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**
     * 광고 서버에서 임시로 만든 API 모델 (fantoo api 적용 후 삭제할 것)
     */
    @Published var communityCategory: MainCommunityCategory?
    @Published var communityCategoryData: [String] = []
    @Published var communityCategoryFantooMember: CommunityCategoryFantooMember?
    @Published var dataObj_CategoryFantooMember: DataObj_CategoryFantooMember?
    @Published var categoryList_CategoryFantooMember = [CategoryList_CategoryFantooMember]()
    @Published var communityTopFive: CommunityTopFive?
    @Published var data_TopFive: Data_TopFive?
    @Published var issueTop5_listTopFive = [CommunityBoardItem]()
    @Published var weekTop5_listTopFive = [CommunityBoardItem]()
    @Published var communityCategoryFantooNonmember: CommunityCategoryFantooNonmember?
    @Published var dataObj_CategoryFantooNonmember: DataObj_CategoryFantooNonmember?
    @Published var categoryList_CategoryFantooNonmember = [CategoryList_CategoryFantooNonmember]()
    
    
    /**
     * 카테고리
     */
    func getMainCommunityCategory() {
        ApiControl.getCommunityCategory()
            .sink { error in
            } receiveValue: { value in
                
                self.communityCategory = value
                guard let NOcommunityCategory = self.communityCategory else {
                    // The 'value' is nil
                    return
                }
                
                // The 'nonOptionalValue' is not nil
                self.communityCategoryData = NOcommunityCategory.data
            }
            .store(in: &canclelables)
    }
    
    /**
     * 카테고리 팬투 추천순 (회원)
     */
//    func getCommunityCategoryFantooMember() {
//        let integUid = "ft_u_f1cc32a6f6a911ec965773db7dcd1ece_2022_06_28_06_17_10_824"
//        let access_token = "ehhnmla0nqn0krqo3iihlgks8o_2022_08_03_15_40_44_151"
//        ApiControl.getCommunityCategoryFantooMember(integUid: integUid, access_token: access_token)
//            .sink { error in
//            } receiveValue: { value in
//
//                self.communityCategoryFantooMember = value
//                guard let NOcommunityCategoryFantooMember = self.communityCategoryFantooMember else {
//                    // The 'value' is nil
//                    return
//                }
//
//                self.dataObj_CategoryFantooMember = NOcommunityCategoryFantooMember.dataObj
//                guard let NOdataObj_CategoryFantooMember = self.dataObj_CategoryFantooMember else {
//                    return
//                }
//                self.categoryList_CategoryFantooMember = NOdataObj_CategoryFantooMember.categoryList
//            }
//            .store(in: &canclelables)
//    }
    
    /**
     * 카테고리 팬투 추천순 (비회원)
     */
    func getCommunityCategoryFantooNonmember() {
        ApiControl.getCommunityCategoryFantooNonmember()
            .sink { error in
            } receiveValue: { value in
                
                self.communityCategoryFantooNonmember = value
                guard let NOcommunityCategoryFantooNonmember = self.communityCategoryFantooNonmember else {
                    return
                }
            }
            .store(in: &canclelables)
    }
    
    
    /**
     * 실시간 이슈 TOP 5 & 주간 인기 TOP 5
     */
    func getCommunityTopFive() {
        ApiControl.getCommunityTopFive()
            .sink { error in
                
            } receiveValue: { value in
                
                self.communityTopFive = value
                guard let NOcommunityTopFive = self.communityTopFive else {
                    // The 'value' is nil
                    return
                }
                
                self.data_TopFive = NOcommunityTopFive.data
                guard let NOdata_TopFive = self.data_TopFive else {
                    return
                }
                
                self.issueTop5_listTopFive = NOdata_TopFive.issueTop5
                self.weekTop5_listTopFive = NOdata_TopFive.weekTop5
            }
            .store(in: &canclelables)
    }
    
    /**
     * 좋아요/싫어요
     */
    func postCommunityLike(likeType: String, targetType: String, targetId: Int, integUid: String, access_token: String, clickedIndex: Int, boardType: MainCommunityLikeInfoType) {
        ApiControl.postCommunityLike(likeType: likeType, targetType: targetType, targetId: targetId, integUid: integUid, access_token: access_token)
            .sink { error in
                
            } receiveValue: { value in
                
                self.community_Like = value
                guard let NOcommunity_Like = self.community_Like else {
                    // The 'value' is nil
                    return
                }
                
                if boardType == .Hour {
                    self.board_hourList[clickedIndex].likeCnt = NOcommunity_Like.like
                    self.board_hourList[clickedIndex].dislikeCnt = NOcommunity_Like.disLike
                    
                    if likeType == "like" {
                        self.board_hourList[clickedIndex].likeYn.toggle()
                        self.board_hourList[clickedIndex].dislikeYn = false
                    } else if likeType == "dislike" {
                        self.board_hourList[clickedIndex].dislikeYn.toggle()
                        self.board_hourList[clickedIndex].likeYn = false
                    }
                }
                else if boardType == .Week {
                    self.board_weekList[clickedIndex].likeCnt = NOcommunity_Like.like
                    self.board_weekList[clickedIndex].dislikeCnt = NOcommunity_Like.disLike
                    
                    if likeType == "like" {
                        self.board_weekList[clickedIndex].likeYn.toggle()
                        self.board_weekList[clickedIndex].dislikeYn = false
                    } else if likeType == "dislike" {
                        self.board_weekList[clickedIndex].dislikeYn.toggle()
                        self.board_weekList[clickedIndex].likeYn = false
                    }
                    
                }
            }
            .store(in: &canclelables)
    }
    
    /**
     * 좋아요/싫어요 취소
     */
    func deleteCommunityLike(targetType: String, targetId: Int, integUid: String, access_token: String, clickedIndex: Int, boardType: MainCommunityLikeInfoType) {
        ApiControl.deleteCommunityLike(targetType: targetType, targetId: targetId, integUid: integUid, access_token: access_token)
            .sink { error in

            } receiveValue: { value in

                self.community_Like = value
                guard let NOcommunity_Like = self.community_Like else {
                    // The 'value' is nil
                    return
                }

                if boardType == .Hour {
                    self.board_hourList[clickedIndex].likeCnt = NOcommunity_Like.like
                    self.board_hourList[clickedIndex].dislikeCnt = NOcommunity_Like.disLike

                    self.board_hourList[clickedIndex].likeYn = false
                    self.board_hourList[clickedIndex].dislikeYn = false
                }
                else if boardType == .Week {
                    self.board_weekList[clickedIndex].likeCnt = NOcommunity_Like.like
                    self.board_weekList[clickedIndex].dislikeCnt = NOcommunity_Like.disLike

                    self.board_weekList[clickedIndex].likeYn = false
                    self.board_weekList[clickedIndex].dislikeYn = false

                }
            }
            .store(in: &canclelables)
    }
    
    
    func onMorePageLoading() {
        // 페이지 내에서 로딩
        StatusManager.shared.loadingStatus = .ShowWithTouchable
    }
    func offMorePageLoading() {
        // 로딩 종료
        StatusManager.shared.loadingStatus = .Close
    }
}
