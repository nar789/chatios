//
//  FantooTvViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/17.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class FantooTvViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    
    // 상단 상세설명
    @Published var fantooTV_DetailTopModel: Club_DetailTopModel?
    @Published var clubName: String = ""
    @Published var introduction: String = ""
    @Published var profileImg: String = ""
    @Published var memberCount: Int = 0
    
    // 팔로우
    @Published var fantooTV_FollowModel: Club_FollowModel?
    @Published var follow: Bool = false
    
    // 탭 정보
    @Published var fantooTV_TabInfoModel: Club_TabInfoModel?
    @Published var fantooTV_Tabs: [String] = []
    
    // 홈 탭
    @Published var fantooTV_TabHomeModel: Club_TabHomeModel?
    @Published var homeTab_PostList: [Club_TabHomeModel_PostList] = []
    @Published var tabHome_NextId: Int?
    
    // 채널 탭
    @Published var fantooTV_TabChannelModel: ClubCategoryModel?
    @Published var channelTab_CategoryList: [ClubCategoryModel] = []
    
    // 좋아요/싫어요
    @Published var fantooTV_TabHomeModel_Like: Club_Like?
    
    func getDetailTop(clubId: String) {
        ApiControl.getHomeClubType1DetailTop(clubId: clubId)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.fantooTV_DetailTopModel = value
                guard let NOfantooTV_DetailTopModel = self.fantooTV_DetailTopModel else {
                    // the 'value' is nil
                    return
                }
                
                self.clubName = NOfantooTV_DetailTopModel.clubName
                self.introduction = NOfantooTV_DetailTopModel.introduction
                self.profileImg = NOfantooTV_DetailTopModel.profileImg
                self.memberCount = NOfantooTV_DetailTopModel.memberCount
            }
            .store(in: &canclelables)
    }
    
    func getFollowInfo(clubId: String, integUid: String, access_token: String) {
        ApiControl.getHomeClubType1FollowInfo(clubId: clubId, integUid: integUid, access_token: access_token)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.fantooTV_FollowModel = value
                guard let NOfantooTV_FollowModel = self.fantooTV_FollowModel else {
                    // the 'value' is nil
                    return
                }
                
                self.follow = NOfantooTV_FollowModel.followYn
            }
            .store(in: &canclelables)
    }
    
    func getTabInfo(clubId: String, integUid: String) {
        ApiControl.getHomeClubType1TabInfo(clubId: clubId, integUid: integUid)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.fantooTV_TabInfoModel = value
                guard let NOfantooTV_TabInfoModel = self.fantooTV_TabInfoModel else {
                    // the 'value' is nil
                    return
                }
                
                self.fantooTV_Tabs = [] // Detail Page 갔다 왔을 때 데이터가 누적되는 문제가 있어서 배열 초기화 함
                for item in NOfantooTV_TabInfoModel.categoryList {
                    self.fantooTV_Tabs.append(item.categoryName)
                }
                
                /**
                 * 카테고리 아이디를 받아온 후 api 요청을 해야하기 때문에, 여기서 호출함
                 */
                if NOfantooTV_TabInfoModel.categoryList.count > 0 {
                    let arrLastIndex: Int = NOfantooTV_TabInfoModel.categoryList.count - 1
                    let categoryId: String = NOfantooTV_TabInfoModel.categoryList[arrLastIndex].categoryId
                    
                    self.getCategoryTab(clubId: "fantoo_tv", integUid: UserManager.shared.uid, categoryCode: categoryId)
                }
            }
            .store(in: &canclelables)
    }
    
    func getHomeTab(clubId: String, categoryCode: String, integUid: String, nextId: Int?, size: Int?) {
        ApiControl.getHomeClubType1HomeTab(clubId: clubId, categoryCode: categoryCode, integUid: integUid, nextId: nextId, size: size)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.fantooTV_TabHomeModel = value
                guard let NOfantooTV_TabHomeModel = self.fantooTV_TabHomeModel else {
                    // the 'value' is nil
                    return
                }
                self.homeTab_PostList = NOfantooTV_TabHomeModel.postList
                self.tabHome_NextId = NOfantooTV_TabHomeModel.nextId
            }
            .store(in: &canclelables)
    }
    
    func getCategoryTab(clubId: String, integUid: String, categoryCode: String) {
        ApiControl.getHomeClubType1CategoryTab(clubId: clubId, integUid: integUid, categoryCode: categoryCode)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.fantooTV_TabChannelModel = value
                guard let NOfantooTV_TabChannelModel = self.fantooTV_TabChannelModel else {
                    // the 'value' is nil
                    return
                }
                
                guard let NOChannelCategoryList = NOfantooTV_TabChannelModel.categoryList else {
                    return
                }
                self.channelTab_CategoryList = NOChannelCategoryList
            }
            .store(in: &canclelables)
    }
    
    func patchFantooTVLike(clubId: String, likeType: String, categoryCode: String, url_postId: Int, integUid: String, access_token: String, clickedIndex: Int) {
        ApiControl.patchClubLike(clubId: clubId, likeType: likeType, categoryCode: categoryCode, url_postId: url_postId, integUid: integUid, access_token: access_token)
            .sink { error in
            } receiveValue: { value in
                
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.fantooTV_TabHomeModel_Like = value
                guard let NOfantooTV_TabHomeModel_Like = self.fantooTV_TabHomeModel_Like else {
                    // the 'value' is nil
                    return
                }
                
                // 클릭한 아이템 업데이트
                self.homeTab_PostList[clickedIndex].like = NOfantooTV_TabHomeModel_Like
            }
            .store(in: &canclelables)
    }
    
    
}
