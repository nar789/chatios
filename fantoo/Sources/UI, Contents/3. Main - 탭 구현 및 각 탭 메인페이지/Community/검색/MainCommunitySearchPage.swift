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
    
    var body: some View {
        VStack {
            if viewModel.showSearchWordListViewer {
                searchView
            }
            
            if viewModel.showSearchResultViewer {
                if viewModel.mainCommunity_Search_List.count > 0 {
                    searchResultView
                } else {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        Text("전체 \(String(viewModel.mainCommunity_Search_List.count))건")
                            .font(Font.title5Roboto1622Medium)
                            .foregroundColor(.gray600)
                            .padding(EdgeInsets(top: 16, leading: 20, bottom: 12, trailing: 0))
                        Divider()
                        Text("검색된 커뮤니티 게시글이 없습니다.")
                            .font(Font.body21420Regular)
                            .foregroundColor(.gray600)
                            .padding(EdgeInsets(top: 32, leading: 20, bottom: 0, trailing: 20))
                    }
                }
            }
            
            Spacer()
        }
        .onAppear {
            if viewModel.isPageLoading {
                // 페이지 내에서 로딩
                StatusManager.shared.loadingStatus = .ShowWithTouchable
            }
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
        .background(Color.gray25)
        .navigationType(isShowSearchBar: true, searchText: $viewModel.searchText, isKeyboardEnter: $viewModel.isKeyboardEnter, placeholder: "커뮤니티 게시글 검색", leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "".localized, onPress: { buttonType in
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
    
    
    var searchView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("최근 검색")
                    .font(Font.title51622Medium)
                    .foregroundColor(.gray900)
                Spacer()
                Button(action: {
                    viewModel.deleteLocalSearchAllData()
                }) {
                    Text("전체삭제")
                        .font(Font.caption11218Regular)
                        .foregroundColor(.gray600)
                }
            }
            .padding(EdgeInsets(top: 16, leading: 18, bottom: 0, trailing: 18))
            
            Spacer()
            if viewModel.arrSearchText.count>0 {
                searchListView
            }
            else {
                Text("최근 검색 이력이 없습니다.")
                    .font(Font.body21420Regular)
                    .foregroundColor(.gray600)
            }
            Spacer()
        }
        .frame(height: 102)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.gray25)
                .shadow(color: .black.opacity(0.1), radius: 3)
        )
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
        
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
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: i==0 ? 16:0))
                    .padding(EdgeInsets(top: 0, leading: i==viewModel.arrSearchText.count-1 ? 16:0, bottom: 0, trailing: 0))
                }
                
            }
        }
    }
    
    var searchResultView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0) {
                
                Text("전체 \(viewModel.mainCommunity_Search_List.count)건")
                    .font(Font.title5Roboto1622Medium)
                    .font(.system(size: 16))
                    .foregroundColor(Color.gray600)
                    .padding(EdgeInsets(top: 16, leading: 20, bottom: 12, trailing: 0))
                
                Divider()
                
                LazyVStack(spacing: 10) {
                    
                    ForEach(Array(viewModel.mainCommunity_Search_List.enumerated()), id: \.offset) { index, element in
                        BoardRowView(viewType: BoardType.MainCommunity_Hour,
                                     mainCommunity_BoardItem: element,
                                     likeCount: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.LikeCount, boardType: MainCommunityLikeInfoType.Hour) as! Int),
                                     likeBtnColor: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.LikeBtnColor, boardType: MainCommunityLikeInfoType.Hour) as! Color),
                                     dislikeBtnColor: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.DisLikeBtnColor, boardType: MainCommunityLikeInfoType.Hour) as! Color),
                                     likeTxtColor: (self.getMainCommunityLikeInfo(index: index, btnType: BoardLikeInfoType.LikeTxtColor, boardType: MainCommunityLikeInfoType.Hour) as! Color),
                                     onPress: { buttonType in
                            //
                        })
                        .background(Color.gray25)
                    }
                }
                .background(Color.bgLightGray50)
            }
            
        }
        // make disable the bouncing
        .introspectScrollView {
            $0.bounces = false
        }
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

struct MainCommunitySearchPage_Previews: PreviewProvider {
    static var previews: some View {
        MainCommunitySearchPage()
    }
}
