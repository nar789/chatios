//
//  FantooTvTabBar.swift
//  fantoo
//
//  Created by fns on 2022/08/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubMemberDetailTabBar: View {
    var fixed = false
    var tabs: [String]
    var geoWidth: CGFloat
    @Binding var selectedTab: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count, id: \.self) { row in
                            
                            Button(action: {
                                withAnimation {
                                    selectedTab = row
                                }
                            }, label: {
                                VStack(spacing: 0) {
                                    Spacer()
                                    Text(tabs[row])
                                        .font(.buttons1420Medium)
                                        .foregroundColor(selectedTab == row ? Color.primary500 : Color.gray400)
                                        .frame(width: fixed ? (geoWidth / CGFloat(tabs.count) + 40) : .none)
                                    Spacer()
                                    
                                    // Bar Indicator
                                    // 글자의 width 값 구하기
                                    let stringWidth: CGFloat = tabs[row].widthOfString(usingFont: .buttons1420Medium)
                                    
                                    if selectedTab == row {
                                        Color
                                            .primary500
                                            .frame(width: stringWidth + 40, height: 1.9)
                                    }
                                    
                                    // Divider
                                    Rectangle().fill(Color.primary600.opacity(0.12))
                                        .frame(height: 1.0)
                                }
                            })
                                .frame(width: (geoWidth / CGFloat(tabs.count)))
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
        }
        .background(
            RoundedCornersShape(
                corners: [.topLeft, .topRight],
                radius: 24
            )
                .fill(Color.gray25)
        )
        .onAppear(perform: {
            //UIScrollView.appearance().backgroundColor = UIColor(Color.blue)
            UIScrollView.appearance().bounces = fixed ? false : true
        })
        .onDisappear(perform: {
            UIScrollView.appearance().bounces = true
        })
    }
}
