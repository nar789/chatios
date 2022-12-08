//
//  MainCommunityMyPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/07/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
// 메인, 상세, 검색, 챌린지, 내클럽, 클럽생성
struct MainCommunityMyPage: View {
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
        .background(Color.gray25)
        .navigationType(leftItems: leftItems, rightItems: rightItems, leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "", onPress: { buttonType in
            if buttonType == .AlarmOn {
                rightItems = [.AlarmOff]
            }
            else if buttonType == .AlarmOff {
                rightItems = [.AlarmOn]
            }
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
}

extension MainCommunityMyPage {
    func tabPage(tabType: String, viewModel: MainCommunityMyViewModel) -> some View {
        VStack {
            if tabType == "myBoard" {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
                            BoardRowView(
                                viewType: BoardType.MainCommunityMyBoard,
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
                    
//                    LazyVStack(spacing: 10) {
//                        if viewModel.issueTop5_listTopFive.count > 0 {
//                            let forTestData: [Comment_Community] =
//                            viewModel.issueTop5_listTopFive[0].comment
//
//                            ForEach(forTestData, id: \.self) { item in
//                                CommentRowView(itemData: item)
//                                    .background(Color.gray25)
//                            }
//                        }
//                    }

                    LazyVStack(spacing: 10) {
                        ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
                            BoardRowView(
                                viewType: BoardType.MainCommunityMyComment,
                                communityBoardItem: viewModel.issueTop5_listTopFive[i]
                            )
                            .background(Color.gray25)
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
                                viewType: BoardType.MainCommunityMyLocalBoard,
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

struct MainCommunityMyPage_Previews: PreviewProvider {
    static var previews: some View {
        MainCommunityMyPage()
    }
}
