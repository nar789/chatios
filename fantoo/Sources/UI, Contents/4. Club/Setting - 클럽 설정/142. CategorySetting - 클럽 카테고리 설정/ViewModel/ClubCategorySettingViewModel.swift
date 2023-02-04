//
//  ClubCategorySettingViewModel.swift
//  fantoo
//
//  Created by fns on 2022/12/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine


class ClubCategorySettingViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var clubInterestModel: ClubInterestModel?
    @Published var clubInterestList = [ClubInterestList]()
    @Published var selectedInterests: [Int] = []
    
    //errorAlert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    
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
