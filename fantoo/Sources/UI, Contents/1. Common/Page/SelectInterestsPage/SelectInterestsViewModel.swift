//
//  SelectInterestsViewModel.swift
//  fantoo
//
//  Created by mkapps on 2022/10/24.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class SelectInterestsViewModel: ObservableObject {
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    @Published var interests = [InterestListCategoryData]()
    @Published var selectedInterests: [String] = []
    
    var canclelables = Set<AnyCancellable>()
    
    
    //Request
    func requestInterestList() {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.userInfoInterestList(integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken)
            .sink { error in
                
                StatusManager.shared.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("getInterestList error : \(error)")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                
                StatusManager.shared.loadingStatus = .Close
                
                self.interests = value.interestList
            }.store(in: &canclelables)
    }
    
    func requestUserInfoUpdate(userInfoType: UserInfoType, birthDay: String = "", countryIsoTwo: String = "", genderType: String = "", interestList: Array<String> = [], userNick: String = "", userPhoto: String = "", result:@escaping(Bool) -> Void) {
        
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        
        ApiControl.userInfoUpdate(userInfoType: userInfoType.rawValue, birthDay: birthDay, countryIsoTwo: countryIsoTwo, genderType: genderType, interestList: interestList, userNick: userNick, userPhoto: userPhoto, integUid: UserManager.shared.uid)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("\n--- userInfoUpdate error ---\n\(error)\n")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
                
                result(false)
                
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                result(true)
            }.store(in: &canclelables)
    }
}
