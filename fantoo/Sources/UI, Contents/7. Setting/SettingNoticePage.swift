//
//  NoticePage.swift
//  fantoo
//
//  Created by fns on 2022/10/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct SettingNoticePage: View {
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = NoticeViewModel()
    
    @State private var showDetailPage = false
    @State private var lang: String = "한국어"
    @State private var createDate: String = ""
    
    @State private var fantooNoticeId: Int = 0
    
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 50.0
        static let cellHeight150: CGFloat = 150.0
        static let cellLeadingPadding: CGFloat = 16.0
        static let cellBottomPadding: CGFloat = 5.0
        static let cellTrailingPadding: CGFloat = 16.0
        static let cellTopPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    let noticeList = vm.fantooNoticeDtoList ?? nil
                    if noticeList != nil {
                        ForEach(noticeList!, id : \.self) { i in
                            LazyVStack(spacing: 0) {
                                NoticeListLinkView(text: i.title, subText: getNoticeDate(createDate: i.createDate), showLine: true, onPress: {
                                    showDetailPage = true
                                    fantooNoticeId = i.fantooNoticeId
                                })
                            }
                        }
                        .background(
                            NavigationLink("", isActive: $showDetailPage) {
                                NoticeDetailPage(noticeId: $fantooNoticeId)
                            }.hidden()
                        )
                    }
                    else {
                        
                        Spacer().frame(height: sizeInfo.cellHeight150)
                        NoSearchView(image: "character_main2", text: "se_p_no_data".localized)
                        
                    }
                }
            }
            .modifier(ScrollViewLazyVStackModifier())
        }
        .onAppear {
            vm.requestNoticeList()
        }
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "g_notice".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        
    }
    
    func getNoticeDate(createDate: String) -> String {
        let dateString = createDate
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [
            .withFractionalSeconds,
            .withFullDate
        ]
        let date = inputFormatter.date(from: dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let weekDay = dateFormatter.string(from: date!)
        return weekDay

    }
}

struct NoticePage_Previews: PreviewProvider {
    static var previews: some View {
        SettingNoticePage()
    }
}
