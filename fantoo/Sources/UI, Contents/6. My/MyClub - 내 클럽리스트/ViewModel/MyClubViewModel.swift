//
//  MyClubViewModel.swift
//  fantoo
//
//  Created by fns on 2022/11/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class MyClubViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    var fetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징

    @Published var loadingStatus: LoadingStatus = .Close
    
    //errorAlert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // 통신이 완료되기 전까지, '데이터가 있는 뷰' 또는 '데이터가 없는 뷰' 둘 다 안 보여주기
    @Published var isNoticeLoading: Bool = true
    
    @Published var requestState: Bool = false
    
    @Published var myClubName: String = ""
    @Published var myClubCount: Int = 0
    @Published var myClubFavoriteCount: Int = 0
    @Published var myClubListData: MyClubListData?
    @Published var clubListData = [ClubListData]()
   
    @Published var isLoadingFinish: Bool = false
    
    @Published var favoriteYn: Bool = false
    
    @Published var isScrollViewShort: Bool = false
    
    
    init() {
        fetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
                self.fetchMore()
        }.store(in: &canclelables)
    
    }
    
    fileprivate func fetchMore() {
        guard let nextPage = myClubListData?.nextId else {
            print("페이지 정보가 없습니다.")
            return
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            
            self.requestMyClubList(nextId: nextPage, size: "\(DefineSize.ListSize.Common)", sort: "favorite")
            
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
    
    
    func requestMyClubList(nextId: String, size: String, sort: String) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.myClub(integUid: UserManager.shared.uid, nextId: nextId, size: size, sort: sort)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                self.alertMessage = error.message
                self.showAlert = true
                print("MyClubList error : \(error)")
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                
                self.myClubListData = value
                guard let noMyClubListData = self.myClubListData else {
                    // The 'value' is nil
                    return
                }
                
                // 첫 페이지만 해당 (페이징 X)
                if nextId == "0" {
                    self.clubListData = noMyClubListData.clubList
                }
                // 페이징으로 받아오는 데이터
                else {
                    self.clubListData.append(contentsOf: noMyClubListData.clubList)
                }
                self.isLoadingFinish = true
                print("MyClubList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func checkFavoriteEmpty() -> Bool {
        var checkArr: [ClubListData] = []
        for element in clubListData {
            if element.favoriteYn {
                checkArr.append(element)
            }
        }
        
        if checkArr.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    func clickFavoriteButton(position: Int) {
        clubListData[position].favoriteYn.toggle()
    }
    
    func requestMyClubFavoritePatch(clubId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubFavoritePatch(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                print("MyClubFavoritePatch error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.favoriteYn = value.favoriteYn
                self.requestMyClubCount(sort: "favorite")
            }
            .store(in: &canclelables)
    }
    
    func requestMyClubCount(sort: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubCount(integUid: UserManager.shared.uid, sort: sort)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                print("myClubCount error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                if sort == "favorite" {
                    self.myClubFavoriteCount = value.clubCount
                }
                else {
                    self.myClubCount = value.clubCount
                }
            }
            .store(in: &canclelables)
    }
}
