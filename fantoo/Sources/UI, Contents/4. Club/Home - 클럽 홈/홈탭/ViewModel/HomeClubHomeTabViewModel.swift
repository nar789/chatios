//
//  HomeClubHomeTabViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/12.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class HomeClubHomeTabViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    var fetchMoreActionSubject = PassthroughSubject<(), Never>()
    
    @Published var isPageLoading: Bool = true
    
    @Published var showClubDelegatePopup: Bool = false
    @Published var showDelegateOkAlert: Bool = false
    @Published var showDelegateNoAlert: Bool = false
    
    @Published var homeClub_Login: ClubHomeLoginResponse?
    @Published var homeClub_Delegate: ClubDelegateMemberData?

    @Published var homeClub_TabHomeModel: HomeClub_TabHomeModel?
    @Published var homeClub_TabHomeModel_Notice: [String]?
    @Published var homeClub_TabHomeModel_Ad: HomeClub_TabHomeModel_Ad?
    @Published var homeClub_TabHomeModel_BoardList = [HomeClub_TabHomeModel_BoardList]()
    
    @Published var homeClub_TabHome_Response: HomeClub_TabHome_Response?
    @Published var homeClub_TabHome_PostList = [HomeClub_TabHome_Post_Model]()
    
    @Published var homeClub_BasicInfo: HomeClub_Basic_Info?
    
    @Published var homeClub_Notice: HomeClub_Board_Model?
    @Published var homeClub_NoticeList = [HomeClub_Board_Post_Model]()
    
    @Published var boardError: ErrorModel?
    
    @Published var homeClubJoinCancel: ClubJoinCancelResponse?
    
    func isBoardError() -> Bool {
        return boardError != nil
    }
    
    func noticeSimplyCount() -> Int {
        if homeClub_NoticeList.count > 2 {
            return 2
        } else {
            return homeClub_NoticeList.count
        }
    }
    
    func getTabHome() {
        ApiControl.getHomeClub_TabHome()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_TabHomeModel = value
                guard let NOhomeClub_TabHomeModel = self.homeClub_TabHomeModel else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_TabHomeModel_Notice = NOhomeClub_TabHomeModel.data.notice
                self.homeClub_TabHomeModel_Ad = NOhomeClub_TabHomeModel.data.ad
                self.homeClub_TabHomeModel_BoardList = NOhomeClub_TabHomeModel.data.board_list
            }
            .store(in: &canclelables)
    }
    
    func clubLogin(_ clubId: String) {
        print("getClubLogin : \(clubId)")
        ApiControl.getHomeClub_Login(clubId: clubId)
            .sink { error in
                
            } receiveValue: { value in
                
                self.homeClub_Login = value
                
                if self.homeClub_Login?.getDelegateStatus() == .Request {
                    self.getClubDelegateInfo(clubId)
                }
                
            }
            .store(in: &canclelables)
    }
    
    func clubVisit(_ clubId: String) {
        print("getClubVisit : \(clubId)")
        ApiControl.getHomeClub_BasicInfo(clubId: clubId)
            .sink { error in
                
            } receiveValue: { value in
                
            }
            .store(in: &canclelables)
    }
    
    func getBasicInfo(_ clubId: String) {
        print("getBasicInfo : \(clubId)")
        ApiControl.getHomeClub_BasicInfo(clubId: clubId)
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_BasicInfo = value
                
                self.getNotice(clubId: clubId)
            }
            .store(in: &canclelables)
    }
    
    func getTabHome(clubId: String, nextId: Int? = nil) {
        print("getTabHome : \(clubId)")
        ApiControl.getHomeClub_TabHome(clubId: clubId, nextId: nextId)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.boardError = error
                }
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_TabHome_Response = value
                guard let model = self.homeClub_TabHome_Response else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_TabHome_PostList = model.postList ?? []
            }
            .store(in: &canclelables)
    }
    
    func getNotice(clubId: String, nextId: Int? = nil) {
        print("getNotice home : \(clubId)")
        ApiControl.getHomeClub_Board(clubId: clubId, categoryCode: "notice", nextId: nextId, size: 2)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.boardError = error
                }
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_Notice = value
                guard let model = self.homeClub_Notice else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_NoticeList = model.postList ?? []
                
                self.getTabHome(clubId: clubId)
            }
            .store(in: &canclelables)
    }
    
    func clubJoinCancel(clubId: String) {
        print("clubJoinCancel : \(clubId)")
        ApiControl.clubJoinCancel(clubId: clubId)
            .sink { error in
                
            } receiveValue: { value in
                
                if value == "success" {
                    self.clubLogin(clubId)
                }
            }
            .store(in: &canclelables)
    }
    
    func getClubDelegateInfo(_ clubId: String) {
        ApiControl.clubDelegateMember0(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { completion in
                
            } receiveValue: { value in
                
                self.homeClub_Delegate = value
                
                if self.homeClub_Login?.getDelegateStatus() == .Request {
                    self.showClubDelegatePopup.toggle()
                }
                
            }
            .store(in: &canclelables)
    }
    
    func getClubDelegateOk(_ clubId: String) {
        ApiControl.clubDelegateRequest0_Ok(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { completion in
                
            } receiveValue: { value in
                
                if value.success {
                    self.showDelegateOkAlert.toggle()
                }
                
            }
            .store(in: &canclelables)
    }
    
    func getClubDelegateNo(_ clubId: String) {
        ApiControl.clubDelegateRequest0_No(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { completion in
                
            } receiveValue: { value in
                
                if value.success {
                    self.showDelegateNoAlert.toggle()
                }
                
            }
            .store(in: &canclelables)
    }
}
