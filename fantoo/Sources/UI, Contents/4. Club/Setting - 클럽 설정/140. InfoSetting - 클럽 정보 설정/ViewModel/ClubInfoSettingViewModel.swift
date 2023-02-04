//
//  ClubInfoSettingViewModel.swift
//  fantoo
//
//  Created by fns on 2022/10/24.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ClubInfoSettingViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = false
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    //alert
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""

    @Published var clubCategoryData: ClubCategoryData?
    @Published var clubCategoryListData = [ClubCategoryListData]()
    @Published var clubCategoryDetailListData = [ClubCategoryDetailListData]()
    
    //공개설정
    @Published var open: String = ""
    @Published var openYn: Bool = false

    //가입승인
    @Published var memberJoinAuto: String = ""
    @Published var memberJoinAutoYn: Bool = false

    //멤버목록
    @Published var memberListOpen: String = ""
    @Published var memberListOpenYn: Bool = false

    //멤버수
    @Published var memberCountOpen: String = ""
    @Published var memberCountOpenYn: Bool = false

    //언어설정
    @Published var languageCode: String = ""
    @Published var languageName: String = ""

    //활동국가
    @Published var activeCountryCode: String = ""
    @Published var countryIsoTwo: String = ""
    
    var countryCode: String = ""
    var langCode: String = ""
    
    @Published var profileImg: String = ""
    @Published var bgImg: String = ""
    @Published var imgState: Bool = false
    @Published var clubName: String = ""
    @Published var officialClubName: String = ""
    @Published var introduction: String = ""

    @Published var hashtagList: [String] = []
    @Published var interestCategoryId: Int = 0
    
    @Published var clubId: Int = 0
    @Published var createDate: String = ""
    @Published var memberCount: Int = 0
    @Published var clubMasterNickname: String = ""
    
    @Published var existYn: Bool = false
    @Published var clubNameCheck: Bool = false
    @Published var checkToken: String = ""
    @Published var clubNameCheckText: String = ""
    
    @Published var rightItemsState: Bool = false
    
    @Published var clubInterestModel: ClubInterestModel?
    @Published var clubInterestList = [ClubInterestList]()
    @Published var selectedInterests: [Int] = []
    
    
    func setDisplayValues(countryCode: String = "", selectedCountryData: CountryListData? = nil, languageCode: String = "") {
        
        //국가
        if countryCode.count > 0 {
            if self.countryCode != countryCode {
                self.countryCode = countryCode
                
                if selectedCountryData != nil {
                    if LanguageManager.shared.getLanguageCode() == "ko" {
                        BottomSheetManager.shared.onPressClubCountry = selectedCountryData?.nameKr ?? ""
                    }
                    else {
                        BottomSheetManager.shared.onPressClubCountry = selectedCountryData?.nameEn ?? ""
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
                                BottomSheetManager.shared.onPressClubCountry = value.nameKr
                            }
                            else {
                                BottomSheetManager.shared.onPressClubCountry = value.nameEn
                            }
                        }.store(in: &self.canclelables)
                }
            }
        }
        else {
            self.countryCode = ""
//            self.activeCountryCode = ""
        }
        
        //언어
        if languageCode.count > 0 {
                let langName = LanguageManager.shared.langname(code: languageCode)
                self.languageName = langName
        }
    }
    
    //MARK: - Request
    func requestClubCategoryList() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubCategoryList(clubId: "81", integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                
                print("ClubCategoryList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.clubCategoryData = value
                guard let noClubCategoryData = self.clubCategoryData else {
                    return
                }
                self.clubCategoryListData = noClubCategoryData.categoryList
               
                print("ClubCategoryList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubFullInfoList(clubId: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubFullInfo(clubId: clubId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("ClubFullInfoList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
            
                print("ClubFullInfoList value : \(value)")
                
                if value.openYn {
                    self.open = "g_open_public".localized
                }
                else {
                    self.open = "b_hidden".localized
                }
                self.openYn = value.openYn

                if value.memberJoinAutoYn {
                    self.memberJoinAuto = "j_auto".localized
                }
                else {
                    self.memberJoinAuto = "s_approval".localized
                }
                self.memberJoinAutoYn = value.memberJoinAutoYn
                
                if value.memberListOpenYn {
                    self.memberListOpen = "g_open_public".localized
                }
                else {
                    self.memberListOpen = "b_hidden".localized
                }
                self.memberListOpenYn = value.memberListOpenYn
                
                if value.memberCountOpenYn {
                    self.memberCountOpen = "g_open_public".localized
                }
                else {
                    self.memberCountOpen = "b_hidden".localized
                }
                self.memberCountOpenYn = value.memberCountOpenYn
        
                self.languageCode = value.languageCode
                self.setDisplayValues(languageCode: value.languageCode)
                
                self.countryIsoTwo = value.activeCountryCode
                self.activeCountryCode = value.activeCountryCode
                self.setDisplayValues(countryCode: value.activeCountryCode)
                
                self.bgImg = value.bgImg
                self.profileImg = value.profileImg
                self.clubName = value.clubName
                self.officialClubName = value.clubName
                self.introduction = value.introduction
                self.interestCategoryId = Int(value.interestCategoryId) ?? 0
                
                if self.existYn && self.introduction.count > 0 && self.profileImg.count > 0 && self.bgImg.count > 0 {
                    self.rightItemsState = true
                }

                result(true)
            }
            .store(in: &canclelables)
    }
    
    func requestClubNameCheck(clubName: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubNameCheck(clubName: clubName)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("ClubNameCheck error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                self.existYn = value.existYn
                self.checkToken = value.checkToken
                if self.existYn {
                    self.clubNameCheckText = "se_a_already_used_club_name".localized
                }
                else {
                    self.clubNameCheckText = "se_s_use_possible_club_name".localized
                }
                self.clubNameCheck = true
                
                if self.existYn && self.introduction.count > 0 && self.profileImg.count > 0 && self.bgImg.count > 0 {
                    self.rightItemsState = true
                }
                result(true)
                print("ClubNameCheck value : \(value)")
            }
            .store(in: &canclelables)
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
    
    func requestClubInfoEdit(clubId: String, activeCountryCode: String = "", bgImg: String = "", checkToken: String = "", clubName: String = "", integUid: String, interestCategoryId: Int = 0, introduction: String = "", languageCode: String = "", memberCountOpenYn: Bool = false, memberJoinAutoYn: Bool = false, memberListOpenYn: Bool = false, openYn: Bool = false, profileImg: String = "", result:@escaping(Bool) -> Void)  {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubInfoEdit(clubId: clubId, activeCountryCode: activeCountryCode, bgImg: bgImg, checkToken: checkToken, clubName: clubName, integUid: integUid, interestCategoryId: interestCategoryId, introduction: introduction, languageCode: languageCode, memberCountOpenYn: memberCountOpenYn, memberJoinAutoYn: memberJoinAutoYn, memberListOpenYn: memberListOpenYn, openYn: openYn, profileImg: profileImg)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                self.alertMessage = error.message
                self.showAlert = true
                result(false)
                print("ClubInfoEdit error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                result(true)

                print("ClubInfoEdit value : \(value)")
            }
            .store(in: &canclelables)
    }
}
