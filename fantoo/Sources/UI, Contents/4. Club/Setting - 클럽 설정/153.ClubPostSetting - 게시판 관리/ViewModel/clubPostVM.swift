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

class ClubPostVM: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = false
    
    @Published var loadingStatus: LoadingStatus = .Close

    @Published var clubCategoryData: ClubCategoryData?
    @Published var clubCategoryListData = [ClubCategoryListData]()
    @Published var clubCategoryDetailListData = [ClubCategoryDetailListData]()

    @Published var draggedItem: DraggedPost?
    @Published var post: [DraggedPost] = [
    ]
    
    //MARK: - Request
    func requestClubCategoryList() {
        loadingStatus = .ShowWithTouchable
        ApiControl.clubCategoryList(clubId: "48", integUid: "ft_u_f96a7595c13a11ecb6386f262a44c38b_2022_04_21_15_19_17_841")
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
}

