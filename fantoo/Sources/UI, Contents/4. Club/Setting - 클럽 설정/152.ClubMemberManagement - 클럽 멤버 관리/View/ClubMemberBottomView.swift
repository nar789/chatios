//
//  ClubMemberBottomView.swift
//  fantoo
//
//  Created by fns on 2022/08/30.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ClubMemberBottomView: View {
    @StateObject var languageManager = LanguageManager.shared
    
    var clubOpenTitle = [
        ClubMemberDetailModel(SEQ: 1, subTitle: "a_to_delegate".localized),
        ClubMemberDetailModel(SEQ: 2, subTitle: "g_force_leave".localized)
    ]
    
    @State var selectedTitle: String?
    @Binding var isShow: Bool
    @Binding var subSeq: Int
    let onPress: () -> Void
    
    private struct sizeInfo {
        static let topPadding: CGFloat = 20.0
        static let bottomPadding: CGFloat = 72.0
        static let padding32: CGFloat = 32.0
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: sizeInfo.topPadding)
            ForEach(clubOpenTitle, id: \.SEQ) { subTitle in
                ClubMemberDetailBottomRow(subTitle: subTitle.subTitle, selectedTitle: $selectedTitle, onPress: {
                    isShow = false
                    subSeq = subTitle.SEQ
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
