//
//  Toast.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/19.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ToastView: View {
    
    @State var text: String
    
    private struct sizeInfo {
        static let spacing8: CGFloat = 8.0
        static let spacing14: CGFloat = 14.0
        static let cornerRadius: CGFloat = 12.0
        static let bottomSpacing: CGFloat = 160.0
    }
    
    
    var body: some View {
        ZStack {
            Spacer()
            Text(text)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, sizeInfo.spacing14)
                .padding(.vertical, sizeInfo.spacing8)
                .background(Color.gray800.cornerRadius(sizeInfo.cornerRadius))
            Spacer().frame(height: sizeInfo.bottomSpacing)
        }
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(text: "toast")
    }
}
