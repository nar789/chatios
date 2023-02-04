//
//  AgreeCheckSubView.swift
//  fantoo
//
//  Created by mkapps on 2022/07/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct JoinAgreeCheckSubView : View {
    
    enum AgreeCheckSubViewButtonType {
        case Check
        case More
    }
    
    private struct sizeInfo {
        static let agreeViewHeight: CGFloat = 32.0
        static let checkSize: CGSize = CGSize(width: 24.0, height: 24.0)
        
        static let padding8: CGFloat = 8.0
        static let padding10: CGFloat = 10.0
    }
    
    @Binding var isCheck: Bool
    var title: String = ""
    var isOptional: Bool = false
    var isMore: Bool = false
    
    let onPress: (AgreeCheckSubViewButtonType) -> Void
    
    var body: some View {
        
        HStack(spacing: 0) {
            Button {
                onPress(.Check)
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    Image(isCheck ? "Checkbox_login_checked" : "Checkbox_login_unchecked")
                        .frame(width:sizeInfo.checkSize.width, height:sizeInfo.checkSize.height)
                        .padding(.trailing, sizeInfo.padding8)
                    
                    if isOptional {
                        Text(title)
                            .font(Font.buttons1420Medium)
                            .foregroundColor(Color.gray870)
                            .fixedSize()
                        
                        Text(String(format: " (%@)", "s_select".localized))
                            .font(Font.buttons1420Medium)
                            .foregroundColor(Color.gray300)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    else {
                        Text(title)
                            .font(Font.buttons1420Medium)
                            .foregroundColor(Color.gray870)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(height: sizeInfo.agreeViewHeight, alignment: .center)
            }
            
            if isMore {
                Button {
                    onPress(.More)
                } label: {
                    Text("b_view".localized)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray400)
                        .fixedSize()
                        .frame(height: sizeInfo.agreeViewHeight, alignment: .center)
                        .padding(.leading, sizeInfo.padding10)
                }
            }
        }
    }
}

struct JoinAgreeCheckSubView_Previews: PreviewProvider {
    static var previews: some View {
        JoinAgreeCheckSubView(isCheck: .constant(false), title: "title", isOptional: true, isMore: true) { type in
        }
    }
}

