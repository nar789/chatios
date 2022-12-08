//
//  MainClubSearchViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/01.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import CoreData

class MainClubSearchViewModel: ObservableObject {
    /**
     * TextField
     */
    @Published var searchText: String = ""
    @Published var isKeyboardEnter: Bool = false
    /**
     * CoreData
     */
    let context = SearchWordPersistenceController.shared.container.viewContext
    @Published var arrSearchText: [NSManagedObject] = []
    @Published var selectedObj = NSManagedObject()
    /**
     * API Call
     */
    var canclelables = Set<AnyCancellable>()
    @Published var isPageLoading: Bool = true
    @Published var mainClub_MainPage: MainClub_MainPage?
    @Published var mainClub_MainPage_MyClub = [MainClub_MainPage_MyClub]()
    /**
     * Viewer
     */
    @Published var showInitView = false
    
    init() {
        readLocalSearchData()
    }
    
    /**
     * CoreData
     */
    func getValue(obj: NSManagedObject) -> String {
        return obj.value(forKey: "mainClubWord") as! String
    }
    func readLocalSearchData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MainClub_SearchWordData")    // SearchWord.xcdatamodeld 에서 ENTITIES 이름

        do {
            let results = try context.fetch(request)
            self.arrSearchText = results as! [NSManagedObject]
            
            // 초기 화면 보여주기
            self.showInitView = true
        } catch {
            print(error.localizedDescription)
        }
    }
    func writeLocalSearchData() {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "MainClub_SearchWordData", into: context)
        entity.setValue(searchText, forKey: "mainClubWord")
        searchText = ""
        
        do {
            try context.save()
            self.arrSearchText.append(entity)
            
            // 검색 결과 화면 보여주기
            self.showInitView = false
        } catch  {
            print(error.localizedDescription)
        }
    }
    func deleteLocalSearchData(index: Int) {
        do {
            let obj = arrSearchText[index]
            context.delete(obj)
            try context.save()
            
            let index = arrSearchText.firstIndex(of: obj)
            arrSearchText.remove(at: index!)
        } catch {
            print(error.localizedDescription)
        }
    }
    func deleteLocalSearchAllData() {
        for index in 0..<arrSearchText.count {
            /**
             * 1. 먼저 CoreData 저장된 단어를 하나씩 지우고
             */
            do {
                let obj = arrSearchText[index]
                context.delete(obj)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        /**
         * 2. arrSearchText 배열에 저장된 단어들을 통째로 지운다
         */
        arrSearchText.removeAll()
    }
    
    
    
    /**
     * API Call
     */
    func getMainClub_MyPage() {
        ApiControl.getMainClub_MyPage()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                StatusManager.shared.loadingStatus = .Close
                
                self.mainClub_MainPage = value
                guard let NOmainClub_MainPage = self.mainClub_MainPage else {
                    // The 'value' is nil
                    return
                }
                
                self.mainClub_MainPage_MyClub = NOmainClub_MainPage.data.myclub
            }
            .store(in: &canclelables)
    }
    
    func getSearchResult() {
        // 로딩 시작
        self.isPageLoading = true
        
        ApiControl.getMainClub_MyPage()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                StatusManager.shared.loadingStatus = .Close
                
                self.mainClub_MainPage = value
                guard let NOmainClub_MainPage = self.mainClub_MainPage else {
                    // The 'value' is nil
                    return
                }
                
                self.mainClub_MainPage_MyClub = NOmainClub_MainPage.data.myclub
            }
            .store(in: &canclelables)
    }
    
}
