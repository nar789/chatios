//
//  CustomTabView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct CustomTabView: View {
    enum CustomTabViewStyle {
        case UnderLine
        case ActiveBackground
    }
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        
        static let underLineHeight: CGFloat = 2.0
        
        static let textHorizontalPadding: CGFloat = 10.0
        static let textVerticalPadding: CGFloat = 3.0
    }
    
    @Binding var currentTab: Int
    let style: CustomTabViewStyle
    let titles: [String]
    let height: CGFloat
    
    @Namespace var namespace
    
    var body: some View {
        ScrollView(.horizontal) {
            ZStack(alignment: .topLeading) {
                Color.bgLightGray50.frame(height: DefineSize.LineHeight)
                    .frame(width: DefineSize.Screen.Width, height: DefineSize.LineHeight, alignment: .bottom)
                    .padding(EdgeInsets(top: height - DefineSize.LineHeight, leading: 0, bottom: 0, trailing: 0))
                
                HStack(spacing: 0) {
                    ForEach(Array(zip(self.titles.indices, self.titles)), id: \.0, content: {
                        index, name in
                        tabView(string: name, tab: index)
                    })
                }
                .background(Color.clear)
                .padding(.horizontal, self.style == .ActiveBackground ? DefineSize.Contents.HorizontalPadding : 0)
            }
        }
        .background(Color.clear)
        .frame(height: height)
    }
    
    func tabView(string: String, tab: Int) -> some View {
        Button {
            self.currentTab = tab
        } label: {
            if style == .UnderLine {
                underLineView(string: string, tab: tab)
            }
            else {
                activeBackgroundView(string: string, tab: tab)
            }
            
        }
        .buttonStyle(.plain)
        .background(Color.clear)
    }
    
    func underLineView(string: String, tab: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.gray25)
                .padding(.bottom, 10)
//                .matchedGeometryEffect(id: "rect", in: namespace)
            
            Text(string)
                .font(Font.buttons1420Medium)
                .foregroundColor(self.currentTab == tab ? Color.primary500 : Color.stateEnableGray900)
            
            if self.currentTab == tab {
                Color.primary500.frame(height: sizeInfo.underLineHeight)
                    .padding(EdgeInsets(top: height - sizeInfo.underLineHeight, leading: DefineSize.Contents.HorizontalPadding, bottom: 0, trailing: DefineSize.Contents.HorizontalPadding))
                    .matchedGeometryEffect(id: "underline", in: namespace)
            }
            else {
                Color.clear.frame(height: sizeInfo.underLineHeight)
            }
        }
        .frame(width: DefineSize.Screen.Width / CGFloat(self.titles.count), height: height)
        .animation(.spring(), value: currentTab)
        .background(Color.clear)
    }
    
    func activeBackgroundView(string: String, tab: Int) -> some View {
        HStack(alignment: .center, spacing: 0) {
            ZStack{
                if currentTab == tab {
                    RoundedRectangle(cornerRadius: (self.height - (sizeInfo.textVerticalPadding * 2)) / 2)
                        .foregroundColor(Color.stateEnablePrimary100)
                        .matchedGeometryEffect(id: "rect", in: namespace)
                }
                else {
                    RoundedRectangle(cornerRadius: (self.height - (sizeInfo.textVerticalPadding * 2)) / 2)
                        .foregroundColor(Color.clear)
                }
                
                Text(string)
                    .font(Font.caption11218Regular)
                    .foregroundColor(self.currentTab == tab ? Color.primary600 : Color.stateActiveGray700)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .fixedSize()
                    .padding(.horizontal, sizeInfo.textHorizontalPadding)
                    .padding(.vertical, sizeInfo.textVerticalPadding)
            }
            .fixedSize()
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .animation(.spring(), value: currentTab)
    }
}
