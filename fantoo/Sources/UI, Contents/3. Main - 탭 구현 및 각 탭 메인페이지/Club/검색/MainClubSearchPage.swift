//
//  MainClubSearchPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/01.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainClubSearchPage {
    // 취소버튼 클릭시, NavigationLink 뒤로가기
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewModel = MainClubSearchViewModel()
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    /**
     * 언어팩 등록할 것
     */
    private let txtmainClubSearchHint = "클럽명 또는 클럽 #태그 검색"
    private let txtRecentSearch = "최근 검색"
    private let txtTotalDelete = "전체삭제"
    private let txtRecentSearchEmpty = "최근 검색 이력이 없습니다"
    private let txtPopularClub100 = "인기 클럽 100"
}

extension MainClubSearchPage: View {
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                /**
                 * 화면 상단 네비에서 '검색바'의 하단 공백 길이가 짧아서,
                 * 아래와 같이, 검색바 하단 공백인 것처럼 보이도록 구현했음
                 * (CustomNavigationBar.swift 에서 하단 공백을 적용하려고 했는데 잘 안 됐음.)
                 */
                Spacer()
                    .frame(width: UIScreen.screenWidth, height: 10)
                    .background(Color.gray25)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        
                        if viewModel.showInitView {
                            recentSearchView

                            popularClub100
                        } else {
                            
                            popularClub100
                        }

                    }
                }
            }
            .background(Color.bgLightGray50)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            self.callRemoteData()
            
            if viewModel.isPageLoading {
                // 페이지 내에서 로딩
                StatusManager.shared.loadingStatus = .ShowWithTouchable
            }
        }
        .onChange(of: viewModel.isKeyboardEnter) { isKeyboardEntered in
            /**
             * 키보드에서 엔터 입력
             */
            if isKeyboardEntered {
                // 1. ViewModel의 String 배열에 입력된 검색어 추가
                viewModel.writeLocalSearchData()
                
                // 2. 검색 API 콜해서 리스트로 보여주기
                viewModel.getSearchResult()
            }
            
            // 다음 검색을 위해 관련 변수 초기화
            viewModel.isKeyboardEnter = false
            viewModel.searchText = ""
        }
        .navigationType(
            isShowSearchBar: true,
            searchText: $viewModel.searchText,
            isKeyboardEnter: $viewModel.isKeyboardEnter,
            placeholder: txtmainClubSearchHint,
            leftItemsForegroundColor: .black,
            rightItemsForegroundColor: .black,
            title: "".localized,
            onPress: { buttonType in
            if buttonType == .Cancel {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
    
    var recentSearchView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(txtRecentSearch)
                    .font(Font.title51622Medium)
                    .foregroundColor(.gray900)
                Spacer()
                Button(action: {
                    viewModel.deleteLocalSearchAllData()
                }) {
                    Text(txtTotalDelete)
                        .font(Font.caption11218Regular)
                        .foregroundColor(.gray400)
                }
            }

            searchListView
        }
        .padding(.top, 14)
        .padding(.horizontal, sizeInfo.Hpadding)
    }
    var searchListView: some View {
        HStack(spacing: 0) {
            if viewModel.arrSearchText.count > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {

                        /**
                         * 최신 순서로 정렬해야 하니 역방향 정렬을 한다 (.reversed())
                         */
                        ForEach(viewModel.arrSearchText.enumerated().reversed(), id: \.offset) { index, element in

                            HStack(spacing: 0) {

                                Text(viewModel.getValue(obj: element))
                                    .font(.caption11218Regular)
                                    .foregroundColor(.gray800)
                                    .onTapGesture(perform: {
                                        // 0. 선택된 단어를 viewModel의 @Published으로 선언된 변수 searchText에 대입
                                        viewModel.searchText = viewModel.getValue(obj: element)

                                        // 1. ViewModel의 String 배열에 입력된 검색어 추가
                                        viewModel.writeLocalSearchData()

                                        // 2. 검색 API 콜해서 리스트로 보여주기
                                        viewModel.getSearchResult()
                                    })

                                Button(action: {
                                    viewModel.deleteLocalSearchData(index: index)
                                }, label: {
                                    Image("icon_outline_cancel")
                                        .renderingMode(.template)
                                        .resizable()
                                        .foregroundColor(Color.gray300)
                                        .frame(width: 12, height: 12)
                                })
                                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                            }
                            .padding(.vertical, 7)
                            .padding(.horizontal, 13)
                            .background(Color.gray50)
                            .clipShape(Capsule())
                            .padding(.leading, index==viewModel.arrSearchText.count-1 ? 14 : 8) // 마지막 번째 아이템이면 14이고 나머지는 8 (역방향 정렬이기 때문)
                            .padding(.trailing, index==0 ? 14 : 0)  // 첫 번째 아이템이면 14이고 나머지는 0 (역방향 정렬이기 때문)
                        }
                    }
                }
            }
            else {
                Text(txtRecentSearchEmpty)
                    .font(.caption11218Regular)
                    .foregroundColor(.gray500)
            }
        }
        .frame(width: UIScreen.screenWidth-(sizeInfo.Hpadding*2), height: 60)
        .background(
            RoundedRectangle(cornerRadius: 12.0)
                .foregroundColor(Color.gray25)
                .shadow(color: Color.gray400.opacity(0.3), radius: 3)
        )
        .padding(.top, 8)
    }
    
    var popularClub100: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(txtPopularClub100)
                    .font(.title51622Medium)
                    .foregroundColor(.gray900)
                Spacer()
            }
            
            popularClub100_List
        }
        .padding(.top, 16)
        .padding(.horizontal, sizeInfo.Hpadding)
    }
    var popularClub100_List: some View {
        ForEach(Array(viewModel.mainClub_MainPage_MyClub.enumerated()), id: \.offset) { index, element in
            
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    WebImage(url: URL(string: element.club_image))
                        .resizable()
                        .frame(width: 38, height: 38)
                        .cornerRadius(12)
                        .fixedSize()
                        .overlay(
                            Image("icon_fill_private")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(.gray25)
                                .frame(width: 20, height: 20)
                                .background(
                                    RoundedCornersShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 12)
                                        .fill(Color.gray900.opacity(0.3))
                                        .frame(width: 38, height: 38)
                                )
                                .opacity(element.lock ? 1.0 : 0.0)
                        )
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(element.club_name)
                        .font(.buttons1420Medium)
                        .foregroundColor(.gray900)
                    
                    /**
                     * join an array of strings into a single string
                     */
                    let joined = "#" + element.club_tags.joined(separator: " #")
                    Text(joined)
                        .font(.caption11218Regular)
                        .foregroundColor(.gray700)
                        .lineLimit(1)
                        .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                    
                    if let _ = element.users {
                        HStack(spacing: 0) {
                            Image("icon_outline_member")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(.gray500)
                                .frame(width: 12, height: 12)
                            
                            Text(String(element.users))
                                .font(.caption11218Regular)
                                .foregroundColor(.gray500)
                                .padding(.leading, 4)
                        }
                        .padding(.top, 1)
                    }
                }
                .padding(.leading, 12)
                
                Spacer()
            }
            .padding(10)
            .background(Color.gray25)
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
            .shadow(color: Color.gray400.opacity(0.3), radius: 3)
            .padding(.top, index==0 ? 8 : 12)
            .padding(.bottom, index==viewModel.mainClub_MainPage_MyClub.count-1 ? sizeInfo.Hpadding : 0)
        }
    }
}

extension MainClubSearchPage {
    func callRemoteData() {
        self.viewModel.getMainClub_MyPage()
    }
}

struct MainClubSearchPage_Previews: PreviewProvider {
    static var previews: some View {
        MainClubSearchPage()
    }
}
