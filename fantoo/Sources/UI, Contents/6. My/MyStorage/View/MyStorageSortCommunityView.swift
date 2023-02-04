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
                    if viewModel.postSuccess {
                        if viewModel.userCommunityPostListData.count > 0 {
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestUserCommunityStoragePost(nextId: 0, size: DefineSize.ListSize.Common) { success in
                                                if success {
                                                    viewModel.postSuccess = true
                                                }
                                            }
                                            
                                            done()
                                        }
                                    }) {
                                        LazyVStack(spacing: 0) {
                                                ForEach(Array(viewModel.userCommunityPostListData.enumerated()), id: \.offset) { index, element in
                                                    
                                                BoardRowView(
                                                    viewType: BoardType.MyCommunity_Storage_Post,
                                                    communityStoragePostListData: viewModel.userCommunityPostListData[index],
                                                    isReportedBoard: { isReport in
                                                        if isReport {
                                                            UserManager.shared.reportPostAlert = true
                                                            print("idpilLog::: isReport : \(isReport)" as String)
                                                            
                                                        }
                                                    }
                                                )
                                                .background(Color.gray25)
                                                .onAppear {
                                                    self.postFetchMoreData(element)
                                                }
                                                Color.bgLightGray50.frame(height: 8)
                                            }
                                        }
                                    }
                                    .background(Color.bgLightGray50)
                            }
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
                    viewModel.requestUserCommunityStoragePost(nextId: 0, size: DefineSize.ListSize.Common) { success in
                        if success {
                            viewModel.postSuccess = true
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
                    if viewModel.replySuccess {
                        if viewModel.userCommunityReplyListData.count > 0 {
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestUserCommunityStorageReply(nextId: 0, size: DefineSize.ListSize.Common) { success in
                                                if success {
                                                    viewModel.replySuccess = true
                                                }
                                            }
                                            
                                            done()
                                        }
                                    }) {
                                        LazyVStack(spacing: 0) {
                                            ForEach(Array(viewModel.userCommunityReplyListData.enumerated()), id: \.offset) { index, element in
                                                
                                                BoardRowView(
                                                    viewType: BoardType.MyCommunity_Storage_Comment,
                                                    communityStorageReplyListData: viewModel.userCommunityReplyListData[index],
                                                    isDeletedBoard: { isDelete in
                                                        if isDelete {
                                                            UserManager.shared.deletePostAlert = true
                                                            print("idpilLog::: isDelete : \(isDelete)" as String)
                                                        }
                                                    },
                                                    isReportedBoard: { isReport in
                                                        if isReport {
                                                            UserManager.shared.reportPostAlert = true
                                                            print("idpilLog::: isReport : \(isReport)" as String)
                                                            
                                                        }
                                                    }
                                                )
                                                .background(Color.gray25)
                                                .onAppear {
                                                    self.replyFetchMoreData(element)
                                                }
                                                Color.bgLightGray50.frame(height: 8)
                                            }
                                        }
                                    }
                                    .background(Color.bgLightGray50)
                            }
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
                    viewModel.requestUserCommunityStorageReply(nextId: 0, size: DefineSize.ListSize.Common) { success in
                        if success {
                            viewModel.replySuccess = true
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
                    if viewModel.bookmarkSuccess {
                        if viewModel.userCommunityBookmarkListData.count > 0 {
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestUserCommunityStorageBookmark(nextId: 0, size: DefineSize.ListSize.Common) { success in
                                                if success {
                                                    viewModel.postSuccess = true
                                                }
                                            }
                                            
                                            done()
                                        }
                                    }) {
                                        LazyVStack(spacing: 0) {
                                            ForEach(Array(viewModel.userCommunityBookmarkListData.enumerated()), id: \.offset) { index, element in
                                                BoardRowView(
                                                    viewType: BoardType.MyCommunity_Storage_BookMark,
                                                    communityStorageBookmarkListData: viewModel.userCommunityBookmarkListData[index],
                                                    isDeletedBoard: { isDelete in
                                                        if isDelete {
                                                            UserManager.shared.deletePostAlert = true
                                                            print("idpilLog::: isDelete : \(isDelete)" as String)
                                                        }
                                                    },
                                                    isReportedBoard: { isReport in
                                                        if isReport {
                                                            UserManager.shared.reportPostAlert = true
                                                            print("idpilLog::: isReport : \(isReport)" as String)
                                                            
                                                        }
                                                    }
                                                )
                                                .background(Color.gray25)
                                                .onAppear {
                                                    self.bookmarkFetchMoreData(element)
                                                }
                                                Color.bgLightGray50.frame(height: 8)
                                            }
                                        }
                                    }
                                    .background(Color.bgLightGray50)
                            }
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
                    viewModel.requestUserCommunityStorageBookmark(nextId: 0, size: DefineSize.ListSize.Common) { success in
                        if success {
                            viewModel.bookmarkSuccess = true
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


extension MyStorageSortCommunityView {
    
    fileprivate func postFetchMoreData(_ boardList: UserCommunityPostListData) {
        if self.viewModel.userCommunityPostListData.last == boardList {
            print("[마지막]에 도달했다")
            
            guard let nextPage = self.viewModel.userCommunityPostData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            if nextPage == -1 {
                // 데이터 없음
            } else {
                print("[마지막]에 들어왔다")
                
                self.viewModel.comuPostFetchMoreActionSubject.send()
                
            }
        }
    }
    
    fileprivate func replyFetchMoreData(_ boardList: UserCommunityReplyListData) {
        if self.viewModel.userCommunityReplyListData.last == boardList {
            print("[마지막]에 도달했다")
            
            guard let nextPage = self.viewModel.userCommunityReplyData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            if nextPage == -1 {
                // 데이터 없음
            } else {
                print("[마지막]에 들어왔다")
                
                self.viewModel.comuReplyFetchMoreActionSubject.send()
            }
        }
    }
    
    fileprivate func bookmarkFetchMoreData(_ boardList: UserCommunityBookmarkListData) {
        if self.viewModel.userCommunityBookmarkListData.last == boardList {
            print("[마지막]에 도달했다")
            
            guard let nextPage = self.viewModel.userCommunityBookmarkData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            if nextPage == -1 {
                // 데이터 없음
            } else {
                print("[마지막]에 들어왔다")
                
                self.viewModel.comuBookmarkFetchMoreActionSubject.send()
                //                self.vm.onMorePageLoading()
            }
        }
    }
}
