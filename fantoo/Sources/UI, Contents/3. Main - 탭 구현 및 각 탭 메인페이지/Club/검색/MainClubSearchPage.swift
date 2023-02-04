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
    @StateObject var userManager = UserManager.shared
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
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
                            if !viewModel.clubSearchResultList.isEmpty {
                                clubResult_List
                            } else {
                                emptyView
                            }
                        }
                    }
                }
            }
            .background(Color.bgLightGray50)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            self.callRemoteData()
        }
        .onChange(of: viewModel.isKeyboardEnter) { isKeyboardEntered in
            /**
             * 키보드에서 엔터 입력
             */
            if isKeyboardEntered {
                // 1. ViewModel의 String 배열에 입력된 검색어 추가
                viewModel.writeLocalSearchData()
                
                // 2. 검색 API 콜해서 리스트로 보여주기
                viewModel.getSearchResult(
                    nextId: "0",
                    size: String(DefineSize.ListSize.Common))
            }
            
            // 다음 검색을 위해 관련 변수 초기화
            viewModel.isKeyboardEnter = false
        }
        .navigationType(
            isShowSearchBar: true,
            searchText: $viewModel.searchText,
            isKeyboardEnter: $viewModel.isKeyboardEnter,
            placeholder: "k_searching_club_or_clubname_with_tag".localized,
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
                Text("c_recently_search".localized)
                    .font(Font.title51622Medium)
                    .foregroundColor(.gray900)
                Spacer()
                Button(action: {
                    viewModel.deleteLocalSearchAllData()
                }) {
                    Text("j_delete_all".localized)
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
                                        viewModel.setSearchText(txt: viewModel.getValue(obj: element))

                                        // 1. ViewModel의 String 배열에 입력된 검색어 추가
                                        viewModel.writeLocalSearchData()

                                        // 2. 검색 API 콜해서 리스트로 보여주기
                                        viewModel.getSearchResult(
                                            nextId: "0",
                                            size: String(DefineSize.ListSize.Common))
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
                Text("se_c_not_exist_recently_search_history".localized)
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
                Text("a_popular_club_100".localized)
                    .font(.title51622Medium)
                    .foregroundColor(.gray900)
                Spacer()
            }
            
            if !viewModel.popularClub100List.isEmpty {
                popularClub100_List
            }
            
        }
        .padding(.top, 16)
        .padding(.horizontal, sizeInfo.Hpadding)
    }
    var popularClub100_List: some View {
        ForEach(Array(viewModel.popularClub100List.enumerated()), id: \.offset) { index, element in

            HStack(alignment: .top, spacing: 0) {
                
                VStack(spacing: 0) {
                    WebImage(url: URL(string: element.bgImg.imageOriginalUrl))
                        .placeholder(content: {
                            Image("profile_club_character")
                                .resizable()
                        })
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
                                .opacity(element.openYn ? 0.0 : 1.0)
                        )

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text(element.clubName)
                        .font(.buttons1420Medium)
                        .foregroundColor(.gray900)

                    
                    if !element.hashtagList.isEmpty {
                        /**
                         * join an array of strings into a single string
                         */
                        let joined = "#" + element.hashtagList.joined(separator: " #")
                        Text(joined)
                            .font(.caption11218Regular)
                            .foregroundColor(.gray700)
                            .lineLimit(1)
                            .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                    }

                    if element.memberCountOpenYn {
                        HStack(spacing: 0) {
                            Image("icon_outline_member")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(.gray500)
                                .frame(width: 12, height: 12)

                            Text(String(element.memberCount))
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
            .padding(.bottom, index==viewModel.popularClub100List.count-1 ? sizeInfo.Hpadding : 0)
        }
    }
    
    var clubResult_List: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.clubSearchResultList.enumerated()), id: \.offset) { index, element in

                HStack(alignment: .top, spacing: 0) {
                    
                    VStack(spacing: 0) {
                        WebImage(url: URL(string: element.bgImg.imageOriginalUrl))
                            .placeholder(content: {
                                Image("profile_club_character")
                                    .resizable()
                            })
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
                                    .opacity(element.openYn ? 0.0 : 1.0)
                            )

                        Spacer()
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Text(element.clubName)
                            .font(.buttons1420Medium)
                            .foregroundColor(.gray900)

                        
                        if !element.hashtagList.isEmpty {
                            /**
                             * join an array of strings into a single string
                             */
                            let joined = "#" + element.hashtagList.joined(separator: " #")
                            Text(joined)
                                .font(.caption11218Regular)
                                .foregroundColor(.gray700)
                                .lineLimit(1)
                                .allowsTightening(false) // 글자 압축 안 함 - '점점점'으로 처리
                        }

                        if element.memberCountOpenYn {
                            HStack(spacing: 0) {
                                Image("icon_outline_member")
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundColor(.gray500)
                                    .frame(width: 12, height: 12)

                                Text(String(element.memberCount))
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
                .padding(.bottom, index==viewModel.popularClub100List.count-1 ? sizeInfo.Hpadding : 0)
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, sizeInfo.Hpadding)
    }
    var emptyView: some View {
        HStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                Image("character_club2")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text("se_g_not_exist_search_result_club".localized)
                    .font(.body21420Regular)
                    .foregroundColor(.gray600)
                    .padding(.top, 14)
            }
            Spacer()
        }
        .padding(.top, 130)
    }
}

extension MainClubSearchPage {
    func callRemoteData() {
        CommonFunction.onPageLoading()
        
        self.viewModel.getPopularClubTop100(integUid: userManager.uid)
    }
}

struct MainClubSearchPage_Previews: PreviewProvider {
    static var previews: some View {
        MainClubSearchPage()
    }
}
