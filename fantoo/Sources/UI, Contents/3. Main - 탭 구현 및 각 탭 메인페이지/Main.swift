//
//  Main.swift
//  fantoo
//
//  Created by 김홍필 on 2022/04/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct Main {
    /**
     * Main Tab 결정하는 부분
     */
    // Version 1
    var tabtype_1: TabMainType = .vOne
    let tabs_1: [TabMain] = [
        .init(title: "en_home".localized),
        .init(title: "en_popular".localized)
    ]
    
    // Version 2
    var tabtype_2: TabMainType = .vTwo
    let tabs_2: [TabMain] = [
        .init(title: "en_home".localized),
        .init(title: "en_popular".localized),
        .init(title: "en_community".localized)
    ]
    
    @State private var selection: bTab = .menu
    @State private var homeTabImage: String = "icon_outline_home_n"
    @State private var communityTabImage: String = "icon_outline_community"
    @State private var clubTabImage: String = "icon_outline_club"
    @State private var chatTabImage: String = "icon_outline_chats_n"
    
    enum bTab {
        case menu
        case home
        case community
        case club
        case chat
    }
    
    /**
     * 최초 화면 로딩시, TabView 의 .onChange 함수가 호출되지 않기 때문에,
     * 최초 보이는 '메뉴 탭' 설정으로 해줘야 됨
     */
    @State var leftItems: [CustomNavigationBarButtonType] = []
    @State var rightItems: [CustomNavigationBarButtonType] = [.Setting]
    @State var foregroundColor: Color = .black
    @State var title: String = ""
    @State var navigationBarColor: Color = .bgLightGray50
    @State var uiStatusBarStyle: UIStatusBarStyle = .darkContent
    
    //push
    @State private var showSettingPage = false
    @State private var showCommunitySearchPage = false
    @State private var showCommunityMyPage = false
    @State private var showClubSearchPage = false
    @State private var showClubNewClubPage = false
    @State private var showClubProfilePage = false
    @State private var showEventPage = false
    @State private var showAlertPage = false
    @State private var showChatPage = false
    @State private var goBackMainClub = false
    @State private var showChatPickerPage = false
    @State private var showChatComposerPage = false
    @State private var showChatPopupOverlay = false
    
    
    @StateObject var userManager = UserManager.shared
    
    @State private var isFirstLoaded: Bool = true
    
    /**
     * 언어팩 등록할 것
     */
    private let chatPageTitle = "채팅"
}

extension Main: View {
    
    var body: some View {
        NavigationView {
       
            mainNavigationView
               
        }
        .overlay {
            if showChatPopupOverlay {
                Rectangle().frame(maxWidth:.infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.all)
                    .foregroundColor(Color(red:0,green:0, blue:0))
                    .opacity(0.5)
            }
        }
        .onChange(
            of: goBackMainClub,
            perform: { value in
                if value {
                    showClubProfilePage = true
                }
            })
        .onChange(of: userManager.showInitialViewState) { value in
            showSettingPage = false
            showCommunitySearchPage = false
            showCommunityMyPage = false
            showClubSearchPage = false
            showClubNewClubPage = false
            showClubProfilePage = false
            showEventPage = false
            showAlertPage = false
            showChatPickerPage = false
            showChatComposerPage = false
            showChatPopupOverlay = false
            
            selection = .home
        }
    }
    
    var mainNavigationView : some View {
        mainTabView
        .background {
            NavigationLink("", isActive: $showSettingPage) {
                SettingPage()
            }.hidden()
            
            NavigationLink("", isActive: $showCommunitySearchPage) {
                MainCommunitySearchPage()
            }.hidden()
            
            NavigationLink("", isActive: $showClubSearchPage) {
                MainClubSearchPage()
            }.hidden()
            
            NavigationLink("", isActive: $showCommunityMyPage) {
                MainCommunityMyPage()
            }.hidden()
            
            NavigationLink("", isActive: $showClubNewClubPage) {
                MainClubNewClubPage(goBackMainClub: $goBackMainClub)
            }.hidden()
            
            NavigationLink("", isActive: $showClubProfilePage) {
                HomeClubPage(clubId: .constant(""), state: .constant(false))
            }.hidden()
            
            NavigationLink("", isActive: $showEventPage) {
                EventPage()
            }.hidden()
            
            NavigationLink("", isActive: $showAlertPage) {
                AlertPage()
            }.hidden()
            
            NavigationLink("", isActive: $showChatPickerPage) {
                ChatPickerPage(showChatComposerPage:$showChatComposerPage)
            }.hidden()
            
            NavigationLink("", isActive: $showChatComposerPage) {
                ChatComposerPage(showChatComposerPage: $showChatComposerPage, showPopup: $showChatPopupOverlay)
            }.hidden()
        }
    }
    
    var mainTabView : some View {
        TabView(selection: $selection) {
            
            HomePage(tabtype: tabtype_1, tabs: tabs_1)
                .tabItem {
                    Image(homeTabImage).renderingMode(.template)
                    Text("h_home".localized)
                }
                .tag(bTab.home)
            
            MainCommunityPage()
                .tabItem {
                    Image(communityTabImage).renderingMode(.template)
                    Text("k_community".localized)
                }
                .tag(bTab.community)
            
            MainClubPage()
                .tabItem {
                    Image(clubTabImage).renderingMode(.template)
                    Text("k_club".localized)
                }
                .tag(bTab.club)
            
            ChatPage(showChatComposerPage: $showChatComposerPage)
                .tabItem {
                    Image(chatTabImage).renderingMode(.template)
                    Text(chatPageTitle)
                }
                .tag(bTab.chat)
            
            MenuPage()
                .tabItem {
                    Image("icon_outline_hamburger")
                        .renderingMode(.template)
                    Text("m_menu".localized)
                }
                .tag(bTab.menu)
        }
        .onAppear(perform: {
            
            if isFirstLoaded {
                isFirstLoaded = false
                selection = .home
                ChatSocketManager.shared.checkAndConnect()
            }
        })
        .onChange(of: selection, perform: { newValue in
            if newValue == .menu {
                leftItems = []
                rightItems = [.Setting]
                foregroundColor = .black
                title = ""
                navigationBarColor = .bgLightGray50
                uiStatusBarStyle = .darkContent
                
                // set bottomTab's item
                homeTabImage = "icon_outline_home_n"
                communityTabImage = "icon_outline_community"
                clubTabImage = "icon_outline_club"
                chatTabImage = "icon_outline_chats_n"
            }
            else if newValue == .home {
                leftItems = [.Logo]
                rightItems = [.Present, .AlarmOn]
                foregroundColor = .gray25
                title = ""
                navigationBarColor = .primary300
                uiStatusBarStyle = .lightContent
                
                // set bottomTab's item
                homeTabImage = "icon_fill_home_t"
                communityTabImage = "icon_outline_community"
                clubTabImage = "icon_outline_club"
                chatTabImage = "icon_outline_chats_n"
            }
            else if newValue == .community {
                leftItems = []
                rightItems = [.Search, .Profile]
                foregroundColor = .black
                title = "k_community".localized
                navigationBarColor = .bgLightGray50
                uiStatusBarStyle = .darkContent
                
                // set bottomTab's item
                homeTabImage = "icon_outline_home_n"
                communityTabImage = "icon_fill_community"
                clubTabImage = "icon_outline_club"
                chatTabImage = "icon_outline_chats_n"
            }
            else if newValue == .chat {
                leftItems = []
                rightItems = [.Plus]
                foregroundColor = .black
                title = chatPageTitle
                navigationBarColor = .bgLightGray50
                uiStatusBarStyle = .darkContent
                
                // set bottomTab's item
                homeTabImage = "icon_outline_home_n"
                communityTabImage = "icon_outline_community"
                clubTabImage = "icon_outline_club"
                chatTabImage = "icon_fill_chats_t"
            }
            else {
                leftItems = []
                rightItems = [.Plus, .Search]
                foregroundColor = .black
                title = "k_club".localized
                navigationBarColor = .bgLightGray50
                uiStatusBarStyle = .darkContent
                
                // set bottomTab's item
                homeTabImage = "icon_outline_home_n"
                communityTabImage = "icon_outline_community"
                clubTabImage = "icon_fill_club"
                chatTabImage = "icon_outline_chats_n"
            }
        })
        .foregroundColor(Color.stateEnableGray900)
        .accentColor(Color.primary500)
        .font(.caption21116Regular)
        .navigationType(
            leftItems: leftItems,
            rightItems: rightItems,
            leftItemsForegroundColor: foregroundColor,
            rightItemsForegroundColor: foregroundColor,
            title: title,
            onPress: { buttonType in
                if buttonType == .Setting {
                    
                    //MoreManager.shared.show.bottomSheet = true
                    if userManager.isLogin {
                        showSettingPage = true
                    }
                }
                else if buttonType == .Search {
                    if title == "k_community".localized {
                        showCommunitySearchPage = true
                    } else if title == "k_club".localized {
                        showClubSearchPage = true
                    }
                }
                else if buttonType == .Profile && title == "k_community".localized {
                    showCommunityMyPage = true
                }
                else if buttonType == .Plus && title == chatPageTitle {
                    showChatPickerPage = true
                }
                else if buttonType == .Plus {
                    showClubNewClubPage = true
                }
                else if buttonType == .Present {
                    showEventPage = true
                }
                else if buttonType == .AlarmOn {
                    showAlertPage = true
                }
            })
        .navigationBarBackground {
            navigationBarColor.shadow(radius: 0)
            //Color.bgLightGray50.shadow(radius: 0)
        }
//            .statusBarStyle(style: uiStatusBarStyle)
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
