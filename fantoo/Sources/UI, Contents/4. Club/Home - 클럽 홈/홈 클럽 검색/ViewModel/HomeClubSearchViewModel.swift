//
//  HomeClubSearchViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import CoreData

class HomeClubSearchViewModel: ObservableObject {
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
    @Published var homeClub_TabFreeboardModel: HomeClub_TabFreeboardModel?
    @Published var homeClub_TabFreeboardModel_FreeBoard = [HomeClub_TabFreeboardModel_FreeBoard]()
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
        return obj.value(forKey: "word") as! String
    }
    func readLocalSearchData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HomeClub_SearchWordData")    // SearchWord.xcdatamodeld 에서 ENTITIES 이름

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
        let entity = NSEntityDescription.insertNewObject(forEntityName: "HomeClub_SearchWordData", into: context)
        entity.setValue(searchText, forKey: "word")
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
    func getTabFreeboard() {
        ApiControl.getHomeClub_TabFreeboard()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.homeClub_TabFreeboardModel = value
                guard let NOhomeClub_TabFreeboardModel = self.homeClub_TabFreeboardModel else {
                    // The 'value' is nil
                    return
                }
                
                self.homeClub_TabFreeboardModel_FreeBoard = NOhomeClub_TabFreeboardModel.data.free_board
            }
            .store(in: &canclelables)
    }
    
}
