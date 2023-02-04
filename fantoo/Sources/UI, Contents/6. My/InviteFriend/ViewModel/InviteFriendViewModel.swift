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

    @Published var showAlert: Bool = false
    @Published var showSuccessAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var referralCode: String = ""

    var canclelables = Set<AnyCancellable>()
    
    func requestMyReferral(integUid: String, referralCode: String) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.myReferral(integUid: integUid, referralCode: referralCode)
            .sink { error in
                
                StatusManager.shared.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("getInterestList error : \(error)")
                
                self.showAlert = true
                self.alertMessage = error.message
                
                print("getMyReferral error : \(error)")
            } receiveValue: { value in
        
                self.showSuccessAlert = true
                StatusManager.shared.loadingStatus = .Close
                
                print("getMyReferral value : \(value)")
               
            }.store(in: &canclelables)
    }
    
    func requestMyReferralCreate(integUid: String) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.myReferralCreate(integUid: integUid)
            .sink { error in
                
                StatusManager.shared.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("myReferralCreate error : \(error)")
                
                self.showAlert = true
                self.alertMessage = error.message
            } receiveValue: { value in
        
                self.referralCode = value.referralCode
                StatusManager.shared.loadingStatus = .Close
                print("myReferralCreate value : \(value)")
               
            }.store(in: &canclelables)
    }
    
    
    
    
}
