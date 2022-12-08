//
//  FindPasswordViewModel.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/10.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class FindPasswordViewModel: ObservableObject {
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    @Published var isNextStep: Bool = false
    
    private var canclelables = Set<AnyCancellable>()
    
    func tempPassword(loginId: String) {
        ApiControl.tempPassword(loginId: loginId)
            .sink { error in
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                if value.success {
                    self.isNextStep = true
                    return
                }
                
                //성공이 아니면 에러
                self.alertTitle = ""
                self.alertMessage = ErrorHandler.getCommonMessage()
                self.showAlert = true
            }
            .store(in: &canclelables)
    }
}
