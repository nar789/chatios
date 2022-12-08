//
//  ClubMemberDetailView.swift
//  fantoo
//
//  Created by fns on 2022/07/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ClubMemberDetailView: View {
    @StateObject var languageManager = LanguageManager.shared

    
    private struct sizeInfo {
        static let tabViewHeight: CGFloat = 40.0
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
    }
    
    private let tabTitles: [String] = ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized]
    private let tabPageTypes: [String] = ["myBoard", "myComment", "myLocalBoard"]
    @State var currentTab: Int = 0
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = [.AlarmOn]
    // api완료되면 클럽마이로 수정해야함
    @StateObject var viewModel = MainCommunityMyViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: self.$currentTab, content: {
                tabPage(tabType: tabPageTypes[0], viewModel: self.viewModel).tag(0)
                tabPage(tabType: tabPageTypes[1], viewModel: self.viewModel).tag(1)
                tabPage(tabType: tabPageTypes[2], viewModel: self.viewModel).tag(2)
            })
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.all)
                .padding(.top, sizeInfo.tabViewHeight)
            CustomTabView(currentTab: $currentTab, style: .UnderLine, titles: tabTitles, height: sizeInfo.tabViewHeight)
        }
    }
}

struct ClubMemberDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClubMemberDetailView()
    }
}

extension ClubMemberDetailView {
    func tabPage(tabType: String, viewModel: MainCommunityMyViewModel) -> some View {
        VStack {
            if tabType == "myBoard" {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
                            BoardRowView(
                                viewType: BoardType.MainClub_My,
                                communityBoardItem: viewModel.issueTop5_listTopFive[i]
                            )
                            .background(Color.gray25)
                        }
                    }
                }
                .onAppear {
                    viewModel.getMyBoardList()
                }
                // make disable the bouncing
                .introspectScrollView {
                    $0.bounces = false
                }
                
                
            } else if tabType == "myComment" {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        if viewModel.issueTop5_listTopFive.count > 0 {
                            let forTestData: [Comment_Community] =
                            viewModel.issueTop5_listTopFive[0].comment
                            
                            ForEach(forTestData, id: \.self) { item in
                                CommentRowView(itemData: item)
                                    .background(Color.gray25)
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.getCommentList()
                }
                // make disable the bouncing
                .introspectScrollView {
                    $0.bounces = false
                }
            }  else if tabType == "myLocalBoard" {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
                            BoardRowView(
                                viewType: BoardType.MainCommunity_Hour,
                                communityBoardItem: viewModel.issueTop5_listTopFive[i]
                            )
                            .background(Color.gray25)
                        }
                    }
                }
                .onAppear {
                    viewModel.getMyBoardList()
                }
                // make disable the bouncing
                .introspectScrollView {
                    $0.bounces = false
                }
            }
            
        }
        .background(Color.bgLightGray50)
    }
}
