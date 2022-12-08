//
//  ClubProfileSettingViewModel.swift
//  fantoo
//
//  Created by fns on 2022/11/17.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine


class ClubProfileSettingViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    @Published var loadingStatus: LoadingStatus = .Close
    
    @Published var clubMemberData: ClubMemberData?
    @Published var clubMemberListData = [ClubMemberListData]()
    
    @Published var memberListSize: Int = 0
    

}
