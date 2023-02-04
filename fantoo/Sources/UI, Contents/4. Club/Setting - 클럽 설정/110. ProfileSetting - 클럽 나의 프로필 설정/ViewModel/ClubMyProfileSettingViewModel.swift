//
//  ClubMyProfileSettingViewModel.swift
//  fantoo
//
//  Created by fns on 2022/11/07.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ClubMyProfileSettingViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    @Published var isPageLoading: Bool = false
    @Published var loadingStatus: LoadingStatus = .Close
    
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

    @Published var nickname: String = ""

    
    
    
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
    
}
