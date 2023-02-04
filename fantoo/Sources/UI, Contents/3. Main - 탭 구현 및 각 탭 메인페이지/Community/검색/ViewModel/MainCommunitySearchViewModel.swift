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
    var fetchMoreActionSubject = PassthroughSubject<(), Never>() // 페이징
    @Published var mainCommunity_Search: Community_List?
    @Published var mainCommunity_Search_List = [Community_BoardItem]()
    @Published var community_Like: Community_Like?  // 좋아요/싫어요

    /**
     * Viewer
     */
    @Published var showSearchHistoryViewer = false
    @Published var showSearchResultViewer = false
    
    
    
    
    init() {
        self.readLocalSearchData()
        
        fetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchMore()
        }.store(in: &canclelables)
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
            
            self.showSearchHistoryViewer = true
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
            
            self.showSearchHistoryViewer = false
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
    fileprivate func fetchMore() {
        guard let nextPage = mainCommunity_Search?.nextId else {
            print("페이지 정보가 없습니다.")
            return
        }
        //print("다음 페이지 : \(nextPage)" as String)
        
        // 0.3초 지연 (너무 빨리 넘어가면 페이징 효과 안 날까봐)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            
            self.getMemberSearch(
                integUid: UserManager.shared.uid,
                nextId: nextPage,
                search: self.searchText,
                size: 30,
                access_token: UserManager.shared.accessToken
            )
        }
    }
    
    func getMemberSearch(integUid: String, nextId: Int, search: String, size: Int, access_token: String) {
        // 페이지 내에서 로딩
        StatusManager.shared.loadingStatus = .ShowWithTouchable
        
        ApiControl.getMainCommunity_MemberSearch(integUid: integUid, nextId: nextId, search: search, size: size, access_token: access_token)
            .sink { error in
                //print("idpilLog::: 검색에러 : \(error)" as String)
                StatusManager.shared.loadingStatus = .Close
                self.resetSearch()
            } receiveValue: { value in
                StatusManager.shared.loadingStatus = .Close
                
                self.mainCommunity_Search = value
                guard let NOmainCommunity_Search = self.mainCommunity_Search else {
                    // The 'value' is nil
                    return
                }
                
                // 첫 페이지만 해당 (페이징 X)
                if nextId == 0 {
                    self.mainCommunity_Search_List = NOmainCommunity_Search.post
                    self.resetSearch()
                }
                // 페이징으로 받아오는 데이터
                else {
                    self.mainCommunity_Search_List.append(contentsOf: NOmainCommunity_Search.post)
                }
            }
            .store(in: &canclelables)
    }
    
    /**
     * 좋아요/싫어요
     */
    func postCommunityLike(likeType: String, targetType: String, targetId: Int, integUid: String, access_token: String, clickedIndex: Int) {
        ApiControl.postCommunityLike(likeType: likeType, targetType: targetType, targetId: targetId, integUid: integUid, access_token: access_token)
            .sink { error in

            } receiveValue: { value in

                self.community_Like = value
                guard let NOcommunity_Like = self.community_Like else {
                    // The 'value' is nil
                    return
                }

                self.mainCommunity_Search_List[clickedIndex].likeCnt = NOcommunity_Like.like
                self.mainCommunity_Search_List[clickedIndex].dislikeCnt = NOcommunity_Like.disLike

                if likeType == "like" {
                    self.mainCommunity_Search_List[clickedIndex].likeYn.toggle()
                    self.mainCommunity_Search_List[clickedIndex].dislikeYn = false
                } else if likeType == "dislike" {
                    self.mainCommunity_Search_List[clickedIndex].dislikeYn.toggle()
                    self.mainCommunity_Search_List[clickedIndex].likeYn = false
                }
            }
            .store(in: &canclelables)
    }

    /**
     * 좋아요/싫어요 취소
     */
    func deleteCommunityLike(targetType: String, targetId: Int, integUid: String, access_token: String, clickedIndex: Int) {
        ApiControl.deleteCommunityLike(targetType: targetType, targetId: targetId, integUid: integUid, access_token: access_token)
            .sink { error in

            } receiveValue: { value in

                self.community_Like = value
                guard let NOcommunity_Like = self.community_Like else {
                    // The 'value' is nil
                    return
                }

                self.mainCommunity_Search_List[clickedIndex].likeCnt = NOcommunity_Like.like
                self.mainCommunity_Search_List[clickedIndex].dislikeCnt = NOcommunity_Like.disLike

                self.mainCommunity_Search_List[clickedIndex].likeYn = false
                self.mainCommunity_Search_List[clickedIndex].dislikeYn = false
            }
            .store(in: &canclelables)
    }
    
    private func resetSearch() {
        // 다음 검색을 위해 관련 변수 초기화
        self.isKeyboardEnter = false
        //self.searchText = ""
        
        // 검색 결과 Viewer 보여주기
        self.showSearchResultViewer = true
    }
}
