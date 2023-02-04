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
        
        static let imageSize: CGSize = CGSize(width: 100, height: 100)
        
    }
    @Binding var clubId: String
    @Binding var memberId: Int
    @Binding var settingTab: Int
    
    @State var postSuccess: Bool = false
    @State var replySuccess: Bool = false
    @State var bookmarkSuccess: Bool = false
    
    @State var deletePostAlert: Bool = false
    @State var reportPostAlert: Bool = false
    
    
    private let tabPageTypes: [String] = ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized]
    @StateObject var viewModel = ClubStorageViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: self.$settingTab, content: {
                tabPage(tabType: tabPageTypes[0], viewModel: self.viewModel).tag(0)
                tabPage(tabType: tabPageTypes[1], viewModel: self.viewModel).tag(1)
                tabPage(tabType: tabPageTypes[2], viewModel: self.viewModel).tag(2)
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
            .padding(.top, sizeInfo.tabViewHeight)
            CustomTabView(currentTab: $settingTab, style: .UnderLine, titles: ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized], height: sizeInfo.tabViewHeight)
        }
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "b_storage".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        .onAppear {
            viewModel.clubId = clubId
            viewModel.memberId = memberId
        }
    }
}


struct ClubStoragePage_Previews: PreviewProvider {
    static var previews: some View {
        ClubStoragePage(clubId: .constant(""), memberId: .constant(0), settingTab: .constant(0))
    }
}

extension ClubStoragePage {
    func tabPage(tabType: String, viewModel: ClubStorageViewModel) -> some View {
        VStack(spacing: 0) {
            if tabType == "j_save".localized {
                VStack {
                    if bookmarkSuccess {
                        if viewModel.clubStorageBookmarkListData.count > 0 {
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestMyClubStorageBookmark(clubId: self.clubId, memberId: "\(self.memberId)", nextId: "", size: "\(DefineSize.ListSize.Common)") { success in
                                                if success {
                                                    bookmarkSuccess = true
                                                }
                                            }
                                            done()
                                        }
                                    }) {
                                        LazyVStack(spacing: 0) {
                                            ForEach(Array(viewModel.clubStorageBookmarkListData.enumerated()), id: \.offset) { index, element in
                                                
                                                BoardRowView(
                                                    viewType: BoardType.MyClub_Storage_Bookmark,
                                                    clubStorageBookmarkListData: viewModel.clubStorageBookmarkListData[index]
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
                    viewModel.requestMyClubStorageBookmark(clubId: self.clubId, memberId: "\(self.memberId)", nextId: "", size: "\(DefineSize.ListSize.Common)") { success in
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
            else if tabType == "j_wrote_rely".localized {
                VStack {
                    if replySuccess {
                        if viewModel.clubStorageReplyListData.count > 0 {
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestMyClubStorageReply(clubId: self.clubId, memberId: "\(self.memberId)", nextId: "", size: "\(DefineSize.ListSize.Common)") { success in
                                                if success {
                                                    replySuccess = true
                                                }
                                            }
                                            
                                            done()
                                        }
                                    }) {
                                        LazyVStack(spacing: 0) {
                                            ForEach(Array(viewModel.clubStorageReplyListData.enumerated()), id: \.offset) { index, element in
                                                
                                                BoardRowView(
                                                    viewType: BoardType.MyClub_Storage_Comment,
                                                    clubStorageReplyListData: viewModel.clubStorageReplyListData[index],
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
                    viewModel.requestMyClubStorageReply(clubId: self.clubId, memberId: "\(self.memberId)", nextId: "", size: "\(DefineSize.ListSize.Common)") { success in
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
            
            
            else if tabType == "j_wrote_post".localized {
                
                VStack {
                    if postSuccess {
                        if viewModel.clubStoragePostListData.count > 0 {
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestMyClubStoragePost(clubId: self.clubId, memberId: "\(self.memberId)", nextId: "", size: "\(DefineSize.ListSize.Common)") { success in
                                                if success {
                                                    postSuccess = true

                                                }
                                            }
                                            done()
                                        }
                                    }) {
                                        LazyVStack(spacing: 0) {
                                            ForEach(Array(viewModel.clubStoragePostListData.enumerated()), id: \.offset) { index, element in
                                                BoardRowView(
                                                    viewType: BoardType.MyClub_Storage_Post,
                                                    clubStoragePostListData: viewModel.clubStoragePostListData[index]
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
                    viewModel.requestMyClubStoragePost(clubId: self.clubId, memberId: "\(self.memberId)", nextId: "", size: "\(DefineSize.ListSize.Common)") { success in
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
            
            
        }
        .background(Color.bgLightGray50)
    }
}


extension ClubStoragePage {
    
    fileprivate func postFetchMoreData(_ boardList: ClubStoragePostListData) {
        if self.viewModel.clubStoragePostListData.last == boardList {
            print("[마지막]에 도달했다")
            
            guard let nextPage = self.viewModel.clubStoragePostData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            if nextPage == 316 {
                // 데이터 없음
            } else {
                print("[마지막]에 들어왔다")
                
                self.viewModel.clubPostFetchMoreActionSubject.send()
                
            }
        }
    }
    
    fileprivate func replyFetchMoreData(_ boardList: ClubStorageReplyListData) {
        if self.viewModel.clubStorageReplyListData.last == boardList {
            print("[마지막]에 도달했다")
            
            guard let nextPage = self.viewModel.clubStorageReplyData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            if nextPage == "\(298)" {
                // 데이터 없음
            } else {
                print("[마지막]에 들어왔다")
                
                self.viewModel.clubReplyFetchMoreActionSubject.send()
            }
        }
    }
    
    fileprivate func bookmarkFetchMoreData(_ boardList: ClubStorageBookmarkListData) {
        if self.viewModel.clubStorageBookmarkListData.last == boardList {
            print("[마지막]에 도달했다")
            
            guard let nextPage = self.viewModel.clubStorageBookmarkData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            if nextPage == 23 {
                // 데이터 없음
            } else {
                print("[마지막]에 들어왔다")
                
                self.viewModel.clubBookmarkFetchMoreActionSubject.send()
                //                self.vm.onMorePageLoading()
            }
        }
    }
}
