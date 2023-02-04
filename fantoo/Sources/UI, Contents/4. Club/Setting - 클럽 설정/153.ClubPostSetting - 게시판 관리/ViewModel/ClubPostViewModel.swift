//
//  ClubPostVM.swift
//  fantoo
//
//  Created by fns on 2022/07/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ClubPostViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = false
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var draggedItem: ClubBoardCategoryListData?
    @Published var post: [ClubBoardCategoryListData] = []
    @Published var clubCategoryData: ClubBoardCategoryData?
//    @Published var clubCategoryListData = [ClubBoardCategoryListData]()
    @Published var createClubBoardListData: CreateClubBoardListData?
    
    @Published var boardCategoryCode: String = ""
    @Published var boardClubId: String = ""
    @Published var categoryName: String = ""
    @Published var categoryArray: [String] = []
    
    @Published var openYn: Bool = false
    @Published var boardType: Int = 0
    
    // DragAndDrop
    @Published var currentItem: ClubBoardCategoryListData?
    @Published var changedBoardList = [String]()
    @Published var isChangedList: Bool = false

    
    
    //MARK: - Request
    func requestClubCategoryList(clubId: String) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubBoardCategoryList(categoryCode: "archive", clubId: clubId, integUid: UserManager.shared.uid)
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
                
                self.boardCategoryCode = noClubCategoryData.categoryCode ?? ""
                self.boardClubId = noClubCategoryData.clubId ?? ""
                
                self.post = noClubCategoryData.categoryList
                print(self.post)

//                self.categoryArray = noClubCategoryData.categoryList
            }
            .store(in: &canclelables)
    }
    
    func requestCreateClubBoardList(categoryCode: String, clubId: String, boardType: Int, categoryName: String, openYn: Bool, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.createClubBoardList(categoryCode: categoryCode, clubId: clubId, boardType: boardType, categoryName: categoryName, integUid: UserManager.shared.uid, openYn: openYn)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("createClubBoardList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                self.createClubBoardListData = value
                
                result(true)
                print("createClubBoardList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestDeleteClubBoardList(categoryCode: String, clubId: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.deleteClubBoardList(categoryCode: categoryCode, clubId: clubId, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("createClubBoardList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                result(true)
                print("createClubBoardList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func requestSettingClubBoardList(categoryCode: String, clubId: String, boardType: Int, categoryName: String, integUid: String, openYn: Bool, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.settingClubBoardList(categoryCode: categoryCode, clubId: clubId, boardType: boardType, categoryName: categoryName, integUid: integUid, openYn: openYn)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("createClubBoardList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close

                result(true)
                print("createClubBoardList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func changeBoardList(categoryCode: String, clubId: String, categoryNameList: [String], integUid: String, result:@escaping(Bool) -> Void) {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubBoardListSortSetting(categoryCode: categoryCode, clubId: clubId, categoryNameList: categoryNameList, integUid: UserManager.shared.uid)
            .sink { error in
                self.loadingStatus = .Close
                guard case let .failure(error) = error else { return }
                result(false)
                print("createClubBoardList error : \(error)")
            } receiveValue: { value in
                self.loadingStatus = .Close
                
                result(true)
                print("createClubBoardList value : \(value)")
            }
            .store(in: &canclelables)
    }
    
    func makeChangedBoardList(result:@escaping(Bool) -> Void) {
        for item in self.post {
            if let NOcategoryName = item.categoryName {
                self.changedBoardList.append(NOcategoryName)
            }
        }
        result(true)
    }
 
    func resetIsChangedList() {
        self.isChangedList = false
    }
}

