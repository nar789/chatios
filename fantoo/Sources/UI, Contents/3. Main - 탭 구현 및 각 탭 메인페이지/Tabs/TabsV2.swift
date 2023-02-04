//
//  Tabs.swift
//  fantoo
//
//  Created by 김홍필 on 2022/04/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import Introspect

struct BackgroundView_first: View {
    var geoWidth: CGFloat
    var body: some View {
        Image("slicing_top_tab_first")
            .background(Color.primary300)
    }
}
struct BackgroundView_choice: View {
    var geoWidth: CGFloat
    var body: some View {
        Image("slicing_top_tab_choice")
            .background(Color.primary300)
    }
}
struct BackgroundView_last: View {
    var geoWidth: CGFloat
    var body: some View {
        Image("slicing_top_tab_last")
            .background(Color.primary300)
    }
}
struct BackgroundView_bg: View {
    var body: some View {
        Image("slicing_top_tab_bg")
            .background(Color.primary300)
    }
}
struct BackgroundView_basic: View {
    var currentItemIndex: Int
    var selectedItemIndex: Int
    var tabsSize: Int
    var geoWidth: CGFloat
    
    var body: some View {
//        print("[tab_test] currentItemIndex : \(currentItemIndex)")
//        print("[tab_test] selectedItemIndex : \(selectedItemIndex)")
        
        // 선택된 탭
        if currentItemIndex == selectedItemIndex {
            if currentItemIndex == 0 {
                return AnyView(BackgroundView_first(geoWidth: geoWidth))
            }
            else if currentItemIndex+1 == tabsSize {
                return AnyView(BackgroundView_last(geoWidth: geoWidth))
            }
            else {
                return AnyView(BackgroundView_choice(geoWidth: geoWidth))
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

struct TabsV2: View {
    let tabHeight: CGFloat = 62
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

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
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
                                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                        })
                        .frame(width: (geoWidth / CGFloat(tabs.count)), height: tabHeight)
                        .background(BackgroundView_basic(currentItemIndex: row, selectedItemIndex: selectedTab, tabsSize: tabs.count, geoWidth: geoWidth))
                        .fixedSize()
                        .accentColor(Color.gray25)
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .onChange(of: selectedTab) { target in
                    withAnimation {
                        proxy.scrollTo(target)
                    }
                }
            }
        }
        .background(BackgroundView_bg())
        .introspectScrollView { scrollView in
            scrollView.alwaysBounceVertical = false
            scrollView.alwaysBounceHorizontal = false
        }
    }
}

struct TabsV2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabsV2(tabs: [.init(title: "Tab 1"),
                        .init(title: "Tab 2"),
                        .init(title: "Tab 3")],
                 geoWidth: 375,
                   tabtype: TabMainType.vTwo,
                 selectedTab: .constant(0))
        }
    }
}
