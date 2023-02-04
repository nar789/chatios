//
//  JoinEmailViewModel.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/11.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class JoinEmailViewModel: ObservableObject {
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var isNextStep: Bool = false
    
    private var canclelables = Set<AnyCancellable>()
    
    func joinCheck(loginId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.joinCheck(loginId: loginId, loginType: LoginType.email.rawValue)
            .sink { error in
                
                self.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                let isUser = value.isUser
                if isUser {
                    //성공이 아니면 에러
                    self.alertTitle = ""
                    self.alertMessage = "se_a_already_use_email".localized
                    self.showAlert = true
                }
                //이메일 사용 가능.
                else {
                    self.sendEmail(loginId: loginId)
                }
            }
            .store(in: &canclelables)
    }
    
    func sendEmail(loginId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.sendEmail(loginId: loginId)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.isNextStep = true
            }
            .store(in: &canclelables)
    }
}
