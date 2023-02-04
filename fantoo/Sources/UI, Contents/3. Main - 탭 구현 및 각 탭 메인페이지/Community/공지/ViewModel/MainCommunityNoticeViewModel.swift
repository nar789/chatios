//
//  MainCommunityNoticeViewModel.swift
//  fantooUITests
//
//  Created by kimhongpil on 2022/07/24.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class MainCommunityNoticeViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    var fetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    
    // 통신이 완료되기 전까지, '데이터가 있는 뷰' 또는 '데이터가 없는 뷰' 둘 다 안 보여주기
    @Published var isNoticeLoading: Bool = true
    
    // 공지
    @Published var communityNotice: Community_Notice?
    @Published var communityNoticeList_Top = [Community_Notice_List]() // 고정핀 아이콘 있는 배열
    @Published var communityNoticeList_More = [Community_Notice_List]() // 고정핀 아이콘 없는 배열
    @Published var communityNoticeList_Total = [Community_Notice_List]() // 고정핀 아이콘 있는 배열 + 고정핀 아이콘 없는 배열 (최초 실행만 해당하고, 이후 페이징에서는 고정핀 아이콘 없는 배열만 추가됨)
    
    
    init() {
        fetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchMore()
        }.store(in: &canclelables)
    }
    
    fileprivate func fetchMore() {
        guard let nextPage = communityNotice?.nextId else {
            print("페이지 정보가 없습니다.")
            return
        }
        //print("다음 페이지 : \(nextPage)" as String)
        
        // 0.3초 지연 (너무 빨리 넘어가면 페이징 효과 안 날까봐)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.getNoticeListMore(nextId: nextPage, size: 10)
        }
    }
    
    func onMorePageLoading() {
        // 페이지 내에서 로딩
        StatusManager.shared.loadingStatus = .ShowWithTouchable
    }
    func offMorePageLoading() {
        // 로딩 종료
        StatusManager.shared.loadingStatus = .Close
    }
    
    
    
    
    func getNoticeList() {
        ApiControl.getCommunityTopNotice()
            .sink { error in
            } receiveValue: { value in
                self.communityNotice = value
                guard let NOcommunityTotalNotice = self.communityNotice else {
                    return
                }
                self.communityNoticeList_Top = NOcommunityTotalNotice.notice
                print("idpilLog:::")
                print("idpilLog::: communityNoticeList_Top: \(self.communityNoticeList_Top)" as String)
                // 고정핀 아이콘 없는 배열 호출
                self.getNoticeListMore(nextId: 0, size: 10)
            }
            .store(in: &canclelables)
    }
    
    func getNoticeListMore(nextId: Int, size: Int) {
        ApiControl.getCommunityTopNoticeMore(nextId: nextId, size: size)
            .sink { error in
            } receiveValue: { value in
                self.communityNotice = value
                guard let NOcommunityTotalNotice = self.communityNotice else {
                    return
                }
                self.communityNoticeList_More = NOcommunityTotalNotice.notice
                
                // 첫 페이지만 해당 (페이징 X)
                if nextId == 0 {
                    // 배열 합치기
                    self.communityNoticeList_Total = self.communityNoticeList_Top
                    self.communityNoticeList_Total.append(contentsOf: self.communityNoticeList_More)
                    
                    // UI 그릴 준비 완료
                    self.isNoticeLoading = false
                }
                // 페이징으로 받아오는 데이터
                else {
                    self.communityNoticeList_Total.append(contentsOf: self.communityNoticeList_More)
                    
                    self.offMorePageLoading()
                }
            }
            .store(in: &canclelables)
    }
}
