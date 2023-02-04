//
//  EditProfileGenderView.swift
//  fantoo
//
//  Created by fns on 2022/06/10.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct EditProfileGenderView: View {

    var cellList = [
        subTitleDescription(SEQ: 1, subTitle: "n_man".localized, subDescription: "male"),
        subTitleDescription(SEQ: 2, subTitle: "a_woman".localized, subDescription: "female")
    ]
    
    @Binding var isShow: Bool
    let selectedGender: String
    let onPress: (String) -> Void
    
    private struct sizeInfo {
        static let titleBottomPadding: CGFloat = 14.0
        static let padding: CGFloat = 32.0
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("s_gender".localized)
                    .font(Font.title51622Medium)
                    .foregroundColor(Color.gray870)
                
                Spacer()
            }
            .padding(.bottom, sizeInfo.titleBottomPadding)
            
            ForEach(cellList, id: \.SEQ) { desc in
                GenderSelectionCell(subDesc: desc, selectedGender: self.selectedGender) { value in
                    isShow = false
                    onPress(value)
                }
            }
            
            Spacer()
                .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, sizeInfo.padding)
        
    }
}

struct GenderSelectionCell: View {
    
    let subDesc: subTitleDescription
    let selectedGender: String
    let onPress: (String) -> Void
    
    private struct sizeInfo {
        static let subTitleHeight: CGFloat = 80.0
        static let bottomPadding: CGFloat = 14.0
        static let iconSize: CGSize = CGSize(width: 24, height: 24)
    }
    
    var body: some View {
        
        HStack {
            Button {
                onPress(subDesc.subDescription)
            } label: {
                Text(subDesc.subTitle)
                    .font(Font.body11622Regular)
                    .foregroundColor(subDesc.subDescription == selectedGender ? Color.primaryDefault : Color.gray800)
                    .frame(width: sizeInfo.subTitleHeight, alignment: .leading)
                
                Spacer()
                
                Image(systemName: "checkmark")
                    .foregroundColor(Color.primary300)
                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                    .opacity(subDesc.subDescription == selectedGender ? 1 : 0)
            }
        }
        .padding(.bottom, sizeInfo.bottomPadding)
    }
}
