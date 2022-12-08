//
//  MainCommunitySearchViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/07/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//


import Foundation
import Combine
import CoreData

class MainCommunitySearchViewModel: ObservableObject {
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
    @Published var isPageLoading: Bool = false
    @Published var mainCommunity_Search: Community_List?
    @Published var mainCommunity_Search_List = [Community_BoardItem]()

    /**
     * Viewer
     */
    @Published var showSearchWordListViewer = false
    @Published var showSearchResultViewer = false
    
    init() {
        readLocalSearchData()
    }
    
    /**
     * CoreData
     */
    func getValue(obj: NSManagedObject) -> String {
        return obj.value(forKey: "word") as! String
    }
    func readLocalSearchData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MainCommunity_SearchWordData")    // SearchWord.xcdatamodeld 에서 ENTITIES 이름

        do {
            let results = try context.fetch(request)
            self.arrSearchText = results as! [NSManagedObject]
            
            // 검색어 목록 Viewer 보여주기
            self.showSearchWordListViewer = true
        } catch {
            print(error.localizedDescription)
        }
    }
    func writeLocalSearchData() {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "MainCommunity_SearchWordData", into: context)
        entity.setValue(searchText, forKey: "word")
        //searchText = ""
        
        do {
            try context.save()
            self.arrSearchText.append(entity)
            
            // 검색어 목록 Viewer 숨기기
            self.showSearchWordListViewer = false
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
    func getMemberSearch(integUid: String, nextId: Int, search: String, size: Int, access_token: String) {
        // 로딩 시작
        self.isPageLoading = true
        
        ApiControl.getMainCommunity_MemberSearch(integUid: integUid, nextId: nextId, search: search, size: size, access_token: access_token)
            .sink { error in
                
            } receiveValue: { value in
                self.mainCommunity_Search = value
                guard let NOmainCommunity_Search = self.mainCommunity_Search else {
                    // The 'value' is nil
                    return
                }
                
                // 로딩 종료
                self.isPageLoading = false
                StatusManager.shared.loadingStatus = .Close
                
                self.mainCommunity_Search_List = NOmainCommunity_Search.post
                
                // 다음 검색을 위해 관련 변수 초기화
                self.isKeyboardEnter = false
                self.searchText = ""
                
                // 검색 결과 Viewer 보여주기
                self.showSearchResultViewer = true
            }
            .store(in: &canclelables)
    }
    
}
