//
//  InviteFriendViewModel.swift
//  fantoo
//
//  Created by fns on 2022/09/29.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class InviteFriendViewModel: ObservableObject {
    
    @StateObject var languageManager = LanguageManager.shared
    
    @Published var image = UIImage()
    @Published var isUnqualifiedImageFormats: Bool = false // (true : 등록 못 함)
    @Published var isUnqualifiedImageSize: Bool = false  // (true : 등록 못 함)
    @Published var showSheet = false
    
    @Published var nickname: String = "s_select".localized
    @Published var gender: String = "s_select".localized
    @Published var country: String = "s_select".localized
    @Published var birthDay: String = "s_select".localized
    @Published var interest: [String] = []
    @Published var interestArray: Array<Any> = []
    @Published var userInfoType: UserInfoType = .gender
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var showAlertSuccess: Bool = false
    
    @Published var referralCode: String = ""

    var canclelables = Set<AnyCancellable>()
    
    func requestMyReferral(integUid: String, referralCode: String) {
        
        ApiControl.myReferral(integUid: integUid, referralCode: referralCode)
            .sink { error in
                
                guard case let .failure(error) = error else { return }
                print("getInterestList error : \(error)")
                
                self.showAlert = true
                self.alertMessage = error.message
                
                print("getMyReferral error : \(error)")
            } receiveValue: { value in
        
                self.showAlert = true
                
                print("getMyReferral value : \(value)")
               
            }.store(in: &canclelables)
    }
    
    func requestMyReferralCreate(integUid: String) {
        
        ApiControl.myReferralCreate(integUid: integUid)
            .sink { error in
                
                print("myReferralCreate error : \(error)")
            } receiveValue: { value in
        
                self.referralCode = value.referralCode
                print("myReferralCreate value : \(value)")
               
            }.store(in: &canclelables)
    }
    
    
    
    
}
