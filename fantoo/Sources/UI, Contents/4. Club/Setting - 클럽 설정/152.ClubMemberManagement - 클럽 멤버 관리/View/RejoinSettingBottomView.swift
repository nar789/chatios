//
//  RejoinSettingBottomView.swift
//  fantoo
//
//  Created by fns on 2022/11/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct RejoinSettingBottomView: View {
    
    var clubOpenTitle = [
        BottomTitleDescription(SEQ: 0, subTitle: "g_prohibition".localized, subDescription: "se_h_cannot_rejoin_this_id".localized),
        BottomTitleDescription(SEQ: 1, subTitle: "h_allow".localized, subDescription: "se_h_cannot_rejoin_this_id".localized)
    ]
    
    let title: String
    @State var selectedTitle: String
    @State var SEQ: Int = 0
    @Binding var isShow: Bool
    let onPress: (Int) -> Void
    
    private struct sizeInfo {
        static let titleBottomPadding: CGFloat = 14.0
        static let padding: CGFloat = 32.0
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(Font.title51622Medium)
                    .foregroundColor(Color.gray870)
                Spacer()
            }.padding(.bottom, sizeInfo.titleBottomPadding)
            
            ForEach(clubOpenTitle, id: \.SEQ) { subTitle in
                RejoinSettingBottomRow(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedTitle, onPress: {
                    if subTitle.subTitle == "g_prohibition".localized {
                        selectedTitle = "j_no_rejoin".localized
                    } else {
                        selectedTitle =  "j_allow_rejoin".localized
                    }
//
//                    if subTitle.SEQ == 0 {
//                        selectedTitle = "j_no_rejoin".localized
//                    } else {
//                        selectedTitle =  "j_allow_rejoin".localized
//                    }
                    
                    selectedTitle = subTitle.subTitle
                    SEQ = subTitle.SEQ
                    onPress(SEQ)
                    isShow = false
                })
            }
            
            Spacer().frame(maxHeight: .infinity)
        }
        .padding(.horizontal, sizeInfo.padding)
    }
}

struct RejoinSettingBottomRow: View {
    
    let subTitle: String
    let subDescription: String
    @Binding var selectedTitle: String
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let subTitleHeight: CGFloat = 80.0
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
                    .font(Font.title51622Medium)
                    .foregroundColor(subTitle == selectedTitle ? Color.primaryDefault : Color.gray800)
                    .frame(width: sizeInfo.subTitleHeight, alignment: .leading)
                Spacer()
                Text(subDescription)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(Color.primary300)
                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                    .opacity( subTitle == selectedTitle ? 1 : 0)
            }
        }
        .padding(.bottom, sizeInfo.bottomPadding)
    }
}
