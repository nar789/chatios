//
//  MyStorageSortClubView.swift
//  fantoo
//
//  Created by fns on 2022/08/17.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct MyStorageSortClubView: View {
    
    
    private struct sizeInfo {
        static let tabViewHeight: CGFloat = 45.0
        
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
        static let padding14: CGFloat = 14.0
        static let imageSize: CGSize = CGSize(width: 100, height: 100)
    }
    
    @Binding var currentTab: Int
    
    @State var postSuccess: Bool = false
    @State var replySuccess: Bool = false
    @State var bookmarkSuccess: Bool = false
    
    private let tabPageTypes: [String] = ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized]
    
    @StateObject var viewModel = ClubSettingViewModel()
    
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
            CustomTabView(currentTab: $currentTab, style: .ActiveBackground, titles: ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized], height: sizeInfo.tabViewHeight)
        }
    }
}


struct MyStorageSortClubView_Previews: PreviewProvider {
    static var previews: some View {
        MyStorageSortClubView(currentTab: .constant(0))
    }
}


extension MyStorageSortClubView {
    func tabPage(tabType: String, viewModel: ClubSettingViewModel) -> some View {
        VStack(spacing: 0) {
            if tabType == "j_wrote_post".localized {
                
                VStack {
                    if postSuccess {
                        if viewModel.clubStoragePostListData.count > 0 {
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
                            .background(Color.bgLightGray50)
                        }
                        else {
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    Spacer().frame(height: sizeInfo.imageSize.width)
                                    NoSearchView(image: "character_club2", text: "se_j_no_write_post".localized)
                                }
                            }
                            .background(Color.gray25)
                        }
                    }
                }
                .onAppear {
                    viewModel.requestMyClubStoragePost { success in
                        if success {
                            postSuccess = true
                        }
                    }
                }
                // make disable the bouncing
                .introspectScrollView {
                    $0.bounces = false
                }
            }
            
            else if tabType == "j_wrote_rely".localized {
                VStack {
                    if replySuccess {
                        if viewModel.clubStorageReplyListData.count > 0 {
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
                            .background(Color.bgLightGray50)
                        }
                        else {
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    Spacer().frame(height: sizeInfo.imageSize.width)
                                    NoSearchView(image: "character_club2", text: "se_j_no_write_comment".localized)
                                }
                            }
                            .background(Color.gray25)
                        }
                    }
                }
                .onAppear {
                    viewModel.requestMyClubStorageReply { success in
                        if success {
                            replySuccess = true
                        }
                    }
                    
                }
                // make disable the bouncing
                .introspectScrollView {
                    $0.bounces = false
                }
            }
            else if tabType == "j_save".localized {
                VStack {
                    if bookmarkSuccess {
                        if viewModel.clubStorageBookmarkListData.count > 0 {
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
                            .background(Color.bgLightGray50)
                        }
                        else {
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    Spacer().frame(height: sizeInfo.imageSize.width)
                                    NoSearchView(image: "character_club2", text: "se_j_no_save_post".localized)
                                }
                            }
                            .background(Color.gray25)
                        }
                    }
                }
                .onAppear {
                    viewModel.requestMyClubStorageBookmark { success in
                        if success {
                            bookmarkSuccess = true
                        }
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
