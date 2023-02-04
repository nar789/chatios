//
//  MainCommunityPage.swift
//  fantoo
//
//  Created by 김홍필 on 2022/05/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SwiftUINavigationBarColor
import SDWebImageSwiftUI


struct MainCommunityPage {
    @StateObject var viewModel = MainCommunityViewModel()
    
    @State private var showNoticeMorePage = false
    @State private var showNoticeDetailPage = false
    @State private var showCommunityEditorPage = false
    @State private var showCommunityHomePage = false
    @State private var showFavoritPage = false
    
    /**
     * 언어팩 등록할 것
     */
    private let noticeTitle = "공지"
    private let noticeMore = "더보기"
    private let boardHourTopTitle = "실시간 이슈 TOP 5"
    private let boardWeekTopTitle = "주간 인기 TOP 5"
    private let noData_list = "리스트가 존재하지 않습니다."
    private let noData_notice = "등록된 공지가 없습니다."
    
    private struct sizeInfo {
        static let floatingButtonBottomSize: CGFloat = 40
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
}

extension MainCommunityPage: View {
    
    var body: some View {
        ZStack {
            RefreshableScrollView(
                onRefresh: { done in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.viewModel.onMorePageLoading()
                        
                        if UserManager.shared.isLogin {
                            self.viewModel.FantooUserApiCall()
                        } else {
                            self.viewModel.FantooGuestApiCall()
                        }
                        done()
                    }
                }) {
                    VStack(spacing: 0) {
                        categoryView
                        
                        noticeView
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray400.opacity(0.12))
                        
                        LazyVStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(boardHourTopTitle)
                                    .font(.title51622Medium)
                                    .foregroundColor(Color.gray900)
                                    .padding(EdgeInsets(top: 16, leading: sizeInfo.Hpadding, bottom: 4, trailing: 0))
                                
                                if !viewModel.board_hourList.isEmpty {
                                    issueTop5View
                                } else {
                                    listEmptyView
                                }
                            }
                            .background(Color.gray25)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text(boardWeekTopTitle)
                                    .font(.title51622Medium)
                                    .foregroundColor(.gray900)
                                    .padding(EdgeInsets(top: 16, leading: sizeInfo.Hpadding, bottom: 4, trailing: 0))
                                
                                if !viewModel.board_weekList.isEmpty {
                                    weekTop5View
                                } else {
                                    listEmptyView
                                }
                            }
                            .background(Color.gray25)
                        }
                        .background(Color.bgLightGray50)
                    }
                }
            
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 0) {
                    Spacer()
                    Button(action: {
                        if UserManager.shared.isLogin {
                            showCommunityEditorPage = true
                        } else {
                            // alert 메세지 띄우기
                        }
                    }, label: {
                        Image("bg_btn_hover")
                    })
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: sizeInfo.floatingButtonBottomSize, trailing: sizeInfo.Hpadding))
            }
        }
        .background(
            NavigationLink("", isActive: $showCommunityEditorPage) {
                CommunityEditorPage()
            }.hidden()
        )
        .background(
            NavigationLink("", isActive: $showCommunityHomePage) {
                if let NOclickedCategory = viewModel.clickedCategory {
                    CommunityHomePage(
                        code: NOclickedCategory.code,
                        naviTitle: NOclickedCategory.codeNameKo
                    )
                }
            }.hidden()
        )
        .onChange(of: UserManager.shared.showInitialViewState) { value in
            showNoticeMorePage = false
            showCommunityEditorPage = false
        }
        .onAppear() {
            if self.viewModel.isInit {
                self.viewModel.onMorePageLoading()
            }
            
            /**
             * 상세화면으로 갔다가 다시 오면, onAppear()가 호출되면서 좋아요/댓글 등 변경된 데이터가 보여짐
             */
            if UserManager.shared.isLogin {
                self.viewModel.FantooUserApiCall()
            } else {
                self.viewModel.FantooGuestApiCall()
            }
        }
        .onDisappear() {
            //print("idpilLog::: MainCommunityPage called onDisappear()")
        }
        .statusBarStyle(style: .darkContent)
    }
    
    var categoryView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image("icon_outline_move_favorite")
                    .onTapGesture {
                        showFavoritPage = true
                    }
                    .background(
                        NavigationLink("", isActive: $showFavoritPage) {
                            MainCommunityFavoritPage()
                        }.hidden()
                    )
                
                Divider()
                    .padding(.leading, 11.5)
                
                if !viewModel.category_CategoryList.isEmpty {
                    categoryRowView
                } else {
                    Spacer()
                }
            }
            .padding(.leading, sizeInfo.Hpadding)
            .padding(.vertical, 16)
        }
    }
    var categoryRowView: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack (spacing: 0) {
                ForEach(Array(viewModel.category_CategoryList.enumerated()), id: \.offset) { index, element in
                    ZStack (alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .style(
                                withStroke: Color.gray200,
                                lineWidth: 1,
                                fill: Color.gray25
                            )
                        
                        Text(element.codeNameKo)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray800)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                    }
                    .fixedSize()
                    .onTapGesture {
                        viewModel.clickedCategory = element
                        showCommunityHomePage = true
                        
                    }
                    .padding(.vertical, 1) // padding 값 1 없으면, 위-아래 테두리 선 약간 잘림
                    .padding(.leading, index==0 ? 16 : 6)
                    .padding(.trailing, index==viewModel.category_CategoryList.count-1 ? 16 : 0)
                    
                }
            }
        }
    }
    
    var noticeView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(noticeTitle)
                    .font(Font.buttons1420Medium)
                    .foregroundColor(Color.gray800)
                Spacer()
                
                if !viewModel.communityTotalNoticeList.isEmpty {
                    Text(noticeMore)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray400)
                        .onTapGesture {
                            showNoticeMorePage = true
                        }
                        .background(
                            NavigationLink("", isActive: $showNoticeMorePage) {
                                MainCommunityNoticePage()
                            }.hidden()
                        )
                }
            }
            .padding(.top, 12)
            
            if !viewModel.communityTotalNoticeList.isEmpty {
                noticeRowView
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
            ForEach(Array(viewModel.communityTotalNoticeList.enumerated()), id: \.offset) { index, element in
                
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
                .padding(.bottom, index==viewModel.communityTotalNoticeList.count-1 ? 16 : 8)
                .onTapGesture {
                    showNoticeDetailPage = true
                }
                .background(
                    NavigationLink("", isActive: $showNoticeDetailPage) {
                        CommunityNoticeDetailPage(noticePostId: element.postId)
                    }.hidden()
                )
                
                if index != viewModel.communityTotalNoticeList.count-1 {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray400.opacity(0.12))
                }
            }
        }
    }
    
    var issueTop5View: some View {
        
        ForEach(Array(self.viewModel.board_hourList.enumerated()), id: \.offset) { index, element in
            
            BoardRowView(viewType: BoardType.MainCommunity_Hour,
                         mainCommunity_BoardItem: element,
                         likeCount: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.LikeCount, boardType: MainCommunityLikeInfoType.Hour) as! Int),
                         likeBtnColor: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.LikeBtnColor, boardType: MainCommunityLikeInfoType.Hour) as! Color),
                         dislikeBtnColor: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.DisLikeBtnColor, boardType: MainCommunityLikeInfoType.Hour) as! Color),
                         likeTxtColor: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.LikeTxtColor, boardType: MainCommunityLikeInfoType.Hour) as! Color),
                         onPress: { buttonType in
                switch buttonType {
                case BoardButtonType.More:
                    print("more button cliked !")
                case .Like:
                    if element.likeYn {
                        //print("눌렀던 좋아요를 다시 누른 경우")
                        self.clickDeleteLike(targetType: "post", targetId: element.postId, index: index, boardType: MainCommunityLikeInfoType.Hour)
                    } else if !element.likeYn {
                        //print("처음 좋아요를 누른 경우")
                        self.clickLike(likeType: "like", targetType: "post", targetId: element.postId, index: index, boardType: MainCommunityLikeInfoType.Hour)
                    }
                case .Dislike:
                    if element.dislikeYn {
                        //print("눌렀던 싫어요를 다시 누른 경우")
                        self.clickDeleteLike(targetType: "post", targetId: element.postId, index: index, boardType: MainCommunityLikeInfoType.Hour)
                    } else if !element.dislikeYn {
                        //print("처음 싫어요를 누른 경우")
                        self.clickLike(likeType: "dislike", targetType: "post", targetId: element.postId, index: index, boardType: MainCommunityLikeInfoType.Hour)
                    }
                case .Comment:
                    print("comment button cliked !")
                }
            })
            
            Divider()
        }
        
    }
    
    var weekTop5View: some View {
        
        ForEach(Array(self.viewModel.board_weekList.enumerated()), id: \.offset) { index, element in
            
            BoardRowView(viewType: BoardType.MainCommunity_Week,
                         mainCommunity_BoardItem: element,
                         likeCount: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.LikeCount, boardType: MainCommunityLikeInfoType.Week) as! Int),
                         likeBtnColor: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.LikeBtnColor, boardType: MainCommunityLikeInfoType.Week) as! Color),
                         dislikeBtnColor: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.DisLikeBtnColor, boardType: MainCommunityLikeInfoType.Week) as! Color),
                         likeTxtColor: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.LikeTxtColor, boardType: MainCommunityLikeInfoType.Week) as! Color),
                         onPress: { buttonType in
                switch buttonType {
                case BoardButtonType.More:
                    print("more button cliked !")
                case .Like:
                    if element.likeYn {
                        //print("눌렀던 좋아요를 다시 누른 경우")
                        self.clickDeleteLike(targetType: "post", targetId: element.postId, index: index, boardType: MainCommunityLikeInfoType.Week)
                    } else if !element.likeYn {
                        //print("처음 좋아요를 누른 경우")
                        self.clickLike(likeType: "like", targetType: "post", targetId: element.postId, index: index, boardType: MainCommunityLikeInfoType.Week)
                    }
                case .Dislike:
                    if element.dislikeYn {
                        //print("눌렀던 싫어요를 다시 누른 경우")
                        self.clickDeleteLike(targetType: "post", targetId: element.postId, index: index, boardType: MainCommunityLikeInfoType.Week)
                    } else if !element.dislikeYn {
                        //print("처음 싫어요를 누른 경우")
                        self.clickLike(likeType: "dislike", targetType: "post", targetId: element.postId, index: index, boardType: MainCommunityLikeInfoType.Week)
                    }
                case .Comment:
                    print("comment button cliked !")
                }
            })
            
            Divider()
        }
    }
    
    var listEmptyView: some View {
        VStack(spacing: 0) {
            Image("character_club2")
            
            Text(noData_list)
                .font(.body21420Regular)
                .foregroundColor(.gray600)
                .padding(.top, 14)
            Rectangle()
                .frame(height: 0)
                .foregroundColor(.clear)
        }
        .padding(.vertical, 50)
        .padding(.horizontal, sizeInfo.Hpadding)
    }
    
    
    /**
     * 클럽 게시글 좋아요/싫어요 클릭 후, 결과 값 가져오기
     */
    func getMainCommunityLikeInfo(index: Int, btnType: BoardLikeInfoType, boardType: MainCommunityLikeInfoType) -> Any {
        if btnType == BoardLikeInfoType.LikeCount {
            var likeCount: Int = 0
            
            if boardType == .Hour {
                likeCount = viewModel.board_hourList[index].likeCnt-viewModel.board_hourList[index].dislikeCnt
            }
            else if boardType == .Week {
                likeCount = viewModel.board_weekList[index].likeCnt-viewModel.board_weekList[index].dislikeCnt
            }
            return likeCount
        }
        else if btnType == BoardLikeInfoType.LikeBtnColor {
            var likeBtnColor: Color = Color.stateDisabledGray200
            
            if boardType == .Hour {
                likeBtnColor  = viewModel.board_hourList[index].likeYn ? Color.stateActivePrimaryDefault : Color.stateDisabledGray200
                return likeBtnColor
            }
            else if boardType == .Week {
                likeBtnColor  = viewModel.board_weekList[index].likeYn ? Color.stateActivePrimaryDefault : Color.stateDisabledGray200
                return likeBtnColor
            }
            else {
                return Color.stateDisabledGray200
            }
        }
        else if btnType == BoardLikeInfoType.DisLikeBtnColor {
            var dislikeBtnColor: Color = Color.stateDisabledGray200
            
            if boardType == .Hour {
                dislikeBtnColor  = viewModel.board_hourList[index].dislikeYn ? Color.stateActiveGray700 : Color.stateDisabledGray200
                return dislikeBtnColor
            }
            else if boardType == .Week {
                dislikeBtnColor  = viewModel.board_weekList[index].dislikeYn ? Color.stateActiveGray700 : Color.stateDisabledGray200
                return dislikeBtnColor
            }
            else {
                return Color.stateDisabledGray200
            }
        }
        else if btnType == BoardLikeInfoType.LikeTxtColor {
            var likeTxtColor: Color = Color.stateActiveGray700
            
            if boardType == .Hour {
                likeTxtColor  = viewModel.board_hourList[index].likeYn ? Color.stateActivePrimaryDefault : Color.stateActiveGray700
                return likeTxtColor
            }
            else if boardType == .Week {
                likeTxtColor  = viewModel.board_weekList[index].likeYn ? Color.stateActivePrimaryDefault : Color.stateActiveGray700
                return likeTxtColor
            }
            else {
                return Color.stateActiveGray700
            }
        }
        else {
            return ""
        }
    }
}

extension MainCommunityPage {
    
    func clickLike(likeType: String, targetType: String, targetId: Int, index: Int, boardType: MainCommunityLikeInfoType) {
        self.viewModel.postCommunityLike(likeType: likeType, targetType: targetType, targetId: targetId, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, clickedIndex: index, boardType: boardType)
    }
    
    func clickDeleteLike(targetType: String, targetId: Int, index: Int, boardType: MainCommunityLikeInfoType) {
        self.viewModel.deleteCommunityLike(targetType: targetType, targetId: targetId, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, clickedIndex: index, boardType: boardType)
    }
}

struct MainCommunityPage_Previews: PreviewProvider {
    static var previews: some View {
        MainCommunityPage()
    }
}
