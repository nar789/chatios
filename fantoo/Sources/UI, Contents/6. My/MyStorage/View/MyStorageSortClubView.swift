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
    @State var deletePostAlert: Bool = false
    @State var reportPostAlert: Bool = false
    
    private let tabPageTypes: [String] = ["j_wrote_post".localized, "j_wrote_rely".localized, "j_save".localized]
    
    @StateObject var viewModel = MyStorageViewModel()
    
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
    func tabPage(tabType: String, viewModel: MyStorageViewModel) -> some View {
        VStack(spacing: 0) {
            if tabType == "j_wrote_post".localized {
                
                VStack {
                    if viewModel.postSuccess {
                        if viewModel.clubStoragePostListData.count > 0 {
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestMyClubStoragePost(nextId: "", size: "\(DefineSize.ListSize.Common)") { success in
                                                if success {
                                                    viewModel.postSuccess = true
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
                    viewModel.requestMyClubStoragePost(nextId: "", size: "\(DefineSize.ListSize.Common)") { success in
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
                        if viewModel.clubStorageReplyListData.count > 0 {
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestMyClubStorageReply(nextId: "", size: "\(DefineSize.ListSize.Common)") { success in
                                                if success {
                                                    viewModel.replySuccess = true
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
                    viewModel.requestMyClubStorageReply(nextId: "", size: "\(DefineSize.ListSize.Common)") { success in
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
                        if viewModel.clubStorageBookmarkListData.count > 0 {
                            ScrollViewReader { proxyReader in
                                RefreshableScrollView(
                                    onRefresh: { done in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            viewModel.requestMyClubStorageBookmark(nextId: "0", size: "\(DefineSize.ListSize.Common)") { success in
                                                if success {
                                                    viewModel.bookmarkSuccess = true
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
                    viewModel.requestMyClubStorageBookmark(nextId: "0", size: "\(DefineSize.ListSize.Common)") { success in
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


extension MyStorageSortClubView {
    
    fileprivate func postFetchMoreData(_ boardList: ClubStoragePostListData) {
        if self.viewModel.clubStoragePostListData.last == boardList {
            print("[마지막]에 도달했다")
            
            guard let nextPage = self.viewModel.clubStoragePostData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            if nextPage == 258 {
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
            
            if nextPage == "\(116)" {
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
            
            if nextPage == 0 {
                // 데이터 없음
            } else {
                print("[마지막]에 들어왔다")
                
                self.viewModel.clubBookmarkFetchMoreActionSubject.send()
                //                self.vm.onMorePageLoading()
            }
        }
    }
}
