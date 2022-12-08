//
//  MenuPage.swift
//  fantoo
//
//  Created by 김홍필 on 2022/05/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SwiftUINavigationBarColor

struct MenuPage: View {
    
    @StateObject var userManager = UserManager.shared
    @StateObject var languageManager = LanguageManager.shared
    
    @StateObject var vm = MenuViewModel()
    
    //show
    @State private var showImageViewerPage = false
    @State private var showEditProfilePage = false
    
    @State private var showMyStoragePage = false
    
    @State private var showMyClubPage = false
    @State private var showMyWalletPage = false
    @State private var showInviteFriendPage = false
    
    @State private var showEventPage = false
    @State private var showFantooTvPage = false
    @State private var showHanryuTimesPage = false
    
    @State private var showPageClubSearchKeywordSetting = false

    
    @State private var settingTab: Int = 0
    
    //프로필 완성 6단계
    let completeStepValue = 6
    
    private struct sizeInfo {
        static let listSpacing: CGFloat = 12.0
    }
    
    var body: some View {
        ZStack {
            ScrollView() {
                LazyVStack(spacing: 0) {
                    
                    
                    /* -------------------------------------------------------------------------
                     Login or profile
                     ------------------------------------------------------------------------- */
                    if userManager.isLogin {
                        Button {
                            showEditProfilePage = true
                        } label: {
                            MenuProfileView(profileUrl: vm.profileUrl, nickName: vm.nickName)
                        }
                        .modifier(CornerRadiusListModifier())
                        .background(
                            NavigationLink("", isActive: $showEditProfilePage) {
                                EditProfilePage(profileUrl: $vm.profileUrl, nickName: $vm.nickName, interests: $vm.interests, countryCode: $vm.countryCode, gender: $vm.gender, birthDay: $vm.birthDay)
                            }.hidden()
                        )
                    }
                    else {
                        MenuLoginLinkView(text: "\("r_login".localized) / \("h_join".localized)") {
                            UserManager.shared.showLoginView = true
                        }
                        .modifier(CornerRadiusListModifier())
                    }
                    
                    
                    Spacer()
                        .frame(height: sizeInfo.listSpacing)
                    
                    
                    /* -------------------------------------------------------------------------
                     작성글, 작성댓글, 저장
                     ------------------------------------------------------------------------- */
                    MenuInfoView(myPostCount: vm.myPostCount, myCommentCount: vm.myCommentCount, savedPostCount: vm.savedPostCount, onPress: { buttonType in
                        print("buttonType : \(buttonType)")
                        if buttonType == .MyPost {
                            settingTab = 0
                        }
                        else if buttonType == .MyComment {
                            settingTab = 1
                        }
                        else if buttonType == .SavedPost {
                            settingTab = 2
                        }
                        showMyStoragePage = true
                    })
                        .modifier(CornerRadiusListModifier())
                        .background(
                            NavigationLink("", isActive: $showMyStoragePage) {
                                MyStoragePage(settingTab: $settingTab)
                            }.hidden()
                        )
                    
                    Spacer()
                        .frame(height: sizeInfo.listSpacing)
                    
                    
                    /* -------------------------------------------------------------------------
                     프로필 완성하기
                     ------------------------------------------------------------------------- */
                    if vm.stepValue < completeStepValue {
                        MenuMakeProfileView(stepValue: vm.stepValue) {
                            showEditProfilePage = true
                        }
                        .modifier(CornerRadiusListModifier())
                        .background(
                            NavigationLink("", isActive: $showEditProfilePage) {
                                //EditProfilePage()
                            }.hidden()
                        )
                        
                        Spacer()
                            .frame(height: sizeInfo.listSpacing)
                    }
                    
                    
                    /* -------------------------------------------------------------------------
                     내 클럽, 내 지갑, 친구 초대
                     ------------------------------------------------------------------------- */
                    VStack(spacing: 0) {
                        
                        MenuLinkView(text: "n_my_club".localized, position: .Top, showLine: true, onPress: {
                            showMyClubPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showMyClubPage) {
//                                    MyClubPage_test(
//                                        code: "K-POP",
//                                        naviTitle: "내 클럽"
//                                    )
                                    MyClubPage(size: .constant("20"), state: true)
                                }.hidden()
                            )
                        
                        MenuLinkView(text: "n_my_wallet".localized, position: .Top, showLine: true, onPress: {
                            showMyWalletPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showMyWalletPage) {
                                    WalletPage()
                                }.hidden()
                            )
                        
                        MenuLinkView(text: "c_invite_friend".localized, position: .Top, showLine: false, onPress: {
                            showInviteFriendPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showInviteFriendPage) {
                                    InviteFriendPage()
                                }.hidden()
                            )
                    }
                    .modifier(CornerRadiusListModifier())
                    
                    
                    
                    /* -------------------------------------------------------------------------
                     컨텐츠 : 이벤트, 팬투 TV, 한류타임스
                     ------------------------------------------------------------------------- */
                    Text("k_contents".localized)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray800)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: sizeInfo.listSpacing + 5, leading: DefineSize.Contents.HorizontalPadding + 10, bottom: sizeInfo.listSpacing, trailing: 0))
                    
                    VStack(spacing: 0) {
                        MenuLinkView(text: "a_event".localized, position: .Top, showLine: true, onPress: {
                            showEventPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showEventPage) {
                                    EventPage()
                                }.hidden()
                            )
                        
                        MenuLinkView(text: "p_fantoo_tv".localized, position: .Top, showLine: true, onPress: {
                            showFantooTvPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showFantooTvPage) {
                                    FantooTvPage()
                                }.hidden()
                            )
                        
                        MenuLinkView(text: "h_hanryutimes".localized, position: .Top, showLine: false, onPress: {
                            showHanryuTimesPage = true
                        })
                            .background(
                                NavigationLink("", isActive: $showHanryuTimesPage) {
                                    HanryutimesPage()
                                }.hidden()
                            )
                    }
                    .modifier(CornerRadiusListModifier())
                    
                    Spacer()
                        .frame(height: sizeInfo.listSpacing)
                }
                .modifier(ScrollViewLazyVStackModifier())
            }
            .background(Color.bgLightGray50)
            
            LoadingViewInPage(loadingStatus: $vm.loadingStatus)
        }
        .onAppear(perform: {
            if userManager.isLogin {
                vm.requestUserInfo()
                vm.requestUserMenuStorage()
            }
            else {
                vm.reset()
            }
        })
        .onChange(of: userManager.showInitialViewState) { value in
        }
        .onChange(of: userManager.isLogin) { value in
            if userManager.isLogin {
                vm.requestUserInfo()
            }
            else {
                vm.reset()
            }
        }
        .statusBarStyle(style: .darkContent)
    }
}

struct MenuPage_Previews: PreviewProvider {
    static var previews: some View {
        MenuPage()
    }
}
