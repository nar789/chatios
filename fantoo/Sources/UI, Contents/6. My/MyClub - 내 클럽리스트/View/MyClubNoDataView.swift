//
//  MyCloubNoDataView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct MyClubNoDataView: View {
    
    private struct sizeInfo {
        static let bottomPadding: CGFloat = 50.0
        static let padding5: CGFloat = 5.0
        
        static let textPadding: CGFloat = 71.0
        static let imageSize: CGSize = CGSize(width: 118, height: 124)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(spacing: 0) {
                
                Image("character_main2")
                    .resizable()
                    .frame(width: sizeInfo.imageSize.width, height: sizeInfo.imageSize.height, alignment: .center)
                
                Text("se_j_no_favorite_club".localized)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray600)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, sizeInfo.textPadding)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: sizeInfo.padding5)
                
                Text("se_j_add_favorite_club".localized)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray600)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, sizeInfo.textPadding)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: sizeInfo.bottomPadding)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

