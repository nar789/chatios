//
//  MainCommunitySearchPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/07/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct MainCommunitySearchPage: View {
    // 취소버튼 클릭시, NavigationLink 뒤로가기
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewModel = MainCommunitySearchViewModel()
    
    /**
     * 언어팩 등록할 것
     */
    private let noData_board = "관련된 커뮤니티 게시글이 없습니다."
    private let searchRecent = "최근 검색"
    private let searchPlaceholder = "커뮤니티 게시글 검색"
    private let searchTotalDelete = "전체삭제"
    private let searchRecentEmpty = "최근 검색 이력이 없습니다."
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    if viewModel.showSearchHistoryViewer {
                        recentSearchWordView
                    }

                    if viewModel.showSearchResultViewer {
                        if viewModel.mainCommunity_Search_List.count > 0 {
                            searchResultView
                        } else {
                            emptyView
                        }
                    }
                }
            }
            .background(Color.bgLightGray50)
            .padding(.top, 12)
            
        }
        .onChange(of: viewModel.isKeyboardEnter) { isKeyboardEntered in
            /**
             * 키보드에서 엔터 입력
             */
            if isKeyboardEntered && viewModel.searchText.count>0 {
                
                // 1. ViewModel의 String 배열에 입력된 검색어 추가
                viewModel.writeLocalSearchData()
                
                // 2. 검색 API 콜해서 리스트로 보여주기
                viewModel.getMemberSearch(
                    integUid: UserManager.shared.uid,
                    nextId: 0,
                    search: viewModel.searchText,
                    size: 30,
                    access_token: UserManager.shared.accessToken
                )
            }
        }
        .navigationType(isShowSearchBar: true, searchText: $viewModel.searchText, isKeyboardEnter: $viewModel.isKeyboardEnter, placeholder: searchPlaceholder, leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "".localized, onPress: { buttonType in
            //print("onPress buttonType : \(buttonType)")
            if buttonType == .Cancel {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
    
    var recentSearchWordView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(searchRecent)
                    .font(Font.title51622Medium)
                    .foregroundColor(.gray900)
                Spacer()
                Button(action: {
                    viewModel.deleteLocalSearchAllData()
                }) {
                    Text(searchTotalDelete)
                        .font(Font.caption11218Regular)
                        .foregroundColor(.gray600)
                }
            }
            
            HStack(spacing: 0) {
                
                if viewModel.arrSearchText.count > 0 {
                    searchListView
                }
                else {
                    Spacer()
                    Text(searchRecentEmpty)
                        .font(Font.body21420Regular)
                        .foregroundColor(.gray600)
                        .padding(.vertical, 21)
                    Spacer()
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.gray25)
                    .shadow(color: .black.opacity(0.1), radius: 3)
            )
            .padding(.top, 8)
        }
        .padding(EdgeInsets(top: 14, leading: 20, bottom: 0, trailing: 20))
        
    }
    
    var searchListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                /**
                 * 정방향 정렬
                 * ForEach((0..<viewModel.arrSearchText.count).reversed(), id: \.self)
                 * 역방향 정렬
                 * ForEach((0..<viewModel.arrSearchText.count).reversed(), id: \.self)
                 *
                 * 최신순으로 정렬해야 하니 역방향 정렬을 한다.
                 */
                ForEach((0..<viewModel.arrSearchText.count).reversed(), id: \.self) { i in
                    
                    ZStack (alignment: .center) {
                        RoundedRectangle(cornerRadius: 30)
                            .style(
                                withStroke: Color.gray200.opacity(0),
                                lineWidth: 0,
                                fill: Color.gray50
                            )
                            .padding(.vertical, 1)
                            .padding(.horizontal, 3)
                        
                        HStack(spacing: 0) {
                            Text(viewModel.getValue(obj: viewModel.arrSearchText[i]))
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray800)
                                .onTapGesture {
                                    // 0. 선택된 단어를 viewModel의 @Published으로 선언된 변수 searchText에 대입
                                    viewModel.searchText = viewModel.getValue(obj: viewModel.arrSearchText[i])
                                    
                                    // 1. ViewModel의 String 배열에 입력된 검색어 추가
                                    viewModel.writeLocalSearchData()
                                    
                                    // 2. 검색 API 콜해서 리스트로 보여주기
                                    viewModel.getMemberSearch(
                                        integUid: UserManager.shared.uid,
                                        nextId: 0,
                                        search: viewModel.searchText,
                                        size: 30,
                                        access_token: UserManager.shared.accessToken
                                    )
                                }
                            
                            Button(action: {
                                viewModel.deleteLocalSearchData(index: i)
                            }, label: {
                                Image("icon_outline_cancel")
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundColor(Color.gray200)
                                    .frame(width: 12, height: 12)
                            })
                            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                        }
                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    }
                    .fixedSize()
                    .padding(.leading, i==viewModel.arrSearchText.count-1 ? 14:0)
                    .padding(.trailing, i==0 ? 14:0)
                }
            }
        }
        .padding(.vertical, 14)
    }
    
    var searchResultView: some View {
        VStack(spacing: 0) {
            Divider()
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(viewModel.mainCommunity_Search_List.enumerated()), id: \.offset) { index, element in
                        
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
                            case BoardButtonType.Like:
                                // 눌렀던 좋아요를 다시 누른 경우
                                if element.likeYn {
                                    self.clickDeleteLike(targetType: "post", targetId: element.postId, index: index)
                                }
                                // 처음 좋아요를 누른 경우
                                else if !element.likeYn {
                                    self.clickLike(likeType: "like", targetType: "post", targetId: element.postId, index: index)
                                }
                            case BoardButtonType.Dislike:
                                // 눌렀던 싫어요를 다시 누른 경우
                                if element.dislikeYn {
                                    self.clickDeleteLike(targetType: "post", targetId: element.postId, index: index)
                                }
                                // 처음 싫어요를 누른 경우
                                else if !element.dislikeYn {
                                    self.clickLike(likeType: "dislike", targetType: "post", targetId: element.postId, index: index)
                                }
                            case BoardButtonType.Comment:
                                print("comment button cliked !")
                            }
                        })
                        .background(Color.gray25)
                        .onAppear {
                            fetchMoreData(element)
                        }
                    }
                }
                .background(Color.bgLightGray50)
                
            }
            // make disable the bouncing
            .introspectScrollView {
                $0.bounces = false
            }
        }
    }
    
    var emptyView: some View {
        HStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                Image("character_club2")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text(noData_board)
                    .font(.body21420Regular)
                    .foregroundColor(.gray600)
                    .padding(.top, 14)
            }
            Spacer()
        }
        .padding(.top, 130)
    }
    
    
    
    /**
     * 클럽 게시글 좋아요/싫어요 클릭 후, 결과 값 가져오기
     */
    func getMainCommunityLikeInfo(index: Int, btnType: BoardLikeInfoType, boardType: MainCommunityLikeInfoType) -> Any {
        if btnType == BoardLikeInfoType.LikeCount {
            var likeCount: Int = 0
            
            if boardType == .Hour {
                likeCount = viewModel.mainCommunity_Search_List[index].likeCnt-viewModel.mainCommunity_Search_List[index].dislikeCnt
            }
            return likeCount
        }
        else if btnType == BoardLikeInfoType.LikeBtnColor {
            var likeBtnColor: Color = Color.stateDisabledGray200
            
            if boardType == .Hour {
                likeBtnColor  = viewModel.mainCommunity_Search_List[index].likeYn ? Color.stateActivePrimaryDefault : Color.stateDisabledGray200
                return likeBtnColor
            }
            else {
                return Color.stateDisabledGray200
            }
        }
        else if btnType == BoardLikeInfoType.DisLikeBtnColor {
            var dislikeBtnColor: Color = Color.stateDisabledGray200
            
            if boardType == .Hour {
                dislikeBtnColor  = viewModel.mainCommunity_Search_List[index].dislikeYn ? Color.stateActiveGray700 : Color.stateDisabledGray200
                return dislikeBtnColor
            }
            else {
                return Color.stateDisabledGray200
            }
        }
        else if btnType == BoardLikeInfoType.LikeTxtColor {
            var likeTxtColor: Color = Color.stateActiveGray700
            
            if boardType == .Hour {
                likeTxtColor  = viewModel.mainCommunity_Search_List[index].likeYn ? Color.stateActivePrimaryDefault : Color.stateActiveGray700
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

extension MainCommunitySearchPage {
    
    fileprivate func fetchMoreData(_ boardList: Community_BoardItem) {
        if self.viewModel.mainCommunity_Search_List.last == boardList {
            print("[마지막]에 도달했다")
            
            guard let nextPage = self.viewModel.mainCommunity_Search?.nextId else {
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
    
    func clickLike(likeType: String, targetType: String, targetId: Int, index: Int) {
        self.viewModel.postCommunityLike(likeType: likeType, targetType: targetType, targetId: targetId, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, clickedIndex: index)
    }

    func clickDeleteLike(targetType: String, targetId: Int, index: Int) {
        self.viewModel.deleteCommunityLike(targetType: targetType, targetId: targetId, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, clickedIndex: index)
    }
    
}

struct MainCommunitySearchPage_Previews: PreviewProvider {
    static var previews: some View {
        MainCommunitySearchPage()
    }
}
