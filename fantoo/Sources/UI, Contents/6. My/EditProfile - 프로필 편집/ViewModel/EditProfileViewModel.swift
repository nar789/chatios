//
//  EditProfileViewModel.swift
//  fantoo
//
//  Created by mkapps on 2022/10/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class EditProfileViewModel: ObservableObject {
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    //display
    var countryCode: String = ""
    
    @Published var displayCountry: String = ""
    @Published var displayGender: String = ""
    @Published var displayBirthDay: String = ""
    
    
    var canclelables = Set<AnyCancellable>()
    
    
    //MARK: - Method
    func setDisplayValues(countryCode: String, selectedCountryData: CountryListData? = nil, gender: String, birthDay: String) {
        
        //성별
        if gender == "female" {
            self.displayGender = "a_woman".localized
        }
        else if gender == "male" {
            self.displayGender = "n_man".localized
        }
        else {
            self.displayGender = "s_select".localized
        }
        
        
        //국가
        if countryCode.count > 0 {
            if self.countryCode != countryCode {
                self.countryCode = countryCode
                
                if selectedCountryData != nil {
                    if LanguageManager.shared.getLanguageCode() == "ko" {
                        self.displayCountry = selectedCountryData?.nameKr ?? ""
                    }
                    else {
                        self.displayCountry = selectedCountryData?.nameEn ?? ""
                    }
                }
                //api 콜해서 구해오자.
                else {
                    //국적
                    ApiControl.countryIsoTwoList(isoCode: self.countryCode)
                        .sink { error in
                            print("getIsoTwoList error : \(error)")
                        } receiveValue: { value in
                            print("getIsoTwoList value : \(value)")
                            if LanguageManager.shared.getLanguageCode() == "ko" {
                                self.displayCountry = value.nameKr
                            }
                            else {
                                self.displayCountry = value.nameEn
                            }
                        }.store(in: &self.canclelables)
                }
            }
        }
        else {
            self.countryCode = ""
            self.displayCountry = "s_select".localized
        }
        
        
        //생일
        if birthDay.count > 0 {
            self.displayBirthDay = birthDay.changeDateFormat(format: .isoDate, changeFormat: .isoDate)
        }
        else {
            self.displayBirthDay = "s_select".localized
        }
    }
    
    
    //MARK: - Request
    func requestUploadImage(image:UIImage, result:@escaping(String) -> Void) {
        StatusManager.shared.loadingStatus = .ShowWithUntouchableUnlimited
        
        ApiControl.uploadImage(image: image)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("\n--- userInfoUpdate error ---\n\(error.localizedDescription)\n")
                
                self.alertMessage = error.message
                self.showAlert = true
                
                result("")
                
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                
                if value.success, value.result.id.count > 0 {
                    result(value.result.id)
                }
                else {
                    self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                    
                    result("")
                }
            }.store(in: &canclelables)
    }
    
    func requestUserInfoUpdate(userInfoType: UserInfoType, birthDay: String = "", countryIsoTwo: String = "", genderType: String = "", interestList: Array<String> = [], userNick: String = "", userPhoto: String = "", result:@escaping(Bool) -> Void) {
        
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        
        ApiControl.userInfoUpdate(userInfoType: userInfoType.rawValue, birthDay: birthDay, countryIsoTwo: countryIsoTwo, genderType: genderType, interestList: interestList, userNick: userNick, userPhoto: userPhoto, integUid: UserManager.shared.uid)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                
                guard case let .failure(error) = error else { return }
                print("\n--- userInfoUpdate error ---\n\(error)\n")
                
                self.alertMessage = error.message
                self.showAlert = true
                
                result(false)
                
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                result(true)
            }.store(in: &canclelables)
    }
}
