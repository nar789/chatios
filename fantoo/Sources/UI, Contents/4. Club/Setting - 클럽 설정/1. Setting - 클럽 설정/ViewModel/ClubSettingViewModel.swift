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
    
    @Published var clubStorageMemberBookmarkData: ClubStorageBookmarkData?
    @Published var clubStorageMemberBookmarkListData = [ClubStorageBookmarkListData]()
    
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

    @Published var favoriteYn: Bool = false
                
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
//                self.profileImg = value.profileImg
     
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
    
    func clubMemberForceLeave(clubId: String, memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubMemberForceLeave(clubId: clubId, memberId: memberId, integUid: UserManager.shared.uid, joinYn: true)
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
    
    func clubDelegateRequest(clubId: String, memberId: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubDelegateRequest(clubId: clubId, memberId: memberId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)

                print("ClubDelegateRequest error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                result(true)

                print("ClubDelegateRequest value : \(value)")
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
    ////여기
    func requestClubDelegateCancel(clubId: String, memberId: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubDelegateCancel(clubId: clubId, memberId: memberId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("ClubDelegateCancel error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                result(true)
                print("ClubDelegateCancel value : \(value)")
            }
            .store(in: &canclelables)
    }

    func requestClubBlockMember(clubId: String, memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubBlockMember(clubId: clubId, memberId: memberId, categoryCode: "", integUid: UserManager.shared.uid)
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
    
    func requestClubBlockCheck(clubId: String, memberId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubBlockCheck(clubId: clubId, memberId: memberId, integUid: UserManager.shared.uid)
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
