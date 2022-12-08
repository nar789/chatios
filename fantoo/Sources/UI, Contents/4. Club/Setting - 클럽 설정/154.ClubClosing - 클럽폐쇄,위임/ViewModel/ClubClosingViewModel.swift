//
//  ClubClosingViewModel.swift
//  fantoo
//
//  Created by fns on 2022/10/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ClubClosingViewModel: ObservableObject {
                
    private var canclelables = Set<AnyCancellable>()
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var closesStatus: Int = 0

    func requestClubClosingRequest() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubClosingRequest(clubId: "59", integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                print("ClubClosingRequest error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
        
                print("ClubClosingRequest value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubClosingCancel() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubClosingCancel(clubId: "59", integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                print("ClubClosingCancel error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                print("ClubClosingCancel value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    
    
}
