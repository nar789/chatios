//
//  MainCommunityFavoritPage.swift
//  NotificationService
//
//  Created by kimhongpil on 2022/07/24.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainCommunityFavoritPage {
    @StateObject var viewModel = MainCommunityFavoritViewModel()
    
    @State var isOn: Bool = false
    @State var isMyFavoriteEmpty = false
    @State var favoriteTxt: String = "팬투 추천순"
    @State var selectedSEQ: Int = -1 // 선택될 수 없음 값으로 초기화
    
    // popup
    @State private var showSheetFavoriteVisibility = false
    @State private var showCommunityHomePage = false
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
        static let bottomSheetHeight: CGFloat = 189.0 + DefineSize.SafeArea.bottom
    }
    
    /**
     * 언어팩 등록할 것
     */
    private let naviTitle = "커뮤니티 게시판"
    private let favoritePopupTitle = "정렬"
    private let isOwner = "a_operate".localized  // MainClubPage.swift 에서 이미 있음
    private let favoriteClubEmpty_1 = "즐겨찾는 클럽이 없습니다."
    private let favoriteClubEmpty_2 = "자주 방문하는 커뮤니티를 즐겨찾기하여\n더 쉽게 방문해 보세요."
    
    
}

extension MainCommunityFavoritPage: View {
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            if !viewModel.isPageLoading {
                ZStack {
                    if isOn {
                        favoriteClubListView
                    } else {
                        clubListView
                    }
                }
            }
            
            Spacer()
        }
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
        .onAppear {
            self.callRemoteData()
        }
        .onChange(of: favoriteTxt) { newValue in
            if selectedSEQ == 1 {
                viewModel.getMainCommunity_UserCategory_Recog()
            } else if selectedSEQ == 2 {
                viewModel.getMainCommunity_UserCategory_Popular()
            }
        }
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: naviTitle, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        //MARK: - Shpw Sheet
        .bottomSheet(isPresented: $showSheetFavoriteVisibility, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
            
            CommonSettingBottomView(
                title: favoritePopupTitle,
                type: .CommunityFavorite,
                isShow: $showSheetFavoriteVisibility,
                selectedText: $favoriteTxt,
                selectedSEQ: $selectedSEQ,
                selectedYn: .constant(false)) { seq in
                    
                }
        })
    }
    
    var headerView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Group {
                    Text(favoriteTxt)
                        .font(.caption11218Regular)
                        .foregroundColor(.gray700)
                    
                    Image("icon_outline_dropdown")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(.stateEnableGray400)
                        .frame(width: 12, height: 12)
                        .padding(.leading, 4)
                }
                .onTapGesture {
                    showSheetFavoriteVisibility = true
                }
                
                Spacer()
                
                Text("j_favorite".localized)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray500)
                    .padding(.trailing)
                
                Toggle(isOn: $isOn, label: {
                })
                .onChange(of: isOn, perform: { newValue in
                    print("newValue : \(newValue)")
                })
                .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
                .fixedSize()
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            ExDivider(color: Color.gray400, height: 1)
                .opacity(0.12)
                .padding(.top, 11.5)
        }
        .padding(.top, 11.5)
    }
    
    var favoriteClubListView: some View {
        Group {
            if viewModel.category_CategoryList.count > 0 {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(Array(viewModel.category_CategoryList.enumerated()), id: \.offset) { index, element in
                            
                            if element.favorite {
                                MainCommunity_FavoritPage_Row(
                                    element: element,
                                    isClickFavoriteBtn: { isClick in
                                        if isClick {
                                            
                                            // 즐겨찾기 등록한 상태에서, 삭제하려는 경우
                                            if element.favorite {
                                                viewModel.deleteCategoryFavorite(code: element.code, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, isComplete: { state in
                                                    
                                                    if state {
                                                        //print("삭제 완료 !!!")
                                                        viewModel.completeFavorite(position: index)
                                                    }
                                                })
                                            }
                                        }
                                    },
                                    isClickItem: { isClick in
                                        if isClick {
                                            viewModel.clickedCategory = element
                                            showCommunityHomePage = true
                                        }
                                    }
                                )
                                .padding(.vertical, 9.5)
                                .padding(.horizontal, sizeInfo.Hpadding)
                                
                                Divider()
                                    .frame(width: UIScreen.screenWidth)
                            }
                        }
                    }
                    .padding(.top, sizeInfo.Hpadding)
                    
                }
            } else {
                noFavoriteClubListView
            }
        }
    }
    
    var noFavoriteClubListView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image("character_main2")
                .resizable()
                .frame(width: 118, height: 124)
            
            Text(favoriteClubEmpty_1)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray600)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            Text(favoriteClubEmpty_2)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray600)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            
            Spacer()
        }
        .padding(.horizontal, 71)
        .padding(.bottom, 100)
    }
    
    var clubListView: some View {
        Group {
            if viewModel.category_CategoryList.count > 0 {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(Array(viewModel.category_CategoryList.enumerated()), id: \.offset) { index, element in
                            
                            MainCommunity_FavoritPage_Row(
                                element: element,
                                isClickFavoriteBtn: { isClick in
                                    if isClick {
                                        
                                        // 즐겨찾기 등록한 상태에서, 삭제하려는 경우
                                        if element.favorite {
                                            viewModel.deleteCategoryFavorite(code: element.code, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, isComplete: { state in
                                                
                                                if state {
                                                    //print("삭제 완료 !!!")
                                                    viewModel.completeFavorite(position: index)
                                                }
                                            })
                                        }
                                        // 즐겨찾기 등록 안 한 상태에서, 등록하려는 경우
                                        else if !element.favorite {
                                            viewModel.postCategoryFavorite(code: element.code, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken, isComplete: { state in
                                                
                                                if state {
                                                    //print("등록 완료 !!!")
                                                    viewModel.completeFavorite(position: index)
                                                }
                                            })
                                        }
                                    }
                                },
                                isClickItem: { isClick in
                                    if isClick {
                                        viewModel.clickedCategory = element
                                        showCommunityHomePage = true
                                    }
                                }
                            )
                            .padding(.vertical, 9.5)
                            .padding(.horizontal, sizeInfo.Hpadding)
                            
                            Divider()
                                .frame(width: UIScreen.screenWidth)
                        }
                    }
                    .padding(.top, sizeInfo.Hpadding)
                    
                }
            } else {
                noFavoriteClubListView
            }
        }
    }
}

extension MainCommunityFavoritPage {
    func callRemoteData() {
        self.viewModel.getMainCommunity_UserCategory_Recog()
    }
}

struct MainCommunity_FavoritPage_Row: View {
    let element: MainCommunity_Category_CategoryList
    var isClickFavoriteBtn: ((Bool) -> Void)
    var isClickItem: ((Bool) -> Void)
    
    var body: some View {
        HStack(spacing: 0) {
            
            WebImage(url: URL(string: !element.categoryImage.imageOriginalUrl.isEmpty ? element.categoryImage.imageOriginalUrl : ""))
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .padding(6)
                .foregroundColor(.gray25)
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(Color.bgMainPrimary300)
                )

            Text(element.codeNameKo)
                .font(.buttons1420Medium)
                .foregroundColor(.gray900)
                .padding(.leading, 12)

            Spacer()

            Image("icon_fill_bookmark")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(element.favorite ? Color(red: 1.0, green: 0.62, blue: 0.62) : Color.gray200)
                .frame(width: 24, height: 24)
                .onTapGesture(perform: {
                    isClickFavoriteBtn(true)
                })
        }
        .background(Color.gray25) // 배경 지정을 해줘야, 아이템 뷰 여백을 클릭할 때 아래 onTapGesture 가 적용됨
        .onTapGesture {
            isClickItem(true)
        }
    }
}

struct MainCommunity_FavoritPage_RowView: View {
    
    @State var bookmarkImageToggle = false
    
    let index: Int
    let element: MainCommunity_Category_CategoryList
    var viewModel = MainCommunityFavoritViewModel()
    
    /**
     * 언어팩 등록할 것
     */
    private let isOwner = "a_operate".localized  // MainClubPage.swift 에서 이미 있음
    
    var body: some View {
        HStack(spacing: 0) {
            Image("bi_fantoo")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(.gray25)
                .frame(width: 20, height: 20)
                .background(
                    RoundedCornersShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 12)
                        .fill(Color.bgMainPrimary300)
                        .frame(width: 38, height: 38)
                )
            
            Text(element.codeNameKo)
                .font(.buttons1420Medium)
                .foregroundColor(.gray900)
                .padding(.leading, 12)
            
            Spacer()
            
            Image("icon_fill_bookmark")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(element.favorite ? Color(red: 1.0, green: 0.62, blue: 0.62) : Color.gray200)
                .frame(width: 24, height: 24)
                .onTapGesture(perform: {
                    //viewModel.clickFavoriteButton(position: index)
                })
        }
    }
}

struct MainCommunityFavoritPage_Previews: PreviewProvider {
    static var previews: some View {
        MainCommunityFavoritPage()
    }
}
