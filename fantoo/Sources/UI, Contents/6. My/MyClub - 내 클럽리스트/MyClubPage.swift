//
//  MyClubListPage.swift
//  fantoo
//
//  Created by mkapps on 2022/05/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyClubPage {
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
    }
    @StateObject var vm = MyClubViewModel()
    
    @State var clubId: String = ""
    @State var isFavorite: Bool = true
    @State var showDetailClub: Bool = false
    @State var club: [ClubListData] = []
    
    @Binding var size: String
    @State var state: Bool
    
}

extension MyClubPage: View {
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ScrollViewReader { proxyReader in
                    RefreshableScrollView(
                        onRefresh: { done in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                vm.requestMyClubList(nextId: "0", size: "\(DefineSize.ListSize.Common)", sort: "")
                                vm.requestMyClubCount(sort: "")
                                
                                done()
                            }
                        }) {
                            Group {
                                if vm.isLoadingFinish {
                                    VStack(spacing: 0) {
                                        MyClubSortView(
                                            isOn: $isFavorite,
                                            lineYn: isFavorite ? false : true,
                                            myClubFavoriteCount: vm.myClubFavoriteCount,
                                            myClubJoinCount: vm.myClubCount) {
                                            if isFavorite {
                                                vm.requestMyClubCount(sort: "favorite")
                                                
                                            } else {
                                                vm.requestMyClubCount(sort: "")
                                                
                                            }
                                        }
                                        
                                        ZStack {
                                            if isFavorite {
                                                myFavoriteClubListView
                                            } else {
                                                myClubListView
                                            }
                                        }
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .background(
                                GeometryReader { geometry in
                                    Color.clear.onAppear {
                                        let scrollviewHeight = geometry.size.height + DefineSize.SafeArea.top + DefineSize.SafeArea.top
                                        /**
                                         * 계산 후 Bool 값으로 컨트롤
                                         */
                                        if UIScreen.main.bounds.size.height > scrollviewHeight {
                                            vm.isScrollViewShort = true
                                        }
                                    }
                                }
                            )
                        }
                }
            }
        }
        
        //        .onChange(of: UserManager.shared.showInitialViewState) { value in
        //            showNoticeView = false
        //        }
        .onAppear {
            print("@@@@\(isFavorite)")
            vm.requestMyClubList(nextId: "0", size: "\(DefineSize.ListSize.Common)", sort: "")
            vm.requestMyClubCount(sort: "favorite")
        }
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: "", message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
        
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "n_my_club".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
    // 즐겨찾기 클럽
    var myFavoriteClubListView: some View {
        ZStack {
            if vm.checkFavoriteEmpty() {
                noFavoriteClubListView
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(Array(vm.clubListData.enumerated()), id: \.offset) { index, element in
                        if element.favoriteYn {
                            MyClubPage_RowView(
                                index: index,
                                element: element,
                                favoriteYn: element.favoriteYn,
                                viewModel: vm,
                                onPress: {
                                    clubId = "\(element.clubId)"
                                    showDetailClub = true
                                }
                            )
                            .padding(.top, 16)
                            .onChange(of: vm.clubListData) { newValue in
                                if vm.isScrollViewShort {
                                    self.fetchMoreData(element)
                                }
                            }
                            .onAppear {
                                self.fetchMoreData(element)
                            }
                        }
                    }
                    .background(
                        NavigationLink("", isActive: $showDetailClub) {
                            HomeClubPage(clubId: $clubId, state: $isFavorite)
                            
                        }.hidden()
                    )
                }
                .padding(EdgeInsets(top: 4, leading: DefineSize.Contents.HorizontalPadding, bottom: 0, trailing: DefineSize.Contents.HorizontalPadding))
            }
        }
    }
    
    // 가입한 클럽
    var myClubListView: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(vm.clubListData.enumerated()), id: \.offset) { index, element in
                
                MyClubPage_RowView(
                    index: index,
                    element: element,
                    favoriteYn: element.favoriteYn,
                    viewModel: vm,
                    onPress: {
                        clubId = "\(element.clubId)"
                        showDetailClub = true
                    }
                )
                .padding(.top, 16)
                .onChange(of: vm.clubListData) { newValue in
                    
                    if vm.isScrollViewShort {
                        self.fetchMoreData(element)
                    }
                }
                .onAppear {
                    self.fetchMoreData(element)
                }
                
            }
            .background(
                NavigationLink("", isActive: $showDetailClub) {
                    HomeClubPage(clubId: $clubId, state: $state)
                    
                }.hidden()
            )
        }
        .padding(EdgeInsets(top: 4, leading: DefineSize.Contents.HorizontalPadding, bottom: 0, trailing: DefineSize.Contents.HorizontalPadding))
    }
    
    var noFavoriteClubListView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 180)
            
            Image("character_main2")
                .resizable()
                .frame(width: 118, height: 124)
            Text("se_j_no_favorite_club".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray600)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            Text("se_j_add_favorite_community".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray600)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            
            Spacer()
        }
        .padding(.horizontal, 71)
        .padding(.bottom, 100)
    }
}





extension MyClubPage {
    
    fileprivate func fetchMoreData(_ boardList: ClubListData) {
        if self.vm.clubListData.last == boardList {
            print("[마지막]에 도달했다")
            
            guard let nextPage = self.vm.myClubListData?.nextId else {
                print("페이지 정보가 없습니다.")
                return
            }
            
            if nextPage == "-1" {
                // 데이터 없음
            } else {
                print("[마지막]에 들어왔다")
                
                self.vm.fetchMoreActionSubject.send()
                
                //                self.vm.onMorePageLoading()
            }
        }
    }
}



struct MyClubPage_RowView: View {
    
    @State var bookmarkImageToggle = false
    
    let index: Int
    let element: ClubListData
    let favoriteYn: Bool
    var viewModel = MyClubViewModel()
    let onPress: () -> Void
    
    private let isOwner = "a_operate".localized
    
    var body: some View {
        ZStack {
            Button {
                onPress()
            } label: {
                HStack(spacing: 0) {
                    
                    WebImage(url: URL(string: element.profileImg.imageOriginalUrl))
                        .resizable()
                        .placeholder(Image(Define.ProfileDefaultImage))
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
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text(element.clubName)
                                .font(.buttons1420Medium)
                                .foregroundColor(.gray900)
                            
                            if element.manageYn {
                                Text(isOwner)
                                    .font(.caption21116Regular)
                                    .foregroundColor(.gray25)
                                    .padding(.vertical, 1)
                                    .padding(.horizontal, 4)
                                    .background(.primary300)
                                    .clipShape(Capsule())
                                    .padding(.leading, 6)
                            }
                        }
                        
                        HStack(spacing: 0) {
                            Image("icon_outline_member")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(.gray500)
                                .frame(width: 12, height: 12)
                            
                            Text(String(element.memberCount ))
                                .font(.caption11218Regular)
                                .foregroundColor(.gray500)
                                .padding(.leading, 4)
                        }
                        .padding(.top, 1)
                    }
                    .padding(.leading, 12)
                    
                    Spacer()
                    
                    Image("icon_fill_bookmark")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(favoriteYn ? Color(red: 1.0, green: 0.62, blue: 0.62) : Color.gray200)
                        .frame(width: 24, height: 24)
                        .onTapGesture(perform: {
                            viewModel.clickFavoriteButton(position: index)
                            viewModel.requestMyClubFavoritePatch(clubId: "\(element.clubId)")
                        })
                }
            }
        }
    }
}


