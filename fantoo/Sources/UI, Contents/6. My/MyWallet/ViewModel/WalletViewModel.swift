//
//  WalletViewModel.swift
//  NotificationService
//
//  Created by fns on 2022/10/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class WalletViewModel: ObservableObject {
                
    private var canclelables = Set<AnyCancellable>()
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var userWalletTypeData: UserWalletTypeData?
    @Published var walletListData = [WalletListData]()
    
    @Published var walletList: String = "j_all".localized
    @Published var selectedSeq: Int = 0
    @Published var fanit: String = ""
    @Published var comment: String = ""
    @Published var createDate: String = ""
    @Published var historyId: Int = 0
    @Published var monthAndDate: String = ""
    @Published var title: String = ""
    @Published var value: Int = 0
    
    @Published var date = Date()
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    
    
    //MARK: - Reqeust

    func requestUserWallet(integUid: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.userWallet(integUid: integUid)
            .sink { error in
                self.loadingStatus = .Close
                
                print("UserWallet error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.fanit = "\(value.fanit)"
                print("UserWallet value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestUserWalletType(integUid: String, nextId: Int, size: Int, walletListType: WalletListType, walletType: WalletType, yearMonth: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.userWalletType(integUid: integUid, nextId: 0, size: 10, walletListType: walletListType.rawValue, walletType: walletType.rawValue, yearMonth: yearMonth)
            .sink { error in
                self.loadingStatus = .Close
                
                
                guard case let .failure(error) = error else { return }
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
                
                print("UserWallet error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.userWalletTypeData = value
                guard let noUserWalletTypeData = self.userWalletTypeData else {
                    return
                }
                self.walletListData = noUserWalletTypeData.walletList
                
                print("UserWallet value : \(value)")
            }
            .store(in: &canclelables)
    }
}
