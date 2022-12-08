//
//  MenuViewModel_new.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/10/24.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class MenuViewModel_N: ObservableObject {
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var profileUrl: String = "" { didSet { checkStepValue() } }
    @Published var nickName: String = "" { didSet { checkStepValue() } }
    @Published var countryCode: String = "" { didSet { checkStepValue() } }
    @Published var gender: String = "" { didSet { checkStepValue() } }
    @Published var birthDay: String = "" { didSet { checkStepValue() } }
    @Published var interests: [String] = [] { didSet { checkStepValue() } }
    
    @Published var myPostCount: String = "0"
    @Published var myCommentCount: String = "0"
    @Published var savedPostCount: String = "0"
    
    @Published var stepValue:Int = 0
    
    
    var canclelables = Set<AnyCancellable>()
    
    
    //MARK: - Method
    func reset() {
        profileUrl = ""
        nickName = ""
        countryCode = ""
        gender = ""
        birthDay = ""
        interests = []
        
        myPostCount = "0"
        myCommentCount = "0"
        savedPostCount = "0"
        
        stepValue = 0
    }
    
    func checkStepValue() {
        var step = 0
        
        if self.profileUrl.count > 0 {
            step += 1
        }
        
        if self.nickName.count > 0 {
            step += 1
        }
        
        if self.countryCode.count > 0 {
            step += 1
        }
        
        if self.gender.count > 0 {
            step += 1
        }
        
        if self.birthDay.count > 0 {
            step += 1
        }
        
        if self.interests.count > 0 {
            step += 1
        }
        
        stepValue = step
    }
    
    
    //MARK: - Request
    func requestUserInfo() {
        loadingStatus = .ShowWithTouchable
        ApiControl.myInfo(integUid: UserManager.shared.uid)
            .sink { error in
                print("getUserInfo error : \(error)")
                self.loadingStatus = .Close
            } receiveValue: { value in
                print("getUserInfo value : \(value)")
                self.loadingStatus = .Close
                
                self.profileUrl = value.userPhoto ?? ""
                self.nickName = value.userNick ?? ""
                self.countryCode = value.countryIsoTwo ?? ""
                self.gender = value.genderType ?? ""
                self.birthDay = value.birthDay ?? ""
                self.interests = value.interestList.map{$0.code}
                
                self.checkStepValue()

            }.store(in: &canclelables)
    }
    
    func requestUserMenuStorage() {
        loadingStatus = .ShowWithTouchable
        ApiControl.userMenuStorage(integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                
                print("UserMenuStorage error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.myPostCount = "\(value.postCnt)"
                self.myCommentCount = "\(value.replyCnt)"
                self.savedPostCount = "\(value.bookmarkCnt)"
                
                print("UserMenuStorage value : \(value)")
            }
            .store(in: &canclelables)
    }

}
