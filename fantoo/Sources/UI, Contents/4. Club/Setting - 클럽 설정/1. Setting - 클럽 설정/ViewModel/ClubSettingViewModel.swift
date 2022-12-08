//
//  ClubSettingViewModel.swift
//  fantoo
//
//  Created by fns on 2022/10/04.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ClubSettingViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = false
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var myClubName: String = ""
    @Published var myClubCount: Int = 0
    @Published var myClubListData: MyClubListData?
    @Published var clubListData = [ClubListData]()
    
    @Published var myClubBasicName: String = ""
    @Published var myClubBasicCount: Int = 0
    @Published var myClubBasicListData: MyClubBasicListData?
    @Published var clubBasicListData = [ClubBasicListData]()
    
    
    @Published var clubStorageCountData: ClubStorageCountData?
    @Published var postCount: Int = 0
    @Published var replyCount: Int = 0
    @Published var bookmarkCount: Int = 0
    
    @Published var clubStorageReplyData: ClubStorageReplyData?
    @Published var clubStorageReplyListData = [ClubStorageReplyListData]()
    
    @Published var clubStorageBookmarkData: ClubStorageBookmarkData?
    @Published var clubStorageBookmarkListData = [ClubStorageBookmarkListData]()
    
    @Published var clubStoragePostData: ClubStoragePostData?
    @Published var clubStoragePostListData = [ClubStoragePostListData]()
    
    @Published var clubMemberData: ClubMemberData?
    @Published var clubMemberListData = [ClubMemberListData]()
    
    @Published var clubStorageMemberPostData: ClubStoragePostData?
    @Published var clubStorageMemberPostListData = [ClubStoragePostListData]()
    
    @Published var clubStorageMemberReplyData: ClubStorageReplyData?
    @Published var clubStorageMemberReplyListData = [ClubStorageReplyListData]()
    
    @Published var memberListSize: Int = 0
    @Published var createDate: String = ""
    @Published var memberId: Int = 0
    @Published var memberLevel: Int = 0
    @Published var memberLevelName: String = ""
    @Published var nickname: String = ""
    @Published var profileImg: String = ""
    
    //nicknameCheck
    @Published var nickName: String = ""
    @Published var checkNickNameWarning: String = ""
    @Published var nickNameCorrectStatus:CheckCorrectStatus = .Check
    @Published var referralCodeCorrectStatus:CheckCorrectStatus = .Check
    @Published var nickNameDidEnter: Bool = false
    @Published var existYn: Bool = false
    @Published var nicknameCheckToken: String = ""
    
    
    //errorAlert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    //errorNickAlert
    @Published var showAlertCannotUse: Bool = false
    @Published var showAlertLength: Bool = false
    @Published var showAlertAlreadyUse: Bool = false
    @Published var showAlertUsable: Bool = false
    @Published var showAlertCannotChange: Bool = false
    @Published var rightItemsState: Bool = false
    
    @Published var allMemberCount: String = ""
    @Published var allPostCount: String = ""
    @Published var clubOpenDate: String = ""
    @Published var openYn: Bool = false
    
    @Published var clubJoinMemberData: ClubJoinMemberData?
    @Published var clubJoinListData = [ClubJoinListData]()
    @Published var approvalMemberCount: Int = 0
    
    @Published var favoriteYn: Bool = false
        
    @Published var closesStatus: Int = 0
    
    @Published var clubMemberCount: Int = 0
    
    @Published var delegateStatus: Int = 0
    
    @Published var blockYn: Bool = false
    
    @Published var countryCode: String = "Republic of Korea"
    
    @Published var leftBackItems: [CustomNavigationBarButtonType] = [.Back]
    @Published var rightSaveItems: [CustomNavigationBarButtonType] = [.Save]
    @Published var rightUnSaveItems: [CustomNavigationBarButtonType] = [.UnSave]
    
    //MARK: - Request
    func requestUploadImage(image:UIImage, result:@escaping(String) -> Void) {
        StatusManager.shared.loadingStatus = .ShowWithUntouchableUnlimited
        
        ApiControl.uploadImage(image: image)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("\n--- userInfoUpdate error ---\n\(error.localizedDescription)\n")
                
                self.alertMessage = error.message
                self.showAlert = true
                
                result("")
                
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                
                self.rightItemsState = true
                print("SUCCESS\(self.rightItemsState)")
                print("SUCCESS!!!!!!!")

                if value.success, value.result.id.count > 0 {
                    result(value.result.id)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                    
                    result("")
                }
            }.store(in: &canclelables)
    }
    
    func requestClubBasic(clubId: String) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.clubBasic(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                self.alertMessage = error.message
                self.showAlert = true
                print("clubBasic error : \(error)")
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                
                self.profileImg = value.profileImg
                self.myClubName = value.clubName
                self.profileImg = value.profileImg
     
                print("clubBasic value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestMyClubBasicList() {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubBasic(integUid: UserManager.shared.uid, nextId: "10", size: "10")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("MyClubBasicList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.myClubBasicCount = value.listSize ?? 0
                self.myClubBasicListData = value
                guard let noMyClubBasicListData = self.myClubBasicListData else {
                    return
                }
                self.clubBasicListData = noMyClubBasicListData.clubList
                
                print("MyClubBasicList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestMyClubFavorite(clubId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubFavorite(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("MyClubFavorite error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.favoriteYn = value.favoriteYn
                
                print("MyClubFavorite value : \(value)")
            }
            .store(in: &canclelables)
    }
    

    
    func requestMyClubStorageCount(clubId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubStorageCount(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubStorageCount error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.isPageLoading = false
                
                self.postCount = value.postCount
                self.replyCount = value.replyCount
                self.bookmarkCount = value.bookmarkCount
                
                print("ClubStorageCount value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    
    func requestClubMemberDetailClubStorageCount() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubStorageCount(integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubStorageCount error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.isPageLoading = false
                
                self.postCount = value.postCount
                self.replyCount = value.replyCount
                self.bookmarkCount = value.bookmarkCount
                
                print("ClubStorageCount value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestMyClubStorageReply(result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubStorageReply(integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("ClubStorageReply error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                result(true)

                self.clubStorageReplyData = value
                guard let noClubStorageReplyData = self.clubStorageReplyData else {
                    return
                }
                self.clubStorageReplyListData = noClubStorageReplyData.replyList
                
                print("ClubStorageReply value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestMyClubStorageBookmark(result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubStorageBookmark(integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)

                print("ClubStorageBookmark error : \(error)")
            } receiveValue: { value in
                
                self.loadingStatus = .Close
                result(true)

                self.clubStorageBookmarkData = value
                guard let noClubStorageBookmarkData = self.clubStorageBookmarkData else {
                    return
                }
                self.clubStorageBookmarkListData = noClubStorageBookmarkData.postList
                
                print("ClubStorageBookmark value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestMyClubStoragePost(result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubStoragePost(integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)

                print("ClubStoragePost error : \(error)")
            } receiveValue: { value in
                
                self.loadingStatus = .Close
                result(true)

                self.clubStoragePostData = value
                guard let noClubStoragePostData = self.clubStoragePostData else {
                    return
                }
                self.clubStoragePostListData = noClubStoragePostData.postList
                
                print("ClubStoragePost value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubMemberList(clubId: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberList(clubId: clubId, integUid: UserManager.shared.uid, nextId: "", size: "")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("ClubMemberList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                result(true)
                self.clubMemberData = value
                guard let noclubMemberListData = self.clubMemberData else {
                    return
                }
                self.clubMemberListData = noclubMemberListData.memberList
                self.memberListSize = value.listSize ?? 0
                
                print("ClubMemberList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubMemberFollow() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberFollow(clubId: "58", integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberFollow error : \(error)")
            } receiveValue: { value in
                
                self.loadingStatus = .Close
                print("ClubMemberFollow value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubMemberDetail(clubId: String, memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberDetail(clubId: clubId, integUid: UserManager.shared.uid, memberId: memberId)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                self.alertMessage = error.message
                self.showAlert = true
                print("ClubMemberDetail error : \(error)")
            } receiveValue: { value in
                
                self.loadingStatus = .Close
                
                self.profileImg = value.profileImg
                self.nickname = value.nickname
                self.memberLevel = value.memberLevel
                if self.memberLevel == 20 {
                    self.memberLevelName = "k_club_president".localized
                }
                else {
                    self.memberLevelName = "a_general_membership".localized
                }
                self.memberId = value.memberId
                
                print("ClubMemberDetail value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubMemberFollowPatch() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberFollowPatch(clubId: "58", checkToken: "ABCDEFGH1234567890", favoriteYn: true, integUid: UserManager.shared.uid, nickname: "n_nickname".localized, profileImg: "ABCDEFGH1234567890")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberFollowPatch error : \(error)")
            } receiveValue: { value in
                
                self.loadingStatus = .Close
                print("ClubMemberFollowPatch value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubMemberWithdrwal() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberWithdrwal(clubId: "58", integUid: UserManager.shared.uid, joinYn: true)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberWithdrwal error : \(error)")
            } receiveValue: { value in
                
                self.loadingStatus = .Close
                print("ClubMemberWithdrwal value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubMemberEdit(clubId: String, checkToken: String = "", integUid: String, nickname: String = "", profileImg: String = "", result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberEdit(clubId: clubId, checkToken: checkToken, integUid: integUid, nickname: nickname, profileImg: profileImg)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                self.alertMessage = error.message
                self.showAlert = true
                
                result(false)
                print("ClubMemberEdit error : \(error)")
            } receiveValue: { value in
                
                self.loadingStatus = .Close
                
                result(true)
                print("ClubMemberEdit value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubMemberNicknameCheck(clubId: String, nickName: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberNicknameCheck(clubId: clubId, nickname: nickName)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                self.alertMessage = error.message
                self.showAlert = true
                result(false)
                print("ClubMemberNicknameCheck error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.nickname = nickName
                self.existYn = value.existYn
                self.nicknameCheckToken = value.checkToken
                
                result(true)

                //중복이 아니면
                if !self.existYn {
                    self.nickNameCorrectStatus = .Correct
                    self.checkNickNameWarning = "se_s_can_use_nickname".localized
                    self.rightItemsState = true
                }
                else {
                    self.nickNameCorrectStatus = .Wrong
                    self.checkNickNameWarning = "se_j_duplicate_rewrite".localized
                }
//                se_a_already_use_nickname
                print("ClubMemberNicknameCheck value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func myClubMemberPostList(memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubMemberPostList(clubId: "58", integUid: UserManager.shared.uid, memberId: memberId, nextId: "1", size: "10")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberPostList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.clubStorageMemberPostData = value
                guard let noClubStorageMemberPostData = self.clubStorageMemberPostData else {
                    return
                }
                self.clubStorageMemberPostListData = noClubStorageMemberPostData.postList
                
                print("ClubMemberPostList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func myClubMemberReplyList(memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.myClubMemberReplyList(clubId: "58", integUid: UserManager.shared.uid, memberId: memberId, nextId: "1", size: "10")
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberReplyList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.clubStorageMemberReplyData = value
                guard let noClubStorageMemberReplyData = self.clubStorageMemberReplyData else {
                    return
                }
                self.clubStorageMemberReplyListData = noClubStorageMemberReplyData.replyList
                
                print("ClubMemberReplyList value : \(value)")
            }
            .store(in: &canclelables)
        
    }
    
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
                self.myClubName = value.clubName
                
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
                    print("###\(self.clubOpenDate)")
                }
                
                self.openYn = value.openYn
                
                print("ClubManage value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubJoinMemberList(clubId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubJoinMemberList(clubId: clubId, integUid: UserManager.shared.uid, nextId: "1", size: "10")
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
    
    func requestClubJoinMemberApproval(clubId: String, joinIdList: [Int]) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubJoinMemberApproval(clubId: clubId, integUid: UserManager.shared.uid, joinIdList: joinIdList)
            .sink { error in
                self.loadingStatus = .Close
                self.requestClubJoinMemberList(clubId: clubId)
                guard case let .failure(error) = error else { return }

                print("ClubJoinMemberApproval error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                print("ClubJoinMemberApproval value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubJoinMemberRejection(clubId: String, joinIdList: [Int]) {
        loadingStatus = .ShowWithTouchable
        ApiControl.ClubJoinMemberRejection(clubId: clubId, integUid: UserManager.shared.uid, joinIdList: joinIdList)
            .sink { error in
                self.loadingStatus = .Close
                self.requestClubJoinMemberList(clubId: clubId)
                guard case let .failure(error) = error else { return }

                print("ClubJoinMemberApproval error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                print("ClubJoinMemberApproval value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func clubMemberForceLeave(memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberForceLeave(clubId: "64", memberId: memberId, integUid: UserManager.shared.uid, joinYn: true)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubMemberForceLeave error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                print("ClubMemberForceLeave value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func clubDelegateRequest(memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubDelegateRequest(clubId: "58", memberId: memberId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubDelegateRequest error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                print("ClubDelegateRequest value : \(value)")
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
    
    func requestClubDelegateCancel(memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubDelegateCancel(clubId: "58", memberId: memberId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubDelegateCancel error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                print("ClubDelegateCancel value : \(value)")
            }
            .store(in: &canclelables)
    }

    func requestClubBlockMember(memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubBlockMember(clubId: "58", memberId: memberId, categoryCode: "", integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubBlockMember error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                print("ClubBlockMember value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubBlockCheck(memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubBlockCheck(clubId: "64", memberId: memberId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }

                print("ClubBlockCheck error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.blockYn = value.blockYn
                print("ClubBlockCheck value : \(value)")
            }
            .store(in: &canclelables)
    }
    
}

//self.replyId =
//self.parentReplyId =
//self.clubId =
//self.content =
//self.createDate =
//self.replyOfReplyCount =
//self.nickname =
//self.status =
//self.profileImg =
//self.clubName =
//self.subject =
//self.categoryCode =
//    @Published var replyId: Int = 0
//    @Published var parentReplyId: Int = 0
//    @Published var clubId: Int = 0
//    @Published var content: String = ""
//    @Published var createDate: String = ""
//    @Published var replyOfReplyCount: Int = 0
//    @Published var nickname: String = ""
//    @Published var status: Int = 0
//    @Published var profileImg: String = ""
//    @Published var clubName: String = ""
//    @Published var subject: String = ""
//    @Published var categoryCode: String = ""
