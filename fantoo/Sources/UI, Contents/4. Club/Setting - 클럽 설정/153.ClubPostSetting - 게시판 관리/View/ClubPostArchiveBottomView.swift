//
//  ClubPostArchiveBottomView.swift
//  fantoo
//
//  Created by fns on 2022/07/20.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//


import SwiftUI
import CombineMoya
import XCTest

struct ClubPostArchiveBottomView: View {
    @StateObject var languageManager = LanguageManager.shared
    
    var PostVisibilityTitle = [
        subTitleDescription(SEQ: 0, subTitle: "g_open_public".localized, subDescription: "se_b_can_see_non_join".localized),
        subTitleDescription(SEQ: 1, subTitle: "b_hidden".localized, subDescription: "se_g_visible_post".localized)
    ]
    var ArchiveTypeTitle = [
        subTitleDescription(SEQ: 2, subTitle: "a_image".localized, subDescription: "".localized),
        subTitleDescription(SEQ: 1, subTitle: "a_general".localized, subDescription: "d_move_weblink_text".localized)
    ]
    
    let title: String
    let type: ClubPostArchiveBottomType
    @Binding var selectedTitle: String
    @Binding var selectedNum: Int
    @Binding var isShow: Bool
    let onPress: () -> Void
    
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
            
            if type == .PostVisibilitySetting {
                ForEach(PostVisibilityTitle, id: \.SEQ) { subTitle in
                    ClubPostArchiveBottomRow(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedTitle, onPress: {
                        selectedTitle = subTitle.subTitle
                        selectedNum = subTitle.SEQ
                        isShow = false
                        onPress()
                    })
                }
            }
            else if type == .ArchiveType {
                ForEach(ArchiveTypeTitle, id: \.SEQ) { subTitle in
                    ClubPostArchiveBottomRow(subTitle: subTitle.subTitle, subDescription: subTitle.subDescription, selectedTitle: $selectedTitle, onPress: {
                        selectedNum = subTitle.SEQ
                        isShow = false
                        onPress()
                    })
                }
            }
            Spacer().frame(maxHeight: .infinity)
        }
        .padding(.horizontal, sizeInfo.padding)
    }
}

struct ClubPostArchiveBottomRow: View {
    
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
