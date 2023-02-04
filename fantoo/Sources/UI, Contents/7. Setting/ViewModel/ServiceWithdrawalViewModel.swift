//
//  ServiceWithdrawalViewModel.swift
//  fantoo
//
//  Created by fns on 2022/09/29.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class ServiceWithdrawalViewModel: ObservableObject {
    
    //join data
    @Published var isAllAgree: Bool = false
    @Published var isAdAgree: Bool = false

    private var canclelables = Set<AnyCancellable>()
    
    //MARK: - Request
    func requestUserWithdrawal(integUid: String) {
        ApiControl.userWithdrawal(integUid: integUid)
            .sink { error in
                print("UserWithdrawal error : \(error)")
     
            } receiveValue: { value in
                UserManager.shared.accessToken = ""
                UserManager.shared.refreshToken = ""
                
                print("UserWithdrawal value : \(value)")

            }
            .store(in: &canclelables)
    }
  
}
