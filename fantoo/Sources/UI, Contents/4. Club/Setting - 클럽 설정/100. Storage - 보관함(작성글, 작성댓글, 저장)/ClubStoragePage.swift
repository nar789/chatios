//
//  ClubStoragePage.swift
//  fantoo
//
//  Created by mkapps on 2022/06/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubStoragePage: View {
    
    private struct sizeInfo {
        static let tabViewHeight: CGFloat = 40.0
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
    }
    
    @State var currentTab: Int = 0
    private let tabPageTypes: [String] = ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized]
    @StateObject var viewModel = ClubStorageViewModel()

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
            CustomTabView(currentTab: $currentTab, style: .UnderLine, titles: ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized], height: sizeInfo.tabViewHeight)
        }
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "b_storage".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
}


struct ClubStoragePage_Previews: PreviewProvider {
    static var previews: some View {
        ClubStoragePage()
    }
}

extension ClubStoragePage {
    func tabPage(tabType: String, viewModel: ClubStorageViewModel) -> some View {
        VStack(spacing: 0) {
            if tabType == "j_save".localized {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<viewModel.clubStorageBookmarkListData.count, id: \.self) { i in
                            BoardRowView(
                                viewType: BoardType.MyClub_Storage_Bookmark,
                                clubStorageBookmarkListData: viewModel.clubStorageBookmarkListData[i]
                            )
                                .background(Color.gray25)
                            Color.bgLightGray50.frame(height: 8)
                        }
                    }
                }
                .onAppear {
//                    viewModel.getMyBoardList()
                    viewModel.requestMyClubStorageBookmark { success in
                    
                    }

                }
                // make disable the bouncing
                .introspectScrollView {
                    $0.bounces = false
                }
                
                
            }
            else if tabType == "j_wrote_rely".localized {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<viewModel.clubStorageReplyListData.count, id: \.self) { i in
                            BoardRowView(
                                viewType: BoardType.MyClub_Storage_Comment,
                                clubStorageReplyListData: viewModel.clubStorageReplyListData[i]
                            )
                                .background(Color.gray25)
                            Color.bgLightGray50.frame(height: 8)
                        }
                    }
                }
                .onAppear {
//                    viewModel.getMyBoardList()
                    viewModel.requestMyClubStorageReply { success in
                        
                    }

                }
                // make disable the bouncing
                .introspectScrollView {
                    $0.bounces = false
                }
            }
            
            else if tabType == "j_wrote_post".localized {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<viewModel.clubStoragePostListData.count, id: \.self) { i in
                            BoardRowView(
                                viewType: BoardType.MyClub_Storage_Post,
                                clubStoragePostListData: viewModel.clubStoragePostListData[i]
                            )
                                .background(Color.gray25)
                            Color.bgLightGray50.frame(height: 8)
                        }
                    }
                }
                .onAppear {
//                    viewModel.getMyBoardList()
                    viewModel.requestMyClubStoragePost { success in
                        
                    }

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

