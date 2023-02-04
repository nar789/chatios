//
//  ReplyWritingView.swift
//  fantoo
//
//  Created by kimhongpil on 2022/12/08.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation
import Photos


/**
 * 영상파일 가져올 때 참고할 것
 * 비디오 올릴때 용량이 클경우 문제가 생긴다고 tos 방식?으로 보내야 된다네요.
   안드로이드의 경우 앱이 죽는데요 tos 방식으로 안보내면요.
   참고하세요.
 */


struct DetailPageReplyWritingView: View {
    let viewType: ReplyWritingViewType
    @Binding var text: String
    @Binding var isKeyboardFocused: Bool
    //@Binding var pickedImage: UIImage
    @Binding var pickedImage: String
    @Binding var isSecretClick: Bool
    @Binding var isUnqualifiedImageSize: Bool
    
    var isClickSend: ((Bool) -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            
            
            if !isUnqualifiedImageSize {
                /**
                 * Image Picker 영역
                 */
                if !pickedImage.isEmpty {
                    VStack(spacing: 0) {
                        ZStack {
                            HStack(spacing: 0) {
                                Spacer()
                                
                                // String to UIImage
                                Image(uiImage: pickedImage.toImage() ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(10)
                                    .padding(.vertical, 12)
                                
                                Spacer()
                            }

                            HStack(spacing: 0) {
                                Spacer()

                                VStack(spacing: 0) {
                                    Button(action: {
                                        // 이미지 초기화 (self.image.size.width = 0.0)
                                        //self.pickedImage = UIImage()
                                        pickedImage = ""
                                    }) {
                                        Image("icon_outline_cancel")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color.gray25)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .padding(20)
                        }
                        .background(Color.gray900.opacity(0.4))
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            
            /**
             * 댓글 작성 영역
             */
            ReplyWritingView(
                viewType: viewType,
                text: $text,
                pickedImage: $pickedImage,
                isSecretClick: $isSecretClick,
                isUnqualifiedImageSize: $isUnqualifiedImageSize,
                isKeyboardFocused: $isKeyboardFocused,
                isClickSend: { isClick in
                    if isClick {
                        if let NOisClickSend = self.isClickSend {
                            NOisClickSend(true)
                        }
                    }
                }
            )
            .onChange(of: isUnqualifiedImageSize, perform: { (value) in
                if value {
                    //self.pickedImage = UIImage()
                    pickedImage = ""
                }
            })
            
        }
    }
}


struct ReplyWritingView: View {
    let viewType: ReplyWritingViewType
    @Binding var text: String
    //@Binding var pickedImage: UIImage
    @Binding var pickedImage: String
    @Binding var isSecretClick: Bool
    @Binding var isUnqualifiedImageSize: Bool
    @Binding var isKeyboardFocused: Bool
    @State var showImagePicker = false
    
    var isClickSend: ((Bool) -> Void)?

//    init(text: Binding<String>, pickedImage: Binding<UIImage>, isSecretClick: Binding<Bool>, isUnqualifiedImageSize: Binding<Bool>) {
//        self._text = text
//        self._pickedImage = pickedImage
//        self._isSecretClick = isSecretClick
//        self._isUnqualifiedImageSize = isUnqualifiedImageSize
//    }

    var body: some View {
        VStack(spacing: 0) {
            // 그림자 영역
            Rectangle()
                .frame(height: 0.3)
                .foregroundColor(.gray100)
                .shadow(color: .gray900, radius: 4, x: 0, y: -2.5)
            
            // 댓글 작성 영역
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    
                    // 키보드 내림 + 메세지 비어있음 (메세지 입력하지 않은 상황)
                    if !isKeyboardFocused && text.isEmpty {
                        Button(action: {
                            showImagePicker = true
                        }, label: {
                            Image("icon_outline_picture")
                                .renderingMode(.template)
                                .foregroundColor(.stateActiveGray700)
                        })
                        //.buttonStyle(PlainButtonStyle())
                        .padding(.trailing, 5)
                    }
                    
                    ReplyTextEditorView(content: $text, isKeyboardFocused: $isKeyboardFocused, startHeight: 36)
                }
                
                /**
                 * - 키보드 올림 + 메세지 비어있음 (메시지 작성하려고 키보드 올린 상황)
                 * - 키보드 올림 + 메세지 비어있지 않음 (메시지 작성 중인 상황)
                 * - 키보드 내림 + 메세지 비어있지 않음 (메세지 작성 중 키보드 내린 상황)
                 */
                if (isKeyboardFocused && text.isEmpty) || (isKeyboardFocused && !text.isEmpty) || (!isKeyboardFocused && !text.isEmpty) {
                    HStack(spacing: 0) {
                        Button(action: {
                            showImagePicker = true
                        }, label: {
                            Image("icon_outline_picture")
                                .renderingMode(.template)
                                .foregroundColor(.stateActiveGray700)
                        })
                        //.buttonStyle(PlainButtonStyle())
                        
                        if viewType == .Community {
                            Button(action: {
                                isSecretClick = true
                            }, label: {
                                Image("icon_outline_anonymous")
                                    .renderingMode(.template)
                                    .foregroundColor(.stateActiveGray700)
                            })
                            //.buttonStyle(PlainButtonStyle())
                            .padding(.leading, 16)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // View 탭시, Keyboard dismiss 하기
                            UIApplication.shared.endEditing()
                            
                            if let NOisClickSend = isClickSend {
                                
                                if self.text.isEmpty {
                                    NOisClickSend(false)
                                } else {
                                    NOisClickSend(true)
                                }
                            }
                            
                        }) {
                            Image("icon_outline_send")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(.gray25)
                                .frame(width: 16, height: 16)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(self.text.isEmpty ? Color.gray200 : Color.stateActivePrimaryDefault)
                                )
                        }
                        //.buttonStyle(PlainButtonStyle())
                    }
                    .padding(.top, 10)
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 12, trailing: 20))
        }
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(
                sourceType: .photoLibrary,
                imageType: .BoardImage,
                imageCheck: { success, image, message in
                    if !success {
                        return
                    }
                    
                    //pickedImage = image
                    pickedImage = image.toPngString() ?? "" // UIImage to String
                },
                isUnqualifiedImageSize: { isUnqualified in
                    // 50메가 넘음
                    if isUnqualified {
                        isUnqualifiedImageSize = true
                    }
                    // 50메가 안 넘음
                    else {
                        isUnqualifiedImageSize = false
                    }
                }
            )
        })
    }
}
