//
//  View+Modifier.swift
//  fantoo
//
//  Created by mkapps on 2022/05/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ListInsetGroupedModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.gray100, radius: 2, x: 0, y: 2)
            .listStyle(.insetGrouped)
            .background(Color.bgLightGray50)
    }
}

struct CornerRadiusListModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.gray25.cornerRadius(15))
            .shadow(color: Color.gray100, radius: 2, x: 0, y: 2)
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
    }
}

struct ScrollViewLazyVStackModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.top, DefineSize.Contents.TopPadding)
            .padding(.bottom, DefineSize.Contents.BottomPadding)
    }
}

struct ScrollViewLazyVStackModifierBottom: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.bottom, DefineSize.Contents.BottomPadding)
    }
}

struct ListRowModifier: ViewModifier {
    let rowHeight:CGFloat
    func body(content: Content) -> some View {
        content
//            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .frame(maxWidth: .infinity)
            .frame(height: rowHeight)
    }
}
