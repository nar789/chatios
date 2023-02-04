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
    
    @StateObject var viewModel = MainCommunityMyViewModel()
    
    
    
    private let tabPageTypes: [String] = ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized]
    @State var currentTab: Int = 0
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = [.AlarmOn]
    
    @State var deletePostAlert: Bool = false
    @State var reportPostAlert: Bool = false
    
    @State var postSuccess: Bool = false
    @State var replySuccess: Bool = false
    @State var bookmarkSuccess: Bool = false

    
    private struct sizeInfo {
        static let tabViewHeight: CGFloat = 45.0
        
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
        static let padding14: CGFloat = 14.0
        static let imageSize: CGSize = CGSize(width: 100, height: 100)
    }

    
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
            CustomTabView(currentTab: $currentTab, style: .UnderLine, titles: tabPageTypes, height: sizeInfo.tabViewHeight)
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
//    func tabPage(tabType: String, viewModel: MainCommunityMyViewModel) -> some View {
//        VStack {
//            if tabType == "j_wrote_post".localized {
//                ScrollView(showsIndicators: false) {
//                    LazyVStack(spacing: 10) {
//                        ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
//                            BoardRowView(
//                                viewType: BoardType.MainCommunityMyBoard,
//                                communityBoardItem: viewModel.issueTop5_listTopFive[i]
//                            )
//                            .background(Color.gray25)
//                        }
//                    }
//                }
//                .onAppear {
//                    viewModel.getMyBoardList()
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//
//
//            } else if tabType == "myComment" {
//                ScrollView(showsIndicators: false) {
//
////                    LazyVStack(spacing: 10) {
////                        if viewModel.issueTop5_listTopFive.count > 0 {
////                            let forTestData: [Comment_Community] =
////                            viewModel.issueTop5_listTopFive[0].comment
////
////                            ForEach(forTestData, id: \.self) { item in
////                                CommentRowView(itemData: item)
////                                    .background(Color.gray25)
////                            }
////                        }
////                    }
//
//                    LazyVStack(spacing: 10) {
//                        ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
//                            BoardRowView(
//                                viewType: BoardType.MainCommunityMyComment,
//                                communityBoardItem: viewModel.issueTop5_listTopFive[i]
//                            )
//                            .background(Color.gray25)
//                        }
//                    }
//
//                }
//                .onAppear {
//                    viewModel.getCommentList()
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//            }  else if tabType == "myLocalBoard" {
//                ScrollView(showsIndicators: false) {
//                    LazyVStack(spacing: 10) {
//                        ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
//                            BoardRowView(
//                                viewType: BoardType.MainCommunityMyLocalBoard,
//                                communityBoardItem: viewModel.issueTop5_listTopFive[i]
//                            )
//                            .background(Color.gray25)
//                        }
//                    }
//                }
//                .onAppear {
//                    viewModel.getMyBoardList()
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//            }
//
//        }
//        .background(Color.bgLightGray50)
//    }
    
    func tabPage(tabType: String, viewModel: MainCommunityMyViewModel) -> some View {
        VStack(spacing: 0) {
            if tabType == "j_wrote_post".localized {
                VStack {
                    if postSuccess {
                        if viewModel.userCommunityPostListData.count > 0 {
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestUserCommunityStoragePost(nextId: 0, size: DefineSize.ListSize.Common) { success in
                                                if success {
                                                    postSuccess = true
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
                                                            reportPostAlert = true
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
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestUserCommunityStorageReply(nextId: 0, size: DefineSize.ListSize.Common) { success in
                                                if success {
                                                    postSuccess = true
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
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestUserCommunityStorageBookmark(nextId: 0, size: DefineSize.ListSize.Common) { success in
                                                if success {
                                                    postSuccess = true
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


extension MainCommunityMyPage {
    
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


struct MainCommunityMyPage_Previews: PreviewProvider {
    static var previews: some View {
        MainCommunityMyPage()
    }
}
