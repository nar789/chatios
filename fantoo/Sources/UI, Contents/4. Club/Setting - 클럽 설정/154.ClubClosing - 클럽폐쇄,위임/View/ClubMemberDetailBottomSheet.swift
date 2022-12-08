//
//  ClubMemberDetailBottomSheet.swift
//  fantoo
//
//  Created by fns on 2022/07/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ClubMemberDetailBottomSheet: View {
    @StateObject var languageManager = LanguageManager.shared
    
    var clubOpenTitle = [
        ClubMemberDetailModel(SEQ: 1, subTitle: "계정 차단".localized),
    ]
    
    @State var selectedTitle: String?
    @Binding var isShow: Bool
    let subTitle: String
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let topPadding: CGFloat = 20.0
        static let bottomPadding: CGFloat = 50.0
        static let padding32: CGFloat = 32.0
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: sizeInfo.topPadding)
            ClubMemberDetailBottomRow(subTitle: subTitle, selectedTitle: $selectedTitle, onPress: {
                isShow = false
                onPress()
            })
                .padding(.bottom, 15)
            Spacer().frame(maxHeight: .infinity)
            //            Spacer().frame(height: sizeInfo.bottomPadding - DefineSize.SafeArea.bottom)
        }
        .padding(.horizontal, sizeInfo.padding32)
    }
}

struct ClubMemberDetailBottomRow: View {
    
    let subTitle: String
    @Binding var selectedTitle: String?
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let subTitleHeight: CGFloat = 50.0
        static let bottomPadding: CGFloat = 14.0
        static let iconSize: CGSize = CGSize(width: 24, height: 24)
    }
    
    var body: some View {
        
        HStack {
            Button {
                self.selectedTitle = self.subTitle
                onPress()
                print("title\(subTitle)")
            } label: {
                Text(subTitle)
                    .font(Font.body11622Regular)
                    .foregroundColor(subTitle == selectedTitle ? Color.primary500 : Color.gray800)
                
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(Color.primary500)
                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                    .opacity( subTitle == selectedTitle ? 1 : 0)
            }
        }
    }
}
