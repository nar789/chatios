//
//  AlertPageViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class AlertPageViewModel: ObservableObject {
    var canclelables = Set<AnyCancellable>()
    
    @Published var isPageLoading: Bool = true
    @Published var isClickAllRead: Bool = false
    
    @Published var alertModel: AlertModel?
    @Published var alertData = [AlertData]()
    
    
    func getHomeNaviAlert() {
        ApiControl.getHomeNaviAlert()
            .sink { error in
                
            } receiveValue: { value in
                // 로딩 종료
                self.isPageLoading = false
                //StatusManager.shared.loadingStatus = .Close
                
                self.alertModel = value
                guard let NOalertModel = self.alertModel else {
                    // The 'value' is nil
                    return
                }
                
                self.alertData = NOalertModel.data
                // 알림 목록이 없으면, '모두 읽음' 텍스트 비활성
                if self.alertData.count == 0 {
                    self.isClickAllRead = true
                }
            }
            .store(in: &canclelables)
    }
}
