//
//  HomeClubNoticePage.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/19.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct HomeClubNoticePage: View {
    @StateObject var viewModel = HomeClubNoticeViewModel()
    
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = []
    
    @Binding var clubId: String
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.isPageLoading {
                if viewModel.homeClub_NoticeList.count > 0 {
                    noticeView
                }
            }
        }
        .background(Color.bgLightGray50)
        .onAppear {
            viewModel.getNotice(clubId: clubId)
        }
        // make disable the bouncing
        .introspectScrollView {
            $0.bounces = false
        }
        .navigationType(leftItems: leftItems, rightItems: rightItems, leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "g_notice_short".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
    var noticeView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                
                ForEach(Array(viewModel.homeClub_NoticeList.enumerated()), id: \.offset) { index, element in
                    
                    BoardRowView(
                        viewType: BoardType.HomeClub_Notice,
                        homeClub_Notice_Item: element
                    )
                    .background(Color.gray25)
                    .onAppear {
//                        self.fetchMoreData(element)
                    }
                }
            }
        }
    }
}

extension MainCommunityNoticePage {
    fileprivate func fetchMoreData(_ boardList: Community_Notice_List) {
        if self.viewModel.communityNoticeList_Total.last == boardList {
            //print("[마지막]에 도달했다")
            
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

struct HomeClubNoticePage_Previews: PreviewProvider {
    static var previews: some View {
        MainCommunityNoticePage()
    }
}

