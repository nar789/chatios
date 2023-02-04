//
//  BSLanguageViewModel.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/05.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class BSLanguageViewModel: ObservableObject {
    
    @Published var languageList: [LanguageListData]?
    
    var canclelables = Set<AnyCancellable>()
    
    func getLanguageList() {
        ApiControl.languageList()
            .sink { error in
                print("getLanguageList error : \(error)")
            } receiveValue: { value in
                self.languageList = value
                let _ = print("\(value)")
            }.store(in: &canclelables)
    }
}
