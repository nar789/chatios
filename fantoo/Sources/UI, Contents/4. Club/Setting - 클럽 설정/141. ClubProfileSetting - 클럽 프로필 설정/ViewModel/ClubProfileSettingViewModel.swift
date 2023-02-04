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
    
    @Published var existYn: Bool = false
    @Published var clubNameCheck: Bool = false
    @Published var checkToken: String = ""
    @Published var clubNameCheckText: String = ""

}
