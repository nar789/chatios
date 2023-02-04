//
//  ChangeNickNameViewModel.swift
//  fantoo
//
//  Created by mkapps on 2022/10/27.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ChangeNickNameViewModel: ObservableObject {
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var textNickname:String = ""
    @Published var warning:String = "se_n_change_nickname_notice_2".localized
    @Published var correctStatus:CheckCorrectStatus = .Check
    @Published var isKeyboardEnter: Bool = false
    @Published var isCheckUsable: Bool = false
    
    private var canclelables = Set<AnyCancellable>()
    
    
    //request
    func requestCheckNickName(nickName: String) {
        
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.checkNickName(nickName: nickName)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
                self.alertMessage = error.message
                self.showAlert = true
                self.isCheckUsable = false
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                let isCheck = value.isCheck
                
                //중복이 아니면
                if !isCheck {
                    self.alertMessage = "se_s_can_use_nickname".localized
                    self.showAlert = true
                    self.isCheckUsable = true
                }
                else {
                    self.alertMessage = "se_a_already_use_nickname".localized
                    self.showAlert = true
                    self.isCheckUsable = false
                }
            }
            .store(in: &canclelables)
    }
    
    func requestUserInfoUpdate(userInfoType: UserInfoType, birthDay: String = "", countryIsoTwo: String = "", genderType: String = "", interestList: Array<String> = [], userNick: String = "", userPhoto: String = "", result:@escaping(Bool) -> Void) {
        
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        
        ApiControl.userInfoUpdate(userInfoType: userInfoType.rawValue, birthDay: birthDay, countryIsoTwo: countryIsoTwo, genderType: genderType, interestList: interestList, userNick: userNick, userPhoto: userPhoto, integUid: UserManager.shared.uid)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("\n--- userInfoUpdate error ---\n\(error)\n")
                
                self.alertMessage = error.message
                self.showAlert = true
                
                result(false)
                
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                result(true)
            }.store(in: &canclelables)
    }
}
