//
//  ClubPostArchivePage.swift
//  fantoo
//
//  Created by fns on 2022/07/20.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ClubPostArchivePage: View {
    
    private struct sizeInfo {
        static let dividerHeight: CGFloat = 8
        static let textFieldHeight: CGFloat = 42
        static let spacer15: CGFloat = 15.5
        static let padding24: CGFloat = 24
        static let cellHeight: CGFloat = 50.0
        static let cellLeadingPadding: CGFloat = 20.0
        static let cellBottomPadding: CGFloat = 14.0
        static let cellTrailingPadding: CGFloat = 16.0
        static let cellTopPadding: CGFloat = 19.5
        static let bottomPadding: CGFloat = DefineSize.SafeArea.bottom
        static let bottomSheetHeight: CGFloat = 189.0 + DefineSize.SafeArea.bottom
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var bottomSheetManager = BottomSheetManager.shared
    
    @StateObject var vm = ClubPostViewModel()
    
    @ObservedObject var viewModel: ClubPostViewModel
    
    @Binding var clubId: String
    @Binding var categoryCode: String
    @Binding var categoryName: String
    @Binding var categoryVisibility: Bool
    @Binding var categoryBoardType: Int
    @Binding var editType: Int
    
    @State var postTitle: String = ""
    @State var isFocusOn: Bool = false
    
    
    // bottomView, Navi
    @State var showHeadTitlePage: Bool = false
    @State var showSheetPostVisibility: Bool = false
    @State var showArchiveType: Bool = false
    @State var showDeleteAlert: Bool = false
    @State var limitPostTitleAlert: Bool = false
    
    @State var rightItemsColorBlack: Color = .gray300
    @State var rightItemsColor: Color = .primaryDefault
    
    // textField
    //    @State var postTitle: String = ""
    @State var isKeyboardEnter: Bool = false
    @State var correctStatus:CheckCorrectStatus = .Check
    @State var isFirstResponder = true
    
    
    @State var postVisibilityTitle: String = "j_total_visibility".localized
    @State var archiveTypeTitle: String = "a_image".localized
    @State var selectedNum: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: sizeInfo.spacer15)
            ExDivider(color: Color.bgLightGray50, height: 1)
            HStack {
                Text("g_board_name".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("\(postTitle.count)")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.primaryDefault)
                + Text("/20")
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray300)
            }
            .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: sizeInfo.cellLeadingPadding))
            
            ZStack {
                CustomTextField(text: $postTitle, correctStatus: $correctStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "게시판명을 입력하세요.", isFirstResponder: isFocusOn, type: .Default)
                //                CustomFocusTextField(placeholder: "게시판명을 입력하세요.", isFirstResponder: true, text: $postTitle, correctStatus: $correctStatus, isKeyboardEnter: $isKeyboardEnter)
                    .frame(maxWidth: .infinity)
                    .frame(height: sizeInfo.textFieldHeight)
                    .onReceive(postTitle.publisher.collect()) {
                        self.postTitle = String($0.prefix(20))
                    }
                    .onChange(of: postTitle) { newValue in
                        if postTitle.count >= 20 {
                            self.limitPostTitleAlert.toggle()
                        }
                        
                    }
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            ExDivider(color: Color.bgLightGray50, height: sizeInfo.dividerHeight)
                .padding(.top, sizeInfo.padding24)
            
            SettingListLinkView(text: "g_board_public_settings".localized, subText: bottomSheetManager.onPressArchiveVisibilityTitle, lang: "", type: .ClickRight, showLine: true) {
//                showSheetPostVisibility = true
                BottomSheetManager.shared.show.archiveVisibilityTitle = true
                BottomSheetManager.shared.customBottomSheetClickType = .ArchiveVisibilityTitle
                isFocusOn = false
            }
            
            SettingListLinkView(text: "a_select_archive_type".localized, subText: bottomSheetManager.onPressArchiveTypeTitle, lang: "", type: .ClickRight, showLine: true) {
                //                showArchiveType = true
                BottomSheetManager.shared.show.archiveTypeTitle = true
                BottomSheetManager.shared.customBottomSheetClickType = .ArchiveTypeTitle
                isFocusOn = false
            }
            
            Spacer().frame(maxHeight: .infinity)
            
            Button {
                showDeleteAlert = true
            } label: {
                CommonButton(title: "g_board_delete".localized, bgColor: Color.stateActivePrimaryDefault)
                    .padding([.horizontal, .bottom], DefineSize.Contents.HorizontalPadding)
            }
        }
        // 키보드 버튼 가려짐
        .ignoresSafeArea(.keyboard)
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .onAppear(perform: {
            postTitle = categoryName
            if editType == 1 {
                isFocusOn = true
            }
            
            if categoryVisibility {
                bottomSheetManager.onPressArchiveVisibilityTitle =  "g_open_public".localized
            }
            else {
                bottomSheetManager.onPressArchiveVisibilityTitle = "b_hidden".localized
            }
            
            if categoryBoardType == 2 {
                bottomSheetManager.onPressArchiveTypeTitle = "a_image".localized
            }
            else {
                bottomSheetManager.onPressArchiveTypeTitle = "a_general".localized
            }
        })
        
        .onChange(of: bottomSheetManager.onPressArchiveTypeTitle, perform: { (newValue) in
            switch newValue {
            case ImageOrGeneralType.Image.description:
                categoryBoardType = 2
                
            case ImageOrGeneralType.General.description:
                categoryBoardType = 1
                
            default:
                print("")
            }
        })
        
        .onChange(of: bottomSheetManager.onPressArchiveVisibilityTitle, perform: { (newValue) in
            switch newValue {
            case OpenOrHiddenType.Open.description:
                vm.openYn = true
                
            case OpenOrHiddenType.Hidden.description:
                vm.openYn = false
                
            default:
                print("")
            }
        })
        
        //        .bottomSheet(isPresented: $showSheetPostVisibility, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
        //            ClubPostArchiveBottomView(title: "g_board_public_settings".localized, type: .PostVisibilitySetting, selectedTitle: $postVisibilityTitle, selectedNum: $selectedNum, isShow: $showSheetPostVisibility) {
        //                if selectedNum == 0 {
        //                    vm.openYn = true
        //                }
        //                else {
        //                    vm.openYn = false
        //                }
        //            }
        //        })
        
        //        .bottomSheet(isPresented: $showArchiveType, height: sizeInfo.bottomSheetHeight, topBarCornerRadius: DefineSize.CornerRadius.BottomSheet, content: {
        //            ClubPostArchiveBottomView(title: "a_select_archive_type".localized, type: .ArchiveType, selectedTitle: $archiveTypeTitle, selectedNum: $selectedNum, isShow: $showArchiveType) {
        //                vm.boardType = selectedNum
        //            }
        //        })
        
        .popup(isPresenting: $limitPostTitleAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text( "se_m_member_hidden_club".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            //                        .multilineTextAlignment(.center)
                .background(Color.gray800)
        })
        
        .showAlert(isPresented: $showDeleteAlert, type: .Default, title: "g_board_delete".localized, message: "se_s_delete_board".localized, detailMessage: "", buttons: ["c_cancel".localized, "s_delete".localized], onClick: { buttonIndex in
            if buttonIndex == 1 {
                vm.requestDeleteClubBoardList(categoryCode: categoryCode, clubId: clubId) { success in
                    if success {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        })
        
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [.Done], leftItemsForegroundColor: .black, rightItemsForegroundColor: postTitle.count > 0 ? rightItemsColor : rightItemsColorBlack, title: "a_add_archive_board".localized, onPress: { buttonType in
            if buttonType == .Done {
                if editType == 1 {
                    vm.requestSettingClubBoardList(categoryCode: categoryCode, clubId: clubId, boardType: categoryBoardType, categoryName: postTitle, integUid: UserManager.shared.uid, openYn: vm.openYn) { success in
                        if success {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                else {
                    vm.requestCreateClubBoardList(categoryCode: "archive", clubId: clubId, boardType: categoryBoardType, categoryName: postTitle, openYn: vm.openYn) { success in
                        if success {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        })
        .navigationBarBackground {
            Color.gray25
        }
        //                .statusBarStyle(style: .darkContent)
    }
    
    func CategoryReset() {
        categoryCode = ""
        postTitle = ""
    }
    
    
    func addNewPost() {
        //        let newPost = DraggedPost(title: postTitle)
        //        self.viewModel.post.append(newPost)
    }
    
    //    func appendList() {
    //        let inputList = DraggedItem(title: "자유게시판")
    //        clubPostPage.dataList.append(inputList)
    //    }
}
