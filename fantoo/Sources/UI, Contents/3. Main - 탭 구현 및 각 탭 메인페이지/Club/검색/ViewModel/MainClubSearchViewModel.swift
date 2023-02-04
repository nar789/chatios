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
    @Published var popularClub100List: [ClubListCommonModel_ClubList] = []
    @Published var clubSearchResultList: [ClubListCommonModel_ClubList] = []
    

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
            
            CommonFunction.offPageLoading()
        } catch {
            print(error.localizedDescription)
        }
    }
    func writeLocalSearchData() {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "MainClub_SearchWordData", into: context)
        entity.setValue(searchText, forKey: "mainClubWord")
        
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
    // 인기 클럽 100
    func getPopularClubTop100(integUid: String) {
        ApiControl.getMainClub_PopularClubTop100(integUid: integUid)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                self.popularClub100List = value.clubList
            }
            .store(in: &canclelables)
    }
    
    
    func getSearchResult(nextId: String, size: String) {
        CommonFunction.offPageLoading()
        ApiControl.getMainClub_ClubSearch(keyword: searchText, nextId: nextId, size: size)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                self.clubSearchResultList = value.clubList
            }
            .store(in: &canclelables)
    }
    
    func setSearchText(txt: String) {
        self.searchText = txt
    }
}
