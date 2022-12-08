//
//  MainClubNewClubViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/01.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class MainClubNewClubViewModel: ObservableObject {
    
    @Published var loadingStatus: LoadingStatus = .Close
    private var canclelables = Set<AnyCancellable>()
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    //clubNameCheck
    @Published var exist: Bool = false
    @Published var checkToken: String = ""
    @Published var checkDescription: String = ""
    @Published var correctStatus: CheckCorrectStatus = .Check
    @Published var isKeyboardEnter: Bool = false

    //creating a club
    @Published var activeCountryCode: String = ""
    @Published var countryIsoTwo: String = ""
    @Published var bgImg: String = ""
    @Published var clubName: String = ""
    @Published var integUid: String = ""
    @Published var interestCategoryId: Int = 0
    @Published var languageCode: String = LanguageManager.shared.languageCode
    @Published var languageName: String = LanguageManager.shared.languageName
    @Published var memberJoinAutoYn: Bool = false
    @Published var openYn: Bool = false
    @Published var profileImg: String = ""
    
    var countryCode: String = ""
    var langCode: String = ""
    @Published var displayCountry: String = ""
    
    @Published var clubInterestModel: ClubInterestModel?
    @Published var clubInterestList = [ClubInterestList]()
    @Published var selectedInterests: [Int] = []
    @Published var selectedInterestsName: [String] = []
    
    @Published var showBackgoundImagePicker = false
    @Published var showProfileImagePicker = false
    // 개인정보보호정책 동의 버튼 클릭 유무 확인
    @Published var isCheckPersonalInfo: Bool = false

    func CheckPersonalInfo() {
        self.isCheckPersonalInfo.toggle()
    }
    
    //MARK: - Method
    func setDisplayValues(countryCode: String = "", selectedCountryData: CountryListData? = nil, langCode: String = "", selectedLanguageData: LanguageListData? = nil) {
        
        //국가
        if countryCode.count > 0 {
            if self.countryCode != countryCode {
                self.countryCode = countryCode
                
                if selectedCountryData != nil {
                    if LanguageManager.shared.getLanguageCode() == "ko" {
                        self.activeCountryCode = selectedCountryData?.nameKr ?? ""
                    }
                    else {
                        self.activeCountryCode = selectedCountryData?.nameEn ?? ""
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
                                self.activeCountryCode = value.nameKr
                            }
                            else {
                                self.activeCountryCode = value.nameEn
                            }
                        }.store(in: &self.canclelables)
                }
            }
        }
        else {
            self.countryCode = ""
        }
        
        //주 언어
        if langCode.count > 0 {
            
            self.langCode = ""
            self.languageCode = LanguageManager.shared.languageCode
        }

    }
    
    //MARK: - Request
    
    func requestDefaultUserInfo() {
        ApiControl.myInfo(integUid: UserManager.shared.uid)
            .sink { error in
                print("getUserInfo error : \(error)")
                self.loadingStatus = .Close
            } receiveValue: { value in
                print("getUserInfo value : \(value)")
                self.loadingStatus = .Close
                self.countryIsoTwo = value.countryIsoTwo ?? ""
                
                self.setDisplayValues(countryCode: value.countryIsoTwo ?? "")
                self.activeCountryCode = value.countryIsoTwo ?? ""

            }.store(in: &canclelables)
    }
    
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
    
    func requestCreatingClubNameCheck(clubName: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.creatingClubNameCheck(clubName: clubName)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                
                self.alertMessage = error.message
                self.showAlert = true
                print("CreatingClubNameCheck error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                result(true)

                self.exist = value.existYn
                if self.exist {
                    self.correctStatus = .Wrong
                    self.checkDescription = "이미 사용중인 클럽명입니다.".localized
                }
                else {
                    self.correctStatus = .Correct
                    self.checkDescription = "사용 가능한 클럽명입니다.".localized
                }
                self.checkToken = value.checkToken

                print("CreatingClubNameCheck value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestCreatingClub(activeCountryCode: String, bgImg: String = "", checkToken: String, clubName: String, integUid: String, interestCategoryId: Int, languageCode: String, memberJoinAutoYn: Bool, openYn: Bool, profileImg: String = "", result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.creatingClub(activeCountryCode: activeCountryCode, bgImg: bgImg, checkToken: checkToken, clubName: clubName, integUid: integUid, interestCategoryId: interestCategoryId, languageCode: languageCode, memberJoinAutoYn: memberJoinAutoYn, openYn: openYn, profileImg: profileImg)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                
                self.alertMessage = error.message
                self.showAlert = true
                
                print("CreatingClub error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
            
                result(true)

                print("CreatingClub value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    
    func requestClubInterestList() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubInterestList()
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                print("clubInterestList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.clubInterestModel = value
                guard let noClubInterestModel = self.clubInterestModel else {
                    return
                }
                self.clubInterestList = noClubInterestModel.clubInterestCategoryDtoList

                print("clubInterestList value : \(value)")
            }
            .store(in: &canclelables)
    }

}
