//
//  WalletBottomView.swift
//  NotificationService
//
//  Created by fns on 2022/10/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct WalletBottomSheet: View {
    @StateObject var languageManager = LanguageManager.shared
    
    var clubOpenTitle = [
        ClubMemberDetailModel(SEQ: 0, subTitle: "j_all".localized),
        ClubMemberDetailModel(SEQ: 1, subTitle: "j_saving".localized),
        ClubMemberDetailModel(SEQ: 2, subTitle: "s_use".localized),
    ]
    
    @State var selectedTitle: String?
    @Binding var isShow: Bool
    let subTitle: String
    @Binding var selectedText: String
    @Binding var selectedSeq: Int
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let topPadding: CGFloat = 20.0
        static let bottomPadding: CGFloat = 50.0
        static let padding32: CGFloat = 32.0
        static let titleBottomPadding: CGFloat = 14.0
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(subTitle)
                    .font(Font.title51622Medium)
                    .foregroundColor(Color.gray870)
                Spacer()
            }.padding(.bottom, sizeInfo.titleBottomPadding)

            Spacer().frame(height: sizeInfo.topPadding)
            ForEach(clubOpenTitle, id: \.SEQ) { subTitle in
                WalletBottomRow(subTitle: subTitle.subTitle, selectedTitle: $selectedTitle, onPress: {
                selectedText = subTitle.subTitle
                selectedSeq = subTitle.SEQ
                isShow = false
                onPress()
            })
            }
                .padding(.bottom, 15)
            Spacer().frame(maxHeight: .infinity)
            //            Spacer().frame(height: sizeInfo.bottomPadding - DefineSize.SafeArea.bottom)
        }
        .padding(.horizontal, sizeInfo.padding32)
    }
}

struct WalletBottomRow: View {
    
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
