//
//  SubHomeViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/05/26.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class SubHomeViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    var fetchMoreActionSubject = PassthroughSubject<(), Never>()
    
    @Published var mainHomeTabHome: MainHomeTabHome?
    @Published var bannerList = [BannerData]()
    @Published var boardList = [ItemData]()
    @Published var clubRecoList = [itemCardClubReco]()
    @Published var currentBannerPage: Int = 0
    @Published var isPageLoading: Bool = true
    
    init() {
        fetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            
            if !self.isPageLoading {
                self.fetchMore()
            }
        }.store(in: &canclelables)
    }
    
    fileprivate func fetchMore() {
        guard let currentPage = mainHomeTabHome?.page else {
            print("페이지 정보가 없습니다.")
            return
        }
        self.isPageLoading = true
        let pageToLoad = currentPage + 1
        // 0.5초 지연
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            ApiControl.getMainHomeTab_Home(page: pageToLoad)
                .sink { error in
                    print("error : \(error)")
                    
                    self.isPageLoading = false
                    //self.offPagingLoadView()
                    
                } receiveValue: { value in
                    self.isPageLoading = false
                    self.mainHomeTabHome = value
                    guard let NOmainHomeTabHome = self.mainHomeTabHome else {
                        // The 'value' is nil
                        return
                    }
                    self.boardList += NOmainHomeTabHome.data.board
                }
                .store(in: &self.canclelables)
            
        }
    }
    
    func getMainHomeTabHome() {
        ApiControl.getMainHomeTab_Home()
            .sink { error in
            } receiveValue: { value in
                
                // 로딩 종료
                self.isPageLoading = false
                StatusManager.shared.loadingStatus = .Close
                
                // 데이터 저장
                self.mainHomeTabHome = value
                guard let NOmainHomeTabHome = self.mainHomeTabHome else {
                    // The 'value' is nil
                    return
                }
                self.boardList = NOmainHomeTabHome.data.board
                self.clubRecoList = NOmainHomeTabHome.data.clubReco[0].item.club_reco
                self.bannerList = NOmainHomeTabHome.data.banner
            }
            .store(in: &canclelables)
    }
    
//    func onPagingLoadView() {
//        // 페이지 내에서 로딩
//        StatusManager.shared.loadingStatus = .ShowWithTouchable
//    }
//    func offPagingLoadView() {
//        // 로딩 종료
//        StatusManager.shared.loadingStatus = .Close
//    }
}
