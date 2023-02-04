//
//  StandByMemberCheckSubView.swift
//  fantoo
//
//  Created by fns on 2022/07/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct StandByMemberCheckSubView : View {
    @StateObject var languageManager = LanguageManager.shared
    
    enum AgreeCheckSubViewButtonType {
        case Check
        case More
    }
    
    private struct sizeInfo {
        static let cellHeight: CGFloat = 57.5
        static let checkSize: CGSize = CGSize(width: 24.0, height: 24.0)
        static let cellImageSize: CGSize = CGSize(width: 36.0, height: 36.0)
        static let padding12: CGFloat = 12.0
        static let padding10: CGFloat = 10.0
        static let textSpacing: CGFloat = 4.0
        static let cellTextHeight: CGFloat = 16.0
        static let dividerHeight: CGFloat = 1.0
        static let StackHeight: CGFloat = 36.0
    }
    
    @Binding var isCheck: Bool
    var approvalDate: String
    var nickname: String
    var image: String = ""
    let showLine: Bool
    let onPress: (AgreeCheckSubViewButtonType) -> Void
    
    var body: some View {
        
        ZStack {
            HStack(spacing: 0) {
                Button {
                    onPress(.Check)
                } label: {
                        Image(image)
                            .frame(width:sizeInfo.checkSize.width, height:sizeInfo.checkSize.height)
                            .padding(.trailing, sizeInfo.padding12)
                        WebImage(url: URL(string: ""))
                            .resizable()
                            .placeholder(Image(Define.ProfileDefaultImage))
                            .frame(width: sizeInfo.cellImageSize.width, height: sizeInfo.cellImageSize.height, alignment: .leading)
                            .clipped()
                            .cornerRadius(DefineSize.CornerRadius.ProfileThumbnailS)
                            .padding([.trailing], sizeInfo.padding10)
                        
                        VStack {
                            Text(nickname)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray900)
                                .frame(maxWidth: .infinity, maxHeight: sizeInfo.cellTextHeight, alignment: .leading)
                            Spacer().frame(width: sizeInfo.textSpacing)
                            HStack {
                                Text("s_application_date".localized)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray400)
                                    .frame(maxHeight: sizeInfo.cellTextHeight, alignment: .leading)

                                Text(approvalDate)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray400)
                                    .frame(maxHeight: sizeInfo.cellTextHeight, alignment: .leading)
                                Spacer()
                            }
                        }
                        .frame(height: sizeInfo.StackHeight, alignment: .center)
                }
            }
            .frame(height: sizeInfo.cellHeight, alignment: .center)
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
    
            if showLine {
                ExDivider(color: .bgLightGray50, height: sizeInfo.dividerHeight)
                    .frame(height: DefineSize.LineHeight, alignment: .bottom)
                    .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading:0, bottom: 0, trailing: 0)
                    )}
        }
    }
    
}
