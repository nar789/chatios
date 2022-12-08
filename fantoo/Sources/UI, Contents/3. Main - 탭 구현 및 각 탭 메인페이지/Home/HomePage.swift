//
//  Home.swift
//  fantoo
//
//  Created by mkapps on 2022/04/23.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SwiftUINavigationBarColor

struct HomePage: View {
    
    var tabtype: TabMainType
    var tabs: [TabMain]
    
    /**
     * '둘러보기'로 진입한 경우 : Popular Tab부터 보여주기
     * '둘러보기' 이외 다른 모든 경우 : Home Tab부터 보여주기
     */
    @State private var selectedTab: Int = 0
    @StateObject var userManager = UserManager.shared
    
    init(tabtype: TabMainType, tabs: [TabMain]) {
        self.tabtype = tabtype
        self.tabs = tabs
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                if tabtype == .vOne {
                    TabsV1(tabs: tabs, geoWidth: geometry.size.width, tabtype: tabtype, selectedTab: $selectedTab)
                    
                    // Views
                    TabView(selection: $selectedTab,
                            content: {
                        SubHome()
                            .tag(0)
                        SubPopular()
                            .tag(1)
                    })
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                else if tabtype == .vTwo {
                    TabsV2(tabs: tabs, geoWidth: geometry.size.width, tabtype: tabtype, selectedTab: $selectedTab)
                    
                    // Views
                    TabView(selection: $selectedTab,
                            content: {
                        SubHome()
                            .tag(0)
                        SubPopular()
                            .tag(1)
                        SubCommunity()
                            .tag(2)
                    })
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            /**
             * '둘러보기' 로 진입한 경우 : Popular Tab부터 보여주기
             * '둘러보기' 이외 다른 모든 경우 : Home Tab부터 보여주기
             */
            .onChange(of: userManager.isGuest, perform: { newValue in
                if newValue {
                    self.selectedTab = 1
                } else {
                    self.selectedTab = 0
                }
            })
            .onChange(of: userManager.showInitialViewState) { newValue in
                /**
                 * userManager.showInitialViewState 는 로그아웃 시 바뀜
                 * 로그아웃 후, 바로 '둘러보기'로 Popular 탭에 바로 진입 시, 화이트 스크린 문제 발생 !
                 *
                 * 테스트 결과, Popular 탭이 선택되어 있는 상태에서 다시 Popular 탭으로 바뀌도록 해서(self.selectedTab = 1) 했기 때문이라고 판단했음.
                 *
                 * 그래서 아래와 같이, 로그아웃 한 경우에는 Home 탭으로 바뀌도록 했다가(self.selectedTab = 0),
                 * '둘러보기' 선택한 경우, UserManager.shared.isGuest 값이 바껴 Popular 탭으로 바뀌도록(self.selectedTab = 1) 구현하니까 화이트 스크린 문제 발생 안 함.
                 *
                 */
                self.selectedTab = 0
            }
        }
        //            .navigationType(leftItems: [.Logo], rightItems: [.Present, .Alarm], foregroundColor: .gray25, title: "", onPress: { buttonType in
        //            })
        //            .navigationBarBackground {
        //                Color.primary300.shadow(radius: 0)
        //            }
                    .statusBarStyle(style: .lightContent)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(tabtype: TabMainType.vOne,
              tabs: [
                .init(title: "h_home".localized),
                .init(title: "Popular")
              ])
    }
}
