//
//  PasswordChangeViewModel.swift
//  fantoo
//
//  Created by fns on 2022/09/29.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class PasswordChangeViewModel: ObservableObject {
    
    @Published var isMatchePw: Bool = false
    @Published var isChanged: Bool = false
                
    private var canclelables = Set<AnyCancellable>()
    
    //MARK: - Request
    func requestCheckPassword(integUid: String, loginPw: String) {
        ApiControl.checkUserPassword(integUid: integUid, loginPw: loginPw)
            .sink { error in
                print("CheckPassword error : \(error)")
            } receiveValue: { value in
                print("CheckPassword value : \(value)")
                    self.isMatchePw = value.isMatchePw
                print("#####\(self.isMatchePw)")
            }
            .store(in: &canclelables)
    }
    
    //MARK: - Request
    func requestChangePassword(integUid: String, loginPw: String) {
        ApiControl.changePassword(integUid: integUid, loginPw: loginPw)
            .sink { error in
                print("ChangePassword error : \(error)")
            } receiveValue: { value in
                print("ChangePassword value : \(value)")
            }
            .store(in: &canclelables)
    }
}

