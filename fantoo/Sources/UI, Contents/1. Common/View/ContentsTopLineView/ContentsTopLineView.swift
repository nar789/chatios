//
//  ContentsTopLineView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ContentsTopLineView: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    Text("")
                }
                .modifier(ScrollViewLazyVStackModifier())
            }
            .background(Color.gray25)
            .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "p_edit_profile".localized, onPress: { buttonType in
            })
            .navigationBarBackground {
                Color.gray25
            }
            .statusBarStyle(style: .darkContent)
        }
    }
}

struct ContentsTopLineView_Previews: PreviewProvider {
    static var previews: some View {
        ContentsTopLineView()
    }
}
