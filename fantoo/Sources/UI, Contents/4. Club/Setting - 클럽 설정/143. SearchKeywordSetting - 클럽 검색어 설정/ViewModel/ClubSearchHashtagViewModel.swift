//
//  ClubSearchHashtagViewModel.swift
//  fantoo
//
//  Created by fns on 2022/11/10.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ClubSearchHashtagViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = false
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var clubCategoryData: ClubHashtagData?
    @Published var clubSearchHashTag: ClubSearchHashTag?
    @Published var tagList: [ClubSearchHashTag] = []
    @Published var saveHashtagList: [String] = []
    @Published var hashtagList: [String] = []

    
    //errorAlert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    func requestClubHashtag(clubId: String, integUid: String, result:@escaping(Bool) -> Void) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.clubHashtag(clubId: clubId, integUid: integUid)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                self.alertMessage = error.message
                self.showAlert = true
                print("clubHashtag error : \(error)")
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                result(true)
                self.saveHashtagList = value.hashtagList
                self.hashtagList = value.hashtagList
                
                if self.hashtagList.count > 0 {
                    for list in self.hashtagList {
                        self.tagList.append(ClubSearchHashTag(text: list))
                    }
                }
              
                print("clubHashtag value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestClubAddHashtag(clubId: String, hashtagList: [String], integUid: String, result:@escaping(Bool) -> Void) {
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        ApiControl.clubAddHashtag(clubId: clubId, hashtagList: hashtagList, integUid: integUid)
            .sink { error in
                StatusManager.shared.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                self.alertMessage = error.message
                self.showAlert = true
                print("addClubHashtag error : \(error)")
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                result(true)
          
                print("addClubHashtag value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    
    
    
}
