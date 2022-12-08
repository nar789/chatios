//
//  MyClubPage_test.swift
//  fantoo
//
//  Created by fns on 2022/11/23.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
//import SwiftUI_Pull_To_Refresh

struct MyClubPage_test {
    @StateObject var viewModel = CommunityHomeViewModel()
    
    var code: String
    var naviTitle: String
    @State private var isClickLike: Bool = false
    @State private var showCommunitySearchPage: Bool = false
    @State private var showCommunityEditorPage = false
    @State private var showNoticeView = false
    
    // ScrollView Up Button
    @State private var ScrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0 // 정확한 오프셋을 얻기 위해 startOffset을 가져옴
    @State private var isLoading: Bool = false
    
    private struct sizeInfo {
        static let floatingButton1BottomSize: CGFloat = 40
        // 아래 padding 값 + TabView 높이 (커뮤니티 메인에서 Floading Button 높이와 맞추기 위함)
        static let floatingButton2BottomSize: CGFloat = 40 + DefineSize.SafeArea.bottom
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    /**
     * 언어팩 등록할 것
     */
    private let naviPlusTitle = "게시판"
    private let noticeTitle = "공지"
    private let noticeMore = "더보기"
    private let noData_notice = "등록된 공지가 없습니다."
    private let noData_board = "게시글이 존재하지 않습니다."
}

extension MyClubPage_test: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                
                ScrollViewReader { proxyReader in
                    
                    RefreshableScrollView(
                        onRefresh: { done in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.viewModel.callBoardListFunc(nextId: 0)
                                done()
                            }
                        }) {
                            VStack(spacing: 0) {

                                if viewModel.isLoadingFinish {
                                    if viewModel.community_BoardItem.count > 0 {
                                        boardListView_copy
                                    }
                                    else {
                                        emptyView
                                    }
                                }
                            }

                            /**
                             * ScrollView 맨 위로 이동하는 버튼
                             */
                            .id("SCROLL_TO_TOP")
                            //ScrollView offset 가져오기
                            .overlay(
                                //GeometrtReader를 사용하여 ScrollView offset 값을 가져옴
                                GeometryReader{ proxy -> Color in
                                    DispatchQueue.main.async {
                                        //startOffset을 정해줌
                                        if startOffset == 0 {
                                            self.startOffset = proxy.frame(in: .global).minY
                                        }
                                        let offset = proxy.frame(in: .global).minY
                                        self.ScrollViewOffset = offset - startOffset
                                        //print("idpilLog::: ScrollView offset 확인 : \(self.ScrollViewOffset)" as String)
                                    }
                                    return Color.clear
                                }
                                    .frame(width: 0, height: 0), alignment: .top
                            )
                        }
                    
                    .overlay(
                        HStack(spacing: 0) {
                            Button(action: {
                                // 애니메이션과 함께 스크롤 탑 액션 지정
                                withAnimation(.default) {
                                    proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                                }
                            }, label: {
                                Image("btn_top_go2")
                            })
                        }
                        //.frame(width: 40, height: 40)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: sizeInfo.floatingButton1BottomSize, trailing: 20))
                            .opacity(-ScrollViewOffset > 450 ? 1 : 0)   // 만약 scrollViewOffset이 450보다 작으면 투명도를 적용
                            .animation(.easeIn), alignment: .bottom // 버튼을 오른쪽 하단에 고정
                    )
                }
                /**
                 * Floating Button
                 */
                HStack(spacing: 0) {
                    Spacer()
                    Button(action: {
                        showCommunityEditorPage = true
                    }, label: {
                        Image("bg_btn_hover")
                    })
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: sizeInfo.floatingButton2BottomSize, trailing: sizeInfo.Hpadding))
            }
        }
        .onChange(of: UserManager.shared.showInitialViewState) { value in
            showNoticeView = false
        }
        .onAppear {
            self.viewModel.getSubCategory(code: code, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken)
        }
        .navigationType(
            leftItems: [.Back],
            rightItems: [isClickLike ? .Like : .UnLike, .Search],
            leftItemsForegroundColor: .black,
            rightItemsForegroundColor: .black,
            title: naviTitle + " " + naviPlusTitle,
            onPress: { buttonType in
                if buttonType == .UnLike {
                    isClickLike = true
                }
                else if buttonType == .Like {
                    isClickLike = false
                }
                else if buttonType == .Search {
                    showCommunitySearchPage = true
                }
            }
        )
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        .background(Color.bgLightGray50)
        .background(
            NavigationLink("", isActive: $showCommunitySearchPage) {
                MainCommunitySearchPage()
            }.hidden()
        )
        .showAlert(
            isPresented: $viewModel.showAlert,
            type: .Default,
            message: viewModel.alertMessage,
            buttons: ["h_confirm".localized],
            onClick: { buttonIndex in
            }
        )
    }
    
    var categoryView: some View {
        HStack(spacing: 0) {
            categoryRowView
            
            Divider()
                .padding(.trailing, 13.5)
            
            Image("icon_outline_filter")
        }
        .padding(EdgeInsets(top: 12.5, leading: 0, bottom: 12.5, trailing: sizeInfo.Hpadding))
        .background(Color.gray25)   // .white 를 .gray25 로 사용하면 됨
    }
    
    var categoryRowView: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            if viewModel.categoryList_SubcategoryMember.count > 0 {
                HStack (spacing: 0) {
                    ForEach(Array(viewModel.categoryList_SubcategoryMember.enumerated()), id: \.offset) { index, element in
                        
                        ZStack (alignment: .center) {
                            RoundedRectangle(cornerRadius: 20)
                                .style(
                                    withStroke: Color.clear,
                                    lineWidth: 0,
                                    fill: element.code==viewModel.selectedSubCategoryCode ? Color.stateEnablePrimary100 : Color.gray25
                                )
    //                            .padding(.vertical, 4) // padding 값 없으면, 위-아래 테두리 선 약간 잘림
    //                            .padding(.horizontal, 10)
                            
                            Text(element.codeNameKo)
                                .font(.caption11218Regular)
                                .foregroundColor(element.code==viewModel.selectedSubCategoryCode ? Color.primary600 : Color.stateActiveGray700)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                        }
                        .fixedSize()
                        .padding(.leading, index==0 ? 20 : 0)
                        .onTapGesture {
                            self.viewModel.selectedSubCategoryCode = element.code
                            
                            self.viewModel.callBoardListFunc(nextId: 0)
                        }
                    }
                }
                .frame(height: 32)
            }
        }
        // make disable the bouncing
        .introspectScrollView {
            $0.bounces = false
        }
    }
    
    var noticeView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(noticeTitle)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(Color.gray800)
                Spacer()
                Text(noticeMore)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray400)
                    .onTapGesture {
                        showNoticeView = true
                    }
                    .background(
                        NavigationLink("", isActive: $showNoticeView) {
                            MainCommunityNoticePage()
                        }.hidden()
                    )
            }
            .padding(.top, 12)
            
            if viewModel.communityNoticeList.count > 0 {
                HStack(spacing: 0) {
                    noticeRowView
                    Spacer()
                }
            } else {
                Text(noData_notice)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray800)
                    .padding(.top, 10)
                    .padding(.bottom, 16)
            }
        }
        .padding(.horizontal, sizeInfo.Hpadding)
        .background(Color.gray50)
    }
    
    var noticeRowView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(viewModel.communityNoticeList.enumerated()), id: \.offset) { index, element in
                
                HStack(alignment: .center, spacing: 0) {
                    Image("posting_fix")

                    Text(element.title)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray900)
                        .lineLimit(1)
                        .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                        .padding(.leading, 8)
                }
                .padding(.top, index==0 ? 10 : 8)
                .padding(.bottom, index==viewModel.communityNoticeList.count-1 ? 16 : 8)
                
                if index != viewModel.communityNoticeList.count-1 {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray400.opacity(0.12))
                }
            }
        }
    }
    
    var boardListView_copy: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(Array(viewModel.community_BoardItem.enumerated()), id: \.offset) { index, element in
                
                Group {
                    if self.code == "C_HOT" {
                        BoardRowView(
                            viewType: BoardType.HomeCommunity_List_YesHot,
                            mainCommunity_BoardItem: element
                        )
                    }
                    else {
                        BoardRowView(
                            viewType: BoardType.HomeCommunity_List_NoHot,
                            mainCommunity_BoardItem: element
                        )
                    }
                }
                .background(Color.gray25)   // .white 를 .gray25 로 사용하면 됨
                .onAppear {
                    self.fetchMoreData(element)
                }
            }
        }
        .background(Color.bgLightGray50)
    }
    
    var boardListView: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(Array(viewModel.community_BoardItem.enumerated()), id: \.offset) { index, element in
                
                Group {
                    if self.code == "C_HOT" {
                        BoardRowView(
                            viewType: BoardType.HomeCommunity_List_YesHot,
                            mainCommunity_BoardItem: element
                        )
                    }
                    else {
                        BoardRowView(
                            viewType: BoardType.HomeCommunity_List_NoHot,
                            mainCommunity_BoardItem: element
                        )
                    }
                }
                .background(Color.gray25)   // .white 를 .gray25 로 사용하면 됨
                .onAppear {
                    self.fetchMoreData(element)
                }
            }
        }
        .background(Color.bgLightGray50)
    }
    
    var emptyView: some View {
        VStack(spacing: 0) {
            Image("character_club2")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text(noData_board)
                .font(.body21420Regular)
                .foregroundColor(.gray600)
                .padding(.top, 14)
        }
        .padding(.top, 130)
    }
}

extension MyClubPage_test {
    fileprivate func fetchMoreData(_ boardList: Community_BoardItem) {
        if self.viewModel.community_BoardItem.last == boardList {
            //print("[마지막]에 도달했다")
            
            guard let nextPage = self.viewModel.community_List?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            if nextPage == -1 {
                // 데이터 없음
            } else {
                self.viewModel.fetchMoreActionSubject.send()
            }
        }
    }
    
    
    
    private func refreshList() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //self.viewModel.callBoardListFunc(nextId: 0)
            isLoading = false
        }
    }
}






