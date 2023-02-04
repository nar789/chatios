//
//  ClubManagementViewModel.swift
//  fantoo
//
//  Created by fns on 2022/11/30.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine


class ClubManagementViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var allMemberCount: String = ""
    @Published var allPostCount: String = ""
    @Published var clubOpenDate: String = ""
    @Published var openYn: Bool = false
    
    @Published var myClubName: String = ""
    @Published var myClubCount: Int = 0
    
    @Published var memberId: Int = 0
    @Published var memberLevel: Int = 0
    @Published var memberLevelName: String = ""
    @Published var nickname: String = ""
    @Published var profileImg: String = ""
    @Published var clubImg: String = ""
    
    
    //errorAlert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    
    @Published var clubJoinMemberData: ClubJoinMemberData?
    @Published var clubJoinListData = [ClubJoinListData]()
    @Published var approvalMemberCount: Int = 0
        
    @Published var closesStatus: Int = 0
    
    @Published var clubMemberCount: Int = 0
    
    @Published var delegateStatus: Int = 0
    
    
    func requestClubManage(clubId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubManage(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                print("ClubManage error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.allMemberCount = String(describing: value.memberCount)
                self.allPostCount = String(describing: value.postCount)
                self.clubImg = value.profileImg
                self.myClubName = value.clubName
                self.openYn = value.openYn
                
                print("@@@\(self.profileImg)")
                
                if value.createDate.count > 0 {
                    let dateString = value.createDate
                    let inputFormatter = ISO8601DateFormatter()
                    inputFormatter.formatOptions = [
                        .withFractionalSeconds,
                        .withFullDate
                    ]
                    let date = inputFormatter.date(from: dateString)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let weekDay = dateFormatter.string(from: date!)
                    self.clubOpenDate = weekDay
                }
            
                
                print("ClubManage value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    
    func requestClubClosingState(clubId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubClosingState(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberForceLeaveList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.closesStatus = value.closesStatus
                print("ClubMemberForceLeaveList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubJoinMemberList(clubId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubJoinMemberList(clubId: clubId, integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubJoinMemberList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.clubJoinMemberData = value
                self.approvalMemberCount = value.listSize ?? 0
                guard let noclubJoinMemberData = self.clubJoinMemberData else {
                    return
                }
                self.clubJoinListData = noclubJoinMemberData.joinList
                print("ClubJoinMemberList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    
    func requestClubMemberCount(clubId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberCount(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberCount error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.clubMemberCount = value.memberCount
                print("ClubMemberCount value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubDelegateMember(clubId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubDelegateMember(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubDelegateMember error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.nickname = value.nickname
                self.profileImg = value.profileImg
                self.memberId = value.memberId
                self.memberLevel = value.memberLevel
                self.delegateStatus = value.delegateStatus
                print("ClubDelegateMember value : \(value)")
            }
            .store(in: &canclelables)
    }
}
