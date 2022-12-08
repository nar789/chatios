//
//  CommunityEditorPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct CommunityEditorPage {
    // 취소버튼 클릭시, NavigationLink 뒤로가기
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewModel = CommunityPostViewModel()
    
    @State var txtContentsHeight: CGFloat = CGFloat()
    
    private struct sizeInfo {
        static let Hpadding: CGFloat = DefineSize.Contents.HorizontalPadding
        static let bottomPadding: CGFloat = DefineSize.SafeArea.bottom
//        static let bottomSheetHeight: CGFloat = 189.0 + DefineSize.SafeArea.bottom
        //static let bottomSheetHeight: CGFloat = .infinity
    }
    
    /**
     * 언어팩 등록할 것
     */
    private let secretTitle = "익명 설정"
    private let mainCategoryTitle = "게시판 선택"
    private let subCategoryTitle = "말머리 선택"
}

extension CommunityEditorPage: View {
    var body: some View {
        // View 탭시, Keyboard dismiss 하기
        BackgroundTapGesture {
            GeometryReader   { geometry in
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {

                            HStack(spacing: 0) {
                                Button(action: {
                                    viewModel.getMemberRecogCategory(integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken)
                                }, label: {
                                    HStack(spacing: 0) {
                                        Text(viewModel.selectedMainCategoryName.count>0 ? viewModel.selectedMainCategoryName : mainCategoryTitle)
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
                                
                                if self.viewModel.selectedMainCategoryName.count > 0 {
                                    Button(action: {
                                        if viewModel.selectedMainCategoryCode.count > 0 {
                                            viewModel.getMemberSubCategory(code: viewModel.selectedMainCategoryCode, integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken)
                                        }
                                    }, label: {
                                        HStack(spacing: 0) {
                                            Text(viewModel.selectedSubCategoryName.count>0 ? viewModel.selectedSubCategoryName : subCategoryTitle)
                                                .font(.caption11218Regular)
                                                .foregroundColor(.gray900)
//                                            Text(viewModel.selectedSubCategoryName.count>0 ? viewModel.selectedSubCategoryName : subCategoryTitle)
//                                                .font(.caption11218Regular)
//                                                .foregroundColor(.gray900)

                                            Image("icon_outline_dropdown")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 12, height: 12)
                                                .foregroundColor(.stateEnableGray400)
                                                .padding(.leading, 8)
                                        }
                                    })
                                    .padding(.leading, 16)
                                }
                            }

                            ZStack {
                                Group {
                                    if self.viewModel.txtTitle.isEmpty {
                                        TextField(text: $viewModel.placeholderTitle)
                                            .disabled(true)
                                    }

                                    TextField("", text: $viewModel.txtTitle)
                                        .opacity(self.viewModel.txtTitle.isEmpty ? 0.25 : 1)
                                }
                                .font(.body21420Regular)
                                .foregroundColor(.gray400)
                                .padding(.vertical, 11)
                            }
                            .padding(.top, 8)

                            Divider()
                            
                            ZStack {
                                Group {
                                    Text(viewModel.txtContents)
                                        .frame(minHeight: 150)
                                        //.lineLimit(5)
                                        .background(GeometryReader { proxy in
                                            Color.clear.preference(key: CommunityEditor_ViewHeightKey.self,
                                                                   value: proxy.frame(in: .local).size.height)
                                        })
                                    
                                    if self.viewModel.txtContents.isEmpty {
                                        TextEditor(text: $viewModel.placeholderContents)
                                            .frame(height: txtContentsHeight)
                                            .disabled(true)
                                    }

                                    TextEditor(text: $viewModel.txtContents)
                                        .frame(height: txtContentsHeight)
                                        .opacity(self.viewModel.txtContents.isEmpty ? 0.25 : 1)
                                }
                                .font(.body21420Regular)
                                .foregroundColor(.stateEnableGray400)
                                .lineSpacing(5)
                                
                            }
                            .padding(.top, 16)
                            //.frame(height: geometry.size.height * 0.8)
                            .onPreferenceChange(CommunityEditor_ViewHeightKey.self, perform: { updatedOffset in
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
        .onAppear {
            if self.viewModel.isPostLoading {
                // 페이지 내에서 로딩
                StatusManager.shared.loadingStatus = .ShowWithTouchable
            }
        }
        .navigationType(
            leftItems: [.Close],
            rightItems: [.Register],
            leftItemsForegroundColor: Color.black,
            rightItemsForegroundColor: self.viewModel.checkPostData() ? Color.stateActivePrimaryDefault : Color.stateEnableGray400,
            title: "",
            onPress: { buttonType in
                if buttonType == .Register {
                    if self.viewModel.checkApiPostData() {
                        self.viewModel.postBoard(
                            code: self.viewModel.selectedMainCategoryCode,
                            anonymYn: false,
                            attachList: [],
                            content: self.viewModel.txtContents,
                            hashtagList: [],
                            integUid: UserManager.shared.uid,
                            subCode: self.viewModel.selectedSubCategoryCode,
                            title: self.viewModel.txtTitle,
                            access_token: UserManager.shared.accessToken,
                            isPostComplete: { isComplete in
                                if isComplete {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        )
                    } else {
                        // 아무 동작도 하지 않음
                    }
                } else if buttonType == .Close {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        )
        
        //MARK: - Shpw Sheet
        .bottomSheet(isPresented: $viewModel.showCategoryView, height: CGFloat(self.viewModel.mainCategory_bottomSheetHeight), topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
            
            BSCommunityEditorView(
                viewType: BSCommunityEditorViewType.MainCategory,
                memberRecogCategoryList: self.viewModel.memberRecogCategoryList,
                isShow: $viewModel.showCategoryView,
                selectedName: $viewModel.selectedMainCategoryName,
                selectedCategoryCode: $viewModel.selectedMainCategoryCode)
        })
        .bottomSheet(isPresented: $viewModel.showSubCategoryView, height: CGFloat(self.viewModel.subCategory_bottomSheetHeight), topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
            
            BSCommunityEditorView(
                viewType: BSCommunityEditorViewType.SubCategory,
                memberSubCategoryList: self.viewModel.memberSubCategoryList,
                isShow: $viewModel.showSubCategoryView,
                selectedName: $viewModel.selectedSubCategoryName,
                selectedCategoryCode: $viewModel.selectedSubCategoryCode)
        })
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
            Toggle(isOn: $viewModel.isSecret, label: {
                
            })
            .onChange(of: viewModel.isSecret, perform: { newValue in
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

struct CommunityEditorPage_Previews: PreviewProvider {
    static var previews: some View {
        CommunityEditorPage()
    }
}

/**
 * [by komhongpil]
 * PreferenceKey 프로토콜 이란?
 * : 자식 뷰에서 부모 뷰한테 이벤트를 전달할 수 있다.
 * 특정한 Key를 통해서 뭔가 변경된 것을 부모 뷰한테 알려줄 수 있다. (reduce() 를 통해서)
 */
struct CommunityEditor_ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
