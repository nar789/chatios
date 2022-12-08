//
//  JoinCertificationEmailViewModel.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/11.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class JoinCertificationEmailViewModel: ObservableObject {
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var isNextStep: Bool = false
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var timeRemaining: Int = 0
    private var timer: Timer?
    
    func startRemaining() {
        timeRemaining = 60 * 10
        startTimer()
    }
    
    
    //MARK: - Request
    func sendEmailNumberCheck(authCode: String, loginId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.sendEmailNumberCheck(authCode: authCode, loginId: loginId)
            .sink { error in
                self.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("login error : \(error)")
                
                self.alertTitle = ""
                self.alertMessage = error.message
                self.showAlert = true
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                let isCheck = value.isCheck
                if isCheck {
                    self.isNextStep = true
                }
                else {
                    //성공이 아니면 에러
                    self.alertTitle = ""
                    self.alertMessage = "se_a_not_match_cert_number".localized
                    self.showAlert = true
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
                self.startRemaining()
            }
            .store(in: &canclelables)
    }
    
    
    //MARK: - timer
    func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if timer != nil, timer!.isValid {
            timer!.invalidate()
        }
    }
    
    @objc func checkTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        }
        else {
            timeRemaining = 0
            stopTimer()
        }
    }
}
