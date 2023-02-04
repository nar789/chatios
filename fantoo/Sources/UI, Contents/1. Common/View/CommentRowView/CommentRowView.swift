//
//  CommentRowView.swift
//  fantoo
//
//  Created by kimhongpil on 2022/07/24.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentRowView: View {
    var itemData: Comment_Community
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                
                WebImage(url: URL(string: itemData.comment_profile))
                    .resizable()
                    .frame(width: 22, height: 22)
                    .cornerRadius(8)
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 10))
                
                VStack(alignment: .leading, spacing: 0) {
                    /**
                     * Header
                     */
                    HStack(alignment: .center, spacing: 0) {
                        Text(itemData.comment_nickname)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray900)
                        Text(" • ")
                            .font(.system(size: 20))
                            .foregroundColor(Color.gray400)
                        Text(itemData.createAt)
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray400)
                        
                        Spacer()
                        
                        Image("icon_outline_more")
                            .frame(width: 24, height: 24)
                    }
                    /**
                     * Body
                     */
                    VStack(alignment: .leading, spacing: 0) {
                        Text(itemData.content)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray870)
                        
                        Text("번역하기")
                            .font(Font.caption11218Regular)
                            .foregroundColor(Color.gray500)
                            .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                        
                        if itemData.image != "" {
                            WebImage(url: URL(string: itemData.image))
                                .resizable()
                                .frame(width: 163, height: 154)
                                .scaledToFit()
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    /**
                     * Footer
                     */
                    HStack(alignment: .center, spacing: 0) {
                        HStack (alignment: .center) {
                            Button(action: {
                                print("좋아요 버튼 클릭")
                            }) {
                                Image("icon_fill_like")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.gray200)
                                    .frame(width: 20, height: 20)
                            }
                            /**
                             * PlainButtonStyle() 추가해주지 않으면 List에서 클릭한 Item의 버튼이 아니라 Item 전체가 깜빡이는 문제가 있음
                             */
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(String(itemData.comment_like_count))
                                .font(Font.caption11218Regular)
                                .foregroundColor(.gray800)
                            
                            Button(action: {
                                print("싫어요 버튼 클릭")
                            }) {
                                Image("icon_fill_dislike")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.gray200)
                                    .frame(width: 20, height: 20)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            print("대댓글 버튼 클릭")
                        }) {
                            HStack(alignment: .center) {
                                Image("icon_fill_comment")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.gray200)
                                    .frame(width: 20, height: 20)
                                
                                Text(String(itemData.recomment.count))
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray800)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
        }
        .frame(width: UIScreen.screenWidth)
    }
}

//struct CommentRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentRowView()
//    }
//}
