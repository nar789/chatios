//
//  BSCountryViewModel.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class BSCountryViewModel: ObservableObject {
    
    @Published var countryList = [CountryListData]()
    
    var canclelables = Set<AnyCancellable>()
    
    func requestCountryList() {
        ApiControl.countryList()
            .sink { error in
                print("getCountryList error : \(error)")
            } receiveValue: { value in
                self.countryList = value
            }.store(in: &canclelables)
    }
}
