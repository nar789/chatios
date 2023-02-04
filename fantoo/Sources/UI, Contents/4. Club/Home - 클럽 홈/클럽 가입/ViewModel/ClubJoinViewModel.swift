//
//  ClubJoinViewModel.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/27.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ClubJoinViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var showAlert: Bool = false
    @Published var showJoinAlert: Bool = false
    
    @Published var isPageLoading: Bool = true
    @Published var showProfileImagePicker = false
    
    @Published var profileImg: String? = nil
    
    @Published var nickname: String = ""
    @Published var nicknameOkStep = 1
    @Published var correctStatus: CheckCorrectStatus = .Check
    @Published var isKeyboardEnter: Bool = false

    @Published var checkNicknameResponse: ClubNicknameCheck?
    @Published var clubJoinResponse: ClubHomeJoinResponse?

    
    var joinMessage: NSAttributedString? = nil
    
    
    
    func requestUploadImage(image: UIImage, result: @escaping(String) -> Void) {
        StatusManager.shared.loadingStatus = .ShowWithUntouchableUnlimited
        
        ApiControl.uploadImage(image: image)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("\n--- userInfoUpdate error ---\n\(error.localizedDescription)\n")
                
                self.errorMessage = error.message
                self.showErrorAlert = true
                
                result("")
                
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                
                if value.success, value.result.id.count > 0 {
                    result(value.result.id)
                }
                else {
                    self.errorMessage = ErrorHandler.getCommonMessage()
                    self.showErrorAlert = true
                    
                    result("")
                }
            }.store(in: &canclelables)
    }
    
    func checkClubNickname(clubId: String, nickname: String) {
        print("checkClubNickname : \(clubId)")
        ApiControl.clubNicknameCheck(clubId: clubId, nickname: nickname)
            .sink { error in
            } receiveValue: { value in
                self.checkNicknameResponse = value
                
                self.showAlert.toggle()
                
            }.store(in: &canclelables)
    }
    
    func clubJoin(clubId: String, nickname: String, profileImg: String?, result: @escaping(Bool) -> Void) {
        print("clubJoin : \(clubId)")
        let checkToken = checkNicknameResponse?.checkToken ?? ""
        ApiControl.clubJoin(clubId: clubId, nickname: nickname, checkToken: checkToken, profileImg: profileImg)
            .sink { completion in
                
            } receiveValue: { value in
                
                self.clubJoinResponse = value
            
                if let response = self.clubJoinResponse {
                    result(response.memberJoinAutoYn)
                }
                
            }.store(in: &canclelables)

    }
    
}

