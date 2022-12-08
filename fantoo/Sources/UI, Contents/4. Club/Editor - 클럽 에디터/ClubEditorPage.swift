//
//  ClubEditorPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/15.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct ClubEditorPage {
    
    @State var isSecret: Bool = false
    @State var txtTitle: String = ""
    @State var placeholderTitle: String = "제목을 입력해 주세요"
    @State var txtContents: String = ""
    @State var placeholderContents: String = "내용을 입력해 주세요.\n게시판 주제와 맞지 않거나 다른 사람에게 불쾌감을 주는 내용이 포함된 경우, 관리자 또는 자동으로 숨김처리 될 수 있습니다."
    @State private var txtContentsHeight: CGFloat = CGFloat()
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
    }
    
    /**
     * 언어팩 등록할 것
     */
    private let secretTitle = "익명 설정"
}

extension ClubEditorPage: View {
    var body: some View {
        // View 탭시, Keyboard dismiss 하기
        BackgroundTapGesture {
            GeometryReader   { geometry in
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {

                            Button(action: {
                                print("게시판 선택 버튼 클릭 !!!")
                            }, label: {
                                HStack(spacing: 0) {
                                    Text("게시판 선택")
                                        .font(.caption11218Regular)
                                        .foregroundColor(.gray900)

                                    Image("icon_outline_dropdown")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(.stateEnableGray400)
                                        .padding(.leading, 8)
                                }
                            })

                            ZStack {
                                Group {
                                    if self.txtTitle.isEmpty {
                                        TextField(text: $placeholderTitle)
                                            .disabled(true)
                                    }

                                    TextField("", text: $txtTitle)
                                        .opacity(self.txtTitle.isEmpty ? 0.25 : 1)
                                }
                                .font(.body21420Regular)
                                .foregroundColor(.gray400)
                                .padding(.vertical, 11)
                            }
                            .padding(.top, 8)

                            Divider()
                            
                            ZStack {
                                Group {
                                    Text(txtContents)
                                        .frame(minHeight: 150)
                                        //.lineLimit(5)
                                        .background(GeometryReader { proxy in
                                            Color.clear.preference(key: ClubEditor_ViewHeightKey.self,
                                                                   value: proxy.frame(in: .local).size.height)
                                        })
                                    
                                    if self.txtContents.isEmpty {
                                        TextEditor(text: $placeholderContents)
                                            .frame(height: txtContentsHeight)
                                            .disabled(true)
                                    }

                                    TextEditor(text: $txtContents)
                                        .frame(height: txtContentsHeight)
                                        .opacity(self.txtContents.isEmpty ? 0.25 : 1)
                                }
                                .font(.body21420Regular)
                                .foregroundColor(.stateEnableGray400)
                                .lineSpacing(5)
                                
                            }
                            .padding(.top, 16)
                            //.frame(height: geometry.size.height * 0.8)
                            .onPreferenceChange(ClubEditor_ViewHeightKey.self, perform: { updatedOffset in
                                txtContentsHeight = updatedOffset
                            })
                        }
                        
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, sizeInfo.Hpadding)

                    footerView
                }
            }
            
        }
        /**
         * 아래 .ignoresSafeArea(edges: .bottom) 코드를 적용하면,
         * 키보드 입력시, 키보드 바로 위에 footerView 가 올라가지 않는 문제가 발생한다.
         *
         * 원인 분석 :
         * .ignoresSafeArea(edges: .bottom) 또는 .ignoresSafeArea(.keyboard) 를 parent view 에 적용하면,
         * 키보드가 나타날 때 parent view 가 재조정되지 않는다고 한다.
         * [Ref]
         * - https://mac-user-guide.tistory.com/87
         */
        //.ignoresSafeArea(edges: .bottom)
        .onTapGesture {
            // View 탭시, Keyboard dismiss 하기
            UIApplication.shared.endEditing()
        }
        .navigationType(
            leftItems: [.Close],
            rightItems: [.Register],
            leftItemsForegroundColor: Color.black,
            rightItemsForegroundColor: Color.stateEnableGray400,
            title: "",
            onPress: { buttonType in
                if buttonType == .Register {
                    print("clicked community create")
                }
            }
        )
    }
    
    
    var footerView: some View {
        HStack(spacing: 0) {
            Button(action: {
                //
            }, label: {
                Image("icon_outline_picture")
            })
            Button(action: {
                //
            }, label: {
                Image("icon_outline_video")
            })
            .padding(.horizontal, sizeInfo.Hpadding)
            Button(action: {
                //
            }, label: {
                Image("icon_outline_hashtag")
            })
            
            Spacer()
                .frame(maxWidth: .infinity)
            
            Text(secretTitle)
                .font(.body21420Regular)
                .foregroundColor(.gray600)
            Toggle(isOn: $isSecret, label: {
                
            })
            .onChange(of: isSecret, perform: { newValue in
                print("newValue : \(newValue)" as String)
            })
            .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
            .fixedSize()
        }
        .padding(EdgeInsets(top: 24, leading: 18, bottom: 34, trailing: 18))
        .background(
            RoundedCornersShape(
                corners: [.topLeft, .topRight],
                radius: 24
            )
            .fill(Color.gray25)
            .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: -6)
        )
    }
}

struct ClubEditorPage_Previews: PreviewProvider {
    static var previews: some View {
        ClubEditorPage()
    }
}

struct ClubEditor_ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
