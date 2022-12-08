//
//  NoSearchView.swift
//  fantoo
//
//  Created by fns on 2022/10/31.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct NoSearchView: View {
    
    @StateObject var languageManager = LanguageManager.shared
    
    let image: String
    let text: String
    
    private struct sizeInfo {
        static let padding8: CGFloat = 8.0
        static let padding10: CGFloat = 10.0
        static let spacing14: CGFloat = 14.0
        static let spacing71: CGFloat = 71.0
        static let spacing100: CGFloat = 100.0
        static let imageSize: CGSize = CGSize(width: 118, height: 124)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                
                Image(image)
                    .resizable()
                    .frame(width: sizeInfo.imageSize.width, height: sizeInfo.imageSize.height)
                Text(text)
                    .font(Font.body21420Regular)
                    .foregroundColor(Color.gray600)
                    .multilineTextAlignment(.center)
                    .padding(.top, sizeInfo.padding10)
                
                //            Text("se_j_add_favorite_community".localized)
                //                .font(Font.body21420Regular)
                //                .foregroundColor(Color.gray600)
                //                .multilineTextAlignment(.center)
                //                .padding(.top, sizeInfo.padding8)
                
                Spacer()
            }
            .padding(.horizontal, sizeInfo.spacing71)
            .padding(.bottom, sizeInfo.spacing100)
        }
    }
}

struct NoSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NoSearchView(image: "", text: "")
    }
}
