//
//  CountTopView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct CountDisplayView: View {
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let padding15: CGFloat = 15.0
        static let cellHeight: CGFloat = 50.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    @Binding var count: Int
    var height: CGFloat = 50.0
    
    var body: some View {
        VStack(spacing: 0) {
//            Divider()
//                .frame(height: DefineSize.LineHeight)
//                .frame(maxWidth: .infinity)
            Group {
                Text("j_all".localized)
                    .font(Font.title51622Medium)
                    .foregroundColor(Color.stateEnableGray900)
                + Text(" ")
                + Text(String(count))
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray500)
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            .frame(height: height - (DefineSize.LineHeight * 2))
            .frame(maxWidth: .infinity, alignment: .leading)
            
//            Divider()
//                .frame(height: DefineSize.LineHeight)
//                .frame(maxWidth: .infinity)
        }
    }
}

struct CountDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        CountDisplayView(count: .constant(30))
    }
}
