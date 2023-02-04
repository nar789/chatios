//
//  NoticeViewModel.swift
//  fantoo
//
//  Created by fns on 2022/10/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class NoticeViewModel: ObservableObject {
    
    private var canclelables = Set<AnyCancellable>()
    
    @Published var communityAgree: Bool = false
    @Published var noticeData: NoticeData?
    @Published var fantooNoticeDtoList = [FantooNoticeDtoList]()
    
    @Published var fantooNoticeId: Int = 0
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var langCode: String = ""
    @Published var createDate: String = ""


    
    //MARK: - Request
    func requestNoticeList() {
        ApiControl.noticeList(integUid: UserManager.shared.uid, nextId: 0, size: 10)
            .sink { error in
                print("noticeList error : \(error)")
                
            } receiveValue: { value in
                
                self.noticeData = value
                guard let noNoticeData = self.noticeData else {
                    return
                }
                self.fantooNoticeDtoList = noNoticeData.fantooNoticeDtoList
                
                print("noticeList value : \(value)")
                
            }
            .store(in: &canclelables)
    }
    
    func requestNoticeListDetail(noticeId: String) {
        ApiControl.noticeListDetail(integUid: UserManager.shared.uid, noticeId: noticeId)
            .sink { error in
                print("noticeListDetail error : \(error)")
                
            } receiveValue: { value in
                
                self.fantooNoticeId = value.fantooNoticeId
                self.title = value.title
                self.content = value.content
                self.langCode = value.langCode
//                self.createDate = value.createDate
                
                if value.createDate.count > 0 {
                    let dateString = value.createDate
                    let inputFormatter = ISO8601DateFormatter()
                    inputFormatter.formatOptions = [
                        .withFractionalSeconds,
                        .withFullDate
                    ]
                    let date = inputFormatter.date(from: dateString)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy.MM.dd"
                    let weekDay = dateFormatter.string(from: date!)
                    self.createDate = weekDay
                }
                
                print("noticeListDetail value : \(value)")
                
            }
            .store(in: &canclelables)
    }
    
}
