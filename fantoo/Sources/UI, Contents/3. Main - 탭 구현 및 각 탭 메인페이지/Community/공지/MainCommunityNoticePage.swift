//
//  MainCommunityNoticeView.swift
//  fantooUITests
//
//  Created by kimhongpil on 2022/07/24.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct MainCommunityNoticePage: View {
    @StateObject var viewModel = MainCommunityNoticeViewModel()
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = []
    
    var body: some View {
        VStack {
            if !viewModel.isNoticeLoading {
                if viewModel.communityNoticeList_Total.count > 0 {
                    noticeView
                }
            }
        }
        .background(Color.bgLightGray50)
        .onAppear {
            viewModel.getNoticeList()
        }
        // make disable the bouncing
        .introspectScrollView {
            $0.bounces = false
        }
        .navigationType(leftItems: leftItems, rightItems: rightItems, leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "g_notice".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
    var noticeView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                
                ForEach(Array(viewModel.communityNoticeList_Total.enumerated()), id: \.offset) { index, element in
                    
                    BoardRowView(
                        viewType: BoardType.Community_Notice_Total,
                        community_Notice_List: element
                    )
                    .background(Color.gray25)
                    .onAppear {
                        self.fetchMoreData(element)
                    }
                }
            }
        }
    }
}

extension MainCommunityNoticePage {
    fileprivate func fetchMoreData(_ boardList: Community_Notice_List) {
        if self.viewModel.communityNoticeList_Total.last == boardList {
            print("[마지막]에 도달했다")
            
            guard let nextPage = self.viewModel.communityNotice?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            if nextPage == -1 {
                // 데이터 없음
            } else {
                self.viewModel.fetchMoreActionSubject.send()
                
                self.viewModel.onMorePageLoading()
            }
        }
    }
}

struct MainCommunityNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        MainCommunityNoticePage()
    }
}
