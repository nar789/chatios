//
//  ClubPostListView.swift
//  fantoo
//
//  Created by fns on 2022/07/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ClubPostListView: View {
    
    @StateObject var languageManager = LanguageManager.shared
    
    enum ClubPostListViewType: Int {
        case Default
        case Edit
        case None
        case Image
    }
    
    private struct sizeInfo {
        static let spacer15: CGFloat = 15.5
        static let padding2: CGFloat = 2.0
        static let padding10: CGFloat = 5.0
        static let padding12: CGFloat = 12.0
        static let padding14: CGFloat = 14.0
        static let padding16: CGFloat = 16.0
        static let padding17: CGFloat = 17.0
        static let padding24: CGFloat = 24.0
        static let frameHeight: CGFloat = 50.0
        static let textFieldHeight: CGFloat = 42.0
        static let rectangleWidth: CGFloat = 64.0
        static let rectangleHeight: CGFloat = 22.0
        static let rectangleCornerRadius: CGFloat = 12
        static let moveIconSize: CGSize = CGSize(width: 24, height: 24)
        static let arrowIconSize: CGSize = CGSize(width: 16, height: 16)
    }
    
    let type: ClubPostListViewType
    let text: String
    var body: some View {
        
        if type == .Default {
            ZStack {
                RoundedRectangle(cornerRadius: sizeInfo.rectangleCornerRadius)
                    .foregroundColor(Color.bgLightGray50)
                HStack {
                    Text(text)
                        .foregroundColor(Color.gray870)
                        .font(Font.body21420Regular)
                        .padding(.vertical, sizeInfo.padding14)
                        .padding(.leading, sizeInfo.padding16)
                    Spacer()
                    Image("icon_outline_go")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: sizeInfo.arrowIconSize.width, height: sizeInfo.arrowIconSize.height, alignment: .trailing)
                        .padding([.trailing], sizeInfo.padding16)
                        .foregroundColor(.stateEnableGray200)
                }
            }
            .frame(height: sizeInfo.frameHeight, alignment: .leading)
            .padding(.bottom, sizeInfo.padding10)
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        }
        
        else if type == .None {
            ZStack {
                RoundedRectangle(cornerRadius: sizeInfo.rectangleCornerRadius)
                    .foregroundColor(Color.bgLightGray50)
                Text("se_s_no_post_create".localized)
                    .foregroundColor(Color.gray500)
                    .font(Font.caption11218Regular)
                    .padding(.vertical, sizeInfo.padding17)
            }
            .frame(height: sizeInfo.frameHeight, alignment: .center)
            .padding(.bottom, sizeInfo.padding10)
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        }
        
        else if type == .Edit {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: sizeInfo.rectangleCornerRadius)
                        .foregroundColor(Color.bgLightGray50)
                    HStack {
                        Text(text)
                            .foregroundColor(Color.gray870)
                            .font(Font.body21420Regular)
                            .padding(.vertical, sizeInfo.padding14)
                            .padding(.leading, sizeInfo.padding16)
                        Spacer()
                    }
                }
                
                Image("icon_fill_move")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: sizeInfo.moveIconSize.width, height: sizeInfo.moveIconSize.height, alignment: .trailing)
                    .foregroundColor(.stateEnableGray200)
            }
            .frame(height: sizeInfo.frameHeight, alignment: .leading)
            .padding(.bottom, sizeInfo.padding10)
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        }
        
        else if type == .Image {
            ZStack {
                RoundedRectangle(cornerRadius: sizeInfo.rectangleCornerRadius)
                    .foregroundColor(Color.bgLightGray50)
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: sizeInfo.rectangleCornerRadius)
                            .foregroundColor(Color.secondaryDefault)
                            .frame(width: sizeInfo.rectangleWidth, height: sizeInfo.rectangleHeight, alignment: .center)
                        Text("Photo")
                            .foregroundColor(Color.gray25)
                            .font(Font.caption11218Regular)
                            .padding(.vertical, sizeInfo.padding2)
                            .padding(.horizontal, sizeInfo.padding12)
                    }
                    .padding(EdgeInsets(top: 0, leading: sizeInfo.padding16, bottom: 0, trailing: 0))
                    
                    Text("j_free_board".localized)
                        .foregroundColor(Color.gray870)
                        .font(Font.body21420Regular)
                        .padding(.vertical, sizeInfo.padding14)
                    Spacer()
                    Image("icon_outline_go")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: sizeInfo.arrowIconSize.width, height: sizeInfo.arrowIconSize.height, alignment: .trailing)
                        .padding([.trailing], sizeInfo.padding16)
                        .foregroundColor(.stateEnableGray200)
                }
            }
            .frame(height: sizeInfo.frameHeight, alignment: .leading)
            .padding(.bottom, sizeInfo.padding10)
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        }
    }
}

struct ClubPostArchiveListView: View {
    @StateObject var languageManager = LanguageManager.shared
    
    private struct sizeInfo {
        static let spacer15: CGFloat = 15.5
        static let padding2: CGFloat = 2.0
        static let padding10: CGFloat = 5.0
        static let padding12: CGFloat = 12.0
        static let padding14: CGFloat = 14.0
        static let padding16: CGFloat = 16.0
        static let padding17: CGFloat = 17.0
        static let padding24: CGFloat = 24.0
        static let frameHeight: CGFloat = 50.0
        static let textFieldHeight: CGFloat = 42.0
        static let rectangleWidth: CGFloat = 64.0
        static let rectangleHeight: CGFloat = 22.0
        static let rectangleCornerRadius: CGFloat = 12
        static let moveIconSize: CGSize = CGSize(width: 24, height: 24)
        static let arrowIconSize: CGSize = CGSize(width: 16, height: 16)
    }
    
    enum ClubPostListViewType: Int {
        case Default
        case Edit
        case Image
    }
    
    let type: ClubPostListViewType
    
    let draggedPost: DraggedPost
    
    var body: some View {
        if type == .Default {
        ZStack {
            RoundedRectangle(cornerRadius: sizeInfo.rectangleCornerRadius)
                .foregroundColor(Color.bgLightGray50)
            HStack {
                Text(draggedPost.title)
                    .foregroundColor(Color.gray870)
                    .font(Font.body21420Regular)
                    .padding(.vertical, sizeInfo.padding14)
                    .padding(.leading, sizeInfo.padding16)
                Spacer()
                Image("icon_outline_go")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: sizeInfo.arrowIconSize.width, height: sizeInfo.arrowIconSize.height, alignment: .trailing)
                    .padding([.trailing], sizeInfo.padding16)
                    .foregroundColor(.stateEnableGray200)
            }
        }
        .frame(height: sizeInfo.frameHeight, alignment: .leading)
        .padding(.bottom, sizeInfo.padding10)
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        }
        else if type == .Edit {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: sizeInfo.rectangleCornerRadius)
                        .foregroundColor(Color.bgLightGray50)
                    HStack {
                        Text(draggedPost.title)
                            .foregroundColor(Color.gray870)
                            .font(Font.body21420Regular)
                            .padding(.vertical, sizeInfo.padding14)
                            .padding(.leading, sizeInfo.padding16)
                        Spacer()
                    }
                }
                
                Image("icon_fill_move")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: sizeInfo.moveIconSize.width, height: sizeInfo.moveIconSize.height, alignment: .trailing)
                    .foregroundColor(.stateEnableGray200)
            }
            .frame(height: sizeInfo.frameHeight, alignment: .leading)
            .padding(.bottom, sizeInfo.padding10)
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        }
        
        else if type == .Image {
            ZStack {
                RoundedRectangle(cornerRadius: sizeInfo.rectangleCornerRadius)
                    .foregroundColor(Color.bgLightGray50)
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: sizeInfo.rectangleCornerRadius)
                            .foregroundColor(Color.secondaryDefault)
                            .frame(width: sizeInfo.rectangleWidth, height: sizeInfo.rectangleHeight, alignment: .center)
                        Text("Photo")
                            .foregroundColor(Color.gray25)
                            .font(Font.caption11218Regular)
                            .padding(.vertical, sizeInfo.padding2)
                            .padding(.horizontal, sizeInfo.padding12)
                    }
                    .padding(EdgeInsets(top: 0, leading: sizeInfo.padding16, bottom: 0, trailing: 0))
                    
                    Text(draggedPost.title)
                        .foregroundColor(Color.gray870)
                        .font(Font.body21420Regular)
                        .padding(.vertical, sizeInfo.padding14)
                    Spacer()
                    Image("icon_outline_go")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: sizeInfo.arrowIconSize.width, height: sizeInfo.arrowIconSize.height, alignment: .trailing)
                        .padding([.trailing], sizeInfo.padding16)
                        .foregroundColor(.stateEnableGray200)
                }
            }
            .frame(height: sizeInfo.frameHeight, alignment: .leading)
            .padding(.bottom, sizeInfo.padding10)
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        }
    }
}
