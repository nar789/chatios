//
//  ClubSettingInfoView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubSettingInfoView: View {
    
    let myPostCount: Int
    let myCommentCount: Int
    let savedPostCount: Int
    let onPress: (StorageButtonType) -> Void
    
    private struct sizeInfo {
        static let cellHeight: CGFloat = 100.0
        
        static let textSpacing: CGFloat = 5.0
        static let dividerWidth: CGFloat = 1.0
        static let dividerPadding: CGFloat = 30.0
        static let dividerHeight: CGFloat = 8.0
        static let dividerBottomHeight: CGFloat = 8.0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    
                    ZStack {
                        Button {
                            onPress(.Post)
                        } label: {
                            VStack {
                                Text("j_wrote_post".localized)
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray600)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Spacer().frame(height: sizeInfo.textSpacing)
                                
                                Text("\(myPostCount)")
                                    .font(Font.buttons1420Medium)
                                    .foregroundColor(Color.gray900)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(width: geo.size.width/3)
                        }
                        .buttonStyle(.borderless)
                        
                        VerticalDivider(color: Color.gray400, width: sizeInfo.dividerWidth)
                            .opacity(0.12)
                            .padding(EdgeInsets(top: sizeInfo.dividerPadding, leading: geo.size.width/3 - sizeInfo.dividerWidth, bottom: sizeInfo.dividerPadding, trailing: 0.0))
                    }
                    
                    
                    ZStack {
                        Button {
                            onPress(.Comment)
                        } label: {
                            VStack {
                                Text("j_wrote_rely".localized)
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray600)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Spacer().frame(height: sizeInfo.textSpacing)
                                
                                //                                Text(myCommentCount.insertComma)
                                Text("\(myCommentCount)")
                                    .font(Font.buttons1420Medium)
                                    .foregroundColor(Color.gray900)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(width: geo.size.width/3)
                        }
                        .buttonStyle(.borderless)
                        
                        VerticalDivider(color: Color.gray400, width: sizeInfo.dividerWidth)
                            .opacity(0.12)
                            .padding(EdgeInsets(top: sizeInfo.dividerPadding, leading: geo.size.width/3 - sizeInfo.dividerWidth, bottom: sizeInfo.dividerPadding, trailing: 0.0))
                    }
                    
                    ZStack {
                        Button {
                            onPress(.Save)
                        } label: {
                            VStack {
                                Text("j_save".localized)
                                    .font(Font.body21420Regular)
                                    .foregroundColor(Color.gray600)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Spacer().frame(height: sizeInfo.textSpacing)
                                
                                Text("\(savedPostCount)")
                                    .font(Font.buttons1420Medium)
                                    .foregroundColor(Color.gray900)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(width: geo.size.width/3)
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: sizeInfo.cellHeight)
            
            ExDivider(color: Color.bgLightGray50, height: sizeInfo.dividerHeight)
        }
    }
}


struct ClubSettingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ClubSettingInfoView(myPostCount: 32, myCommentCount: 3, savedPostCount: 12421, onPress: { buttonType in
        })
            .previewLayout(.sizeThatFits)
    }
}

