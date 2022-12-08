//
//  ClubMemberDetailTabView.swift
//  fantoo
//
//  Created by fns on 2022/08/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ClubMemberDetailTabView: View {
    enum TabBarType: Int {
        case MyBoard
        case MyComment
        case MyLocalBoard
    }
    @StateObject var viewModel = HomeClubHomeTabViewModel()

    let type: TabBarType
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension ClubMemberDetailTabView {
    
    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.isPageLoading {
                /**
                 * 리스트
                 */
                if viewModel.homeClub_TabHomeModel_BoardList.count > 0 {
                    
                    ForEach(Array(viewModel.homeClub_TabHomeModel_BoardList.enumerated()), id: \.offset) { index, element in
                        
                        if type == .MyBoard {
                        BoardRowView(
                            viewType: BoardType.MainClub_My,
                            homeClub_TabHomeModel_BoardList: element
                        )
                        .background(Color.gray25)
                        Color.bgLightGray50.frame(height: 8)
                        }
                        else if type == .MyComment {
                            BoardRowView(
                                viewType: BoardType.MyStorage_Comment,
                                homeClub_TabHomeModel_BoardList: element
                            )
                            .background(Color.gray25)
                            Color.bgLightGray50.frame(height: 8)
                        }
                        else if type == .MyLocalBoard {
                            BoardRowView(
                                viewType: BoardType.MainCommunity_Hour,
                                homeClub_TabHomeModel_BoardList: element
                            )
                            .background(Color.gray25)
                            Color.bgLightGray50.frame(height: 8)
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
            else {
                Text("Empty Data...")
            }
        }
        .onAppear() {
            self.callRemoteData()
            
//            if viewModel.isPageLoading {
//                // 페이지 내에서 로딩
//                StatusManager.shared.loadingStatus = .ShowWithTouchable
//            }
        }
    }
}

extension ClubMemberDetailTabView {
    func callRemoteData() {
        self.viewModel.getTabHome()
    }
}

struct ClubMemberDetailTabView_Previews: PreviewProvider {
    static var previews: some View {
        ClubMemberDetailTabView(type: .MyLocalBoard)
    }
}
