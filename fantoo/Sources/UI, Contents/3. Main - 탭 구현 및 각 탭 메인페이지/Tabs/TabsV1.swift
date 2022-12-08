//
//  TabsV1.swift
//  fantoo
//
//  Created by 김홍필 on 2022/04/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import Introspect

struct BackgroundView_first_0: View {
    var geoWidth: CGFloat
    var body: some View {
        Image("slicing_top_tab_first")
            .background(Color.primary300)
    }
}
struct BackgroundView_choice_0: View {
    var geoWidth: CGFloat
    var body: some View {
        Image("slicing_top_tab_choice")
            .background(Color.primary300)
    }
}
struct BackgroundView_bg_0: View {
    var body: some View {
        Image("slicing_top_tab_bg")
            .background(Color.primary300)
    }
}
struct BackgroundView_basic_0: View {
    var currentItemIndex: Int
    var selectedItemIndex: Int
    var tabsSize: Int
    var geoWidth: CGFloat
    
    var body: some View {
        //        print("[tab_test] currentItemIndex : \(currentItemIndex)")
        //        print("[tab_test] selectedItemIndex : \(selectedItemIndex)")
        
        if currentItemIndex == selectedItemIndex {
            if currentItemIndex == 0 {
                return AnyView(BackgroundView_first_0(geoWidth: geoWidth))
            }
            else {
                return AnyView(BackgroundView_choice_0(geoWidth: geoWidth))
            }
        }
        /**
         * 아래 else 문 View : opacity 0.0 으로 줬기 때문에 투명한 View이다.
         * 아래 else 문 넣은 이유 : 넣지 않으면 탭 클릭시 깜빡이는 문제가 있음. 원인 분석해볼 것.
         */
        else {
            return AnyView(
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.0))
            )
        }
    }
}

struct TabsV1: View {
    let tabHeight: CGFloat = 62 // 위쪽 그림자 영역까지 포함해서 62
    var tabs: [TabMain]
    var geoWidth: CGFloat
    var tabtype: TabMainType
    @Binding var selectedTab: Int
    
    var selectedText : (Int, Int) -> Color = { currentItemIndex, selectedItemIndex in
        if currentItemIndex == selectedItemIndex {
            return Color.primary500
        } else {
            return Color.gray25
        }
    }
    
    var selectedTextWidth : (CGFloat, Int) -> CGFloat = { geoWidth, selectedItemIndex in
        if selectedItemIndex == 0 {
            return geoWidth / CGFloat(3.5)
        }
        else {
            return geoWidth / CGFloat(2.5)
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: 0) {
                    ForEach(0 ..< tabs.count, id: \.self) { row in
                        Button(action: {
                            withAnimation {
                                selectedTab = row
                            }
                        }, label: {
                            Text(tabs[row].title)
                                .font(.title5Roboto1622Medium)
                                .foregroundColor(selectedText(row, selectedTab))
                        })
                        .frame(width: selectedTextWidth(geoWidth, row), height: tabHeight)
                        .background(BackgroundView_basic_0(currentItemIndex: row, selectedItemIndex: selectedTab, tabsSize: tabs.count, geoWidth: selectedTextWidth(geoWidth, row)))
                    }
                }
                .onChange(of: selectedTab) { target in
                    withAnimation {
                        proxy.scrollTo(target)
                    }
                }
            }
        }
        .background(BackgroundView_bg_0())
        /**
         * 문제 :
         * 기본 ScrollView 설정에서는 좌우로  드래그하면 같이 움직이는 문제가 있음. (상단 Tab 메뉴는 고정되어야 함)
         *
         * 해결 :
         * 'UIKit 코드를 사용할 수 있도록 해주는 SwiftUI-Introspect 라이브러리'를 사용해서 수직-수평 모두 고정시켰음
         *
         * 메모 :
         * 아래 주석처리한 것처럼 UIScrollView.appearance().bounces = false 를 적용해도 Tab 메뉴가 고정되긴 하는데,
         * 문제는 Tab 메뉴 안의 다른 ScrollView 도 고정되서 PullToRefresh 기능 적용시 문제가 생겼다.
         * 물론 Tab 메뉴 안의 다른 ScrollView 에도 UIScrollView.appearance().bounces = true 를 적용하면 움직이긴 하지만
         * 다른 메뉴 이동 후 다시 오면 다시 고정되는 등의 다른 문제가 있었음.
         * 그래서 SwiftUI-Introspect 라이브러리를 사용해서 해결함 !
         */
        .introspectScrollView { scrollView in
            scrollView.alwaysBounceVertical = false
            scrollView.alwaysBounceHorizontal = false
        }
        //        .onAppear(perform: {
        //            UIScrollView.appearance().bounces = false
        //        })
        //        .onDisappear(perform: {
        //            UIScrollView.appearance().bounces = false
        //        })
    }
}

struct TabsV1_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabsV1(tabs: [.init(title: "Tab 1"),
                          .init(title: "Tab 2")],
                   geoWidth: 375,
                   tabtype: TabMainType.vOne,
                   selectedTab: .constant(0))
        }
    }
}
