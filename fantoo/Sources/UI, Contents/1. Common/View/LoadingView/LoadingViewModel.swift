//
//  LoadingViewModel.swift
//  fantoo
//
//  Created by mkapps on 2022/06/11.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class LoadingViewModel: ObservableObject {
    
    private var loadingTimer: Timer?
    private let loadingTime = 15.0
    
    @Published var loadingStatus: LoadingStatus = .Close {
        didSet {
            if loadingStatus != .Close {
                startLoadingTimer()
            }
        }
    }
    
    func startLoadingTimer() {
        if loadingTimer != nil && loadingTimer!.isValid {
            loadingTimer!.invalidate()
        }
        
        if loadingStatus != .ShowWithUntouchableUnlimited {
            loadingTimer = Timer.scheduledTimer(timeInterval: loadingTime, target: self, selector: #selector(checkLoadingTimer), userInfo: nil, repeats: false)
        }
    }
    
    @objc func checkLoadingTimer() {
        loadingStatus = .Close
    }
}
