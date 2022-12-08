//
//  MyStorageSortView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct MyStorageSortCommunityView: View {
    
    private struct sizeInfo {
        static let tabViewHeight: CGFloat = 45.0
        
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
        static let padding14: CGFloat = 14.0
        static let imageSize: CGSize = CGSize(width: 100, height: 100)
    }
    
    @StateObject var viewModel = MyStorageViewModel()
    @Binding var currentTab: Int
    @State var deletePostAlert: Bool = false
    @State var reportPostAlert: Bool = false
    
    @State var postSuccess: Bool = false
    @State var replySuccess: Bool = false
    @State var bookmarkSuccess: Bool = false
    
    @State var showDetailPage: Bool = false
    
    private let tabPageTypes: [String] = ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized]
    
    // pil test
    @State var isDeletedBoard: Bool = false
    
    
    var body: some View {
        VStack {
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
        .popup(isPresenting: $deletePostAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text("se_s_post_delete".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.gray800)
        }
               
        )
        .popup(isPresenting: $reportPostAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text("se_s_post_hide_by_report_long".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.gray800)
        }
               
        )
    }
}


struct MyStorageSortCommunityView_Previews: PreviewProvider {
    static var previews: some View {
        MyStorageSortCommunityView(currentTab: .constant(0))
    }
}


extension MyStorageSortCommunityView {
    func tabPage(tabType: String, viewModel: MyStorageViewModel) -> some View {
        VStack(spacing: 0) {
            if tabType == "j_wrote_post".localized {
                VStack {
                    if postSuccess {
                        if viewModel.userCommunityPostListData.count > 0 {
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    ForEach(0..<viewModel.userCommunityPostListData.count, id: \.self) { i in
                                        BoardRowView(
                                            viewType: BoardType.MyCommunity_Storage_Post,
                                            communityStoragePostListData: viewModel.userCommunityPostListData[i],
                                            isReportedBoard: { isReport in
                                                if isReport {
                                                    reportPostAlert = true
                                                    print("idpilLog::: isReport : \(isReport)" as String)
                                                    
                                                }
                                            }
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
                    viewModel.requestUserCommunityStoragePost { success in
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
                        if viewModel.userCommunityReplyListData.count > 0 {
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    ForEach(0..<viewModel.userCommunityReplyListData.count, id: \.self) { i in
                                        BoardRowView(
                                            viewType: BoardType.MyCommunity_Storage_Comment,
                                            communityStorageReplyListData: viewModel.userCommunityReplyListData[i],
                                            isDeletedBoard: { isDelete in
                                                if isDelete {
                                                    deletePostAlert = true
                                                    print("idpilLog::: isDelete : \(isDelete)" as String)
                                                }
                                            },
                                            isReportedBoard: { isReport in
                                                if isReport {
                                                    reportPostAlert = true
                                                    print("idpilLog::: isReport : \(isReport)" as String)
                                                    
                                                }
                                            }
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
                    viewModel.requestUserCommunityStorageReply { success in
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
                        if viewModel.userCommunityBookmarkListData.count > 0 {
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    ForEach(0..<viewModel.userCommunityBookmarkListData.count, id: \.self) { i in
                                        BoardRowView(
                                            viewType: BoardType.MyCommunity_Storage_BookMark,
                                            communityStorageBookmarkListData: viewModel.userCommunityBookmarkListData[i],
                                            isDeletedBoard: { isDelete in
                                                if isDelete {
                                                    deletePostAlert = true
                                                    print("idpilLog::: isDelete : \(isDelete)" as String)
                                                }
                                            },
                                            isReportedBoard: { isReport in
                                                if isReport {
                                                    reportPostAlert = true
                                                    print("idpilLog::: isReport : \(isReport)" as String)
                                                    
                                                }
                                            }
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
                    viewModel.requestUserCommunityStorageBookmark { success in
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
