//
//  SettingViewModel.swift
//  fantoo
//
//  Created by fns on 2022/09/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//
import Foundation
import Combine

class SettingViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var communityAgree: Bool = false
    @Published var clubAgree: Bool = false
    @Published var alimListData: AlimListData?
    @Published var alimClubConfigDtoList = [AlimClubConfigDtoList]()
    
    //MARK: - Request
    func requestAlim(integUid: String) {
        ApiControl.alim(integUid: integUid)
            .sink { error in
                print("Alim error : \(error)")
                
            } receiveValue: { value in
                self.communityAgree = value.comAgree ?? false
                
                self.alimListData = value
                guard let noAlimListData = self.alimListData else {
                    return
                }
                self.alimClubConfigDtoList = noAlimListData.alimClubConfigDtoList
                
                print("Alim value : \(value)")
                
            }
            .store(in: &canclelables)
    }
    
    func requestComAlimSetting(alimType: AlimType, integUid: String, result:@escaping(Bool) -> Void) {
        ApiControl.communityAlimSetting(alimType: alimType.rawValue, integUid: integUid)
            .sink { error in
                print("AlimSetting error : \(error)")
                result(false)
                
            } receiveValue: { value in
                self.communityAgree = value.comAgree
                result(true)

                print("AlimSetting value : \(value)")
                
            }
            .store(in: &canclelables)
    }
    
    func requestClubAlimSetting(alimType: AlimType, integUid: String, clubId: String, result:@escaping(Bool) -> Void) {
        ApiControl.clubAlimSetting(alimType: alimType.rawValue, integUid: integUid, clubId: clubId)
            .sink { error in
                print("AlimSetting error : \(error)")
                result(false)
                
            } receiveValue: { value in
                self.clubAgree = value.clubAgree
                result(true)

                print("AlimSetting value : \(value)")
                
            }
            .store(in: &canclelables)
    }
    
}
