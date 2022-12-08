//
//  HomeClubHomeTabView.swift
//  fantooTests
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeClubHomeTabView {
    //@StateObject var viewModel = HomeClubHomeTabViewModel()
    var viewModel: HomeClubHomeTabViewModel
    
    /**
     * 언어팩 등록할 것
     */
    private let noticeTitle = "공지"
    private let noticeMore = "더보기"
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
}

extension HomeClubHomeTabView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            /**
             * 공지
             */
            if let notice = viewModel.homeClub_TabHomeModel_Notice {
                if notice.count > 0 {
                    noticeView
                }
            }

            /**
             * 리스트
             */
            if viewModel.homeClub_TabHomeModel_BoardList.count > 0 {
                
                ForEach(Array(viewModel.homeClub_TabHomeModel_BoardList.enumerated()), id: \.offset) { index, element in
                    
                    BoardRowView(
                        viewType: BoardType.HomeClub_TabHome,
                        homeClub_TabHomeModel_BoardList: element
                    )
                    .background(Color.gray25)
                    
                    if index == 0 {
                        /**
                         * 광고
                         */
                        if let _ = viewModel.homeClub_TabHomeModel_Ad {
                            VStack(spacing: 0) {
                                adView
                            }
                        }
                    }
                    
                    /**
                     * index가 처음과 마지막 번째에서는 아래 Rectangle()을 적용하지 않는다.
                     * - 처음 번째 : 광고배너에는 적용하지 않기 위해
                     * - 마지막 번째 : ScrollView 마지막에 구분선 있으면 이상함
                     */
                    Rectangle()
                        .frame(height: (index==0 || index==viewModel.homeClub_TabHomeModel_BoardList.count-1) ? 0 : 8)
                        .foregroundColor(.bgLightGray50)
                }
            }
        }
//        .onAppear() {
//            self.callRemoteData()
//
////            if viewModel.isPageLoading {
////                // 페이지 내에서 로딩
////                StatusManager.shared.loadingStatus = .ShowWithTouchable
////            }
//        }
    }
    
    var noticeView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text(noticeTitle)
                    .font(.buttons1420Medium)
                    .foregroundColor(.gray800)
                Spacer()
                Text(noticeMore)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray700)
            }
            .padding(.bottom, 12)
            
            ForEach(Array(viewModel.homeClub_TabHomeModel_Notice!.enumerated()), id: \.offset) { index, element in
                
                HStack(spacing: 0) {
                    Image("posting_fix")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text(element)
                        .font(.body21420Regular)
                        .foregroundColor(.gray900)
                        .lineLimit(1)
                        .allowsTightening(false)
                        .padding(.leading, 8)
                }
                
                if index == 0 {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray400.opacity(0.12))
                        .padding(.vertical, 7.5)
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, sizeInfo.Hpadding)
        .background(Color.bgLightGray50)
    }
    
    var adView: some View {
        WebImage(url: URL(string: viewModel.homeClub_TabHomeModel_Ad!.image))
            .resizable()
            .frame(height: 60)
    }
    
    var boardListView: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.homeClub_TabHomeModel_BoardList.enumerated()), id: \.offset) { index, element in

                BoardRowView(
                    viewType: BoardType.HomeClub_TabHome,
                    homeClub_TabHomeModel_BoardList: element
                )
                .background(Color.gray25)
            }
        }
        .background(Color.bgLightGray50)
//        ScrollView {
//
//        }
    }
}

extension HomeClubHomeTabView {
    func callRemoteData() {
        self.viewModel.getTabHome()
    }
}

//struct HomeClubHomeTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeClubHomeTabView()
//    }
//}
