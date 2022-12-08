//
//  ClubProfileSettingPage.swift
//  fantoo
//
//  Created by mkapps on 2022/06/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubMyProfileSettingPage: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
        static let padding30: CGFloat = 30.0
        
        static let inputHeight: CGFloat = 42.0
        static let buttonWidth: CGFloat = 86.0
        static let buttonCornerRadius: CGFloat = 7.0
    }
    
    @Binding var clubId: String
    @Binding var profileImg: String
    @Binding var nickname: String
    
    @State var leftItems: [CustomNavigationBarButtonType] = [.AlertBack]
    @State var rightItems: [CustomNavigationBarButtonType] = [.Save]
    
    @State var checkToken:String = ""
    @State var correctStatus:CheckCorrectStatus = .Check
    
    //alert
    @State var showAlertCannotUse: Bool = false
    @State var showAlertLength: Bool = false
    @State var showAlertAlreadyUse: Bool = false
    @State var showAlertUsable: Bool = false
    @State var showAlertCannotChange: Bool = false
    @State var showImagePicker: Bool = false
    @State var showAlertTabDoubleCheck: Bool = false
    @State var showAlertEditCancel: Bool = false
    
    @State var nicknameState: Bool = false
    @State var imageState: Bool = false
    //false일때가 사용가능임
    @State var exist: Bool = true
    
    
    @StateObject var vm = ClubSettingViewModel()
    
    @State var profileUrl: String = ""
    
    
    var body: some View {
        VStack(spacing: 0) {
            ClubMyProfileSettingProfileView(profileUrl: profileImg.imageOriginalUrl) {
                showImagePicker = true
            }
            
            HStack(spacing: 0) {
                Text("n_nickname".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(format: "%ld/20", nickname.count))
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray300)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.top, DefineSize.Contents.TopPadding)
            
            
            HStack(spacing: 0) {
                CustomTextField(text: $nickname, correctStatus: $vm.nickNameCorrectStatus, isKeyboardEnter: $vm.nickNameDidEnter, placeholder: "se_n_write_nickname".localized)
                    .onChange(of: nickname) { newValue in
                        
                        if nickname.count == 0 {
                            vm.nickNameCorrectStatus = .Check
                        }
                        else {
                            if nickname.count >= 1 && nickname.count <= 20 {
                                vm.nickNameCorrectStatus = .Correct
                            }
                            else {
                                vm.nickNameCorrectStatus = .Wrong
                            }
                        }
                        
                        if !vm.existYn {
                            exist = true
                        }
                        
                        print("exist1 :: \(exist)")
                        
                    }
                Button {
                    vm.requestClubMemberNicknameCheck(clubId: clubId, nickName: nickname) { success in
                        if success {
                            if !vm.existYn {
                                nicknameState = true
                                vm.rightItemsState = true
                            }
                        }
                    }
                    exist = false
                    
                } label: {
                    Text("j_check_duplicate".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray25)
                        .modifier(ButtonTextMinimunScaleModifier())
                }
                .buttonStyle(.borderless)
                .frame(maxHeight: .infinity)
                .frame(width: sizeInfo.buttonWidth)
                .background(Color.stateActivePrimaryDefault.cornerRadius(sizeInfo.buttonCornerRadius))
                .padding(.leading, sizeInfo.padding)
            }
            .frame(maxWidth: .infinity)
            .frame(height: sizeInfo.inputHeight)
            .padding(.top, sizeInfo.padding)
            
            ZStack {
                if nickname.count > 0 && !exist {
                    Text(vm.checkNickNameWarning)
                        .font(Font.caption21116Regular)
                        .foregroundColor(vm.existYn ? Color.stateDanger : Color.primary500)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, sizeInfo.padding5)
                }
                else {
                    Text("se_n_change_nickname_notice_2".localized)
                        .font(Font.caption21116Regular)
                        .foregroundColor(.gray600)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, sizeInfo.padding5)
                }
            }
        }
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        .padding(.top, DefineSize.Contents.TopPadding)
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear(perform: {
        })
        
        .showAlertSimple(isPresented: $showAlertCannotUse, type: .Default, title: "", message: "se_s_including_cannot_use_char".localized, detailMessage: "") { index in
        }
        
        .showAlertSimple(isPresented: $showAlertLength, type: .Default, title: "", message: "se_num_write_within".localized, detailMessage: "") { index in
        }
        
        .showAlertSimple(isPresented: $showAlertAlreadyUse, type: .Default, title: "", message: "se_a_already_use_nickname".localized, detailMessage: "") { index in
        }
        
        .showAlertSimple(isPresented: $showAlertUsable, type: .Default, title: "", message: "se_s_can_use_nickname".localized, detailMessage: "") { index in
        }
        
        .showAlert(isPresented: $showAlertEditCancel, type: .Default, title: "", message: "프로필 수정을 취소하시겠습니까?", detailMessage: "", buttons: ["c_cancel".localized, "h_confirm".localized], onClick: { buttonIndex in
            if buttonIndex == 1 {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .showAlertSimple(isPresented: $showAlertTabDoubleCheck, type: .Default, title: "", message: "se_n_do_checking_duplicate_nickname".localized, detailMessage: "") { index in
        }
        
        .showAlertSimple(isPresented: $showAlertCannotChange, type: .Default, title: "", message: String(format: "se_n_change_nickname_notice_1".localized, "30", "15"), detailMessage: "") { index in
        }
        
        //alert
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: "", message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
        //image picker
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(sourceType: .photoLibrary, imageType: .ProfileImage) { success, image, message in
                
                if !success {
                    vm.alertMessage = message
                    vm.showAlert = true
                    return
                }
                
                vm.requestUploadImage(image: image) { url in
                    profileImg = url
                    imageState = true
                    vm.rightItemsState = true
                    exist = false
                    
                }
            }
        })
        
        .background(Color.gray25)
        .navigationType(leftItems: leftItems, rightItems: rightItems, leftItemsForegroundColor: .black, rightItemsForegroundColor: vm.rightItemsState && !exist ? Color.primary500 : Color.gray400, title: "p_setting_profile".localized, onPress: { buttonType in
            if buttonType == .AlertBack {
                if imageState || nicknameState {
                    showAlertEditCancel = true
                }
                else {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            
            else if buttonType == .Save {
                if vm.nickNameCorrectStatus == .Correct && exist {
                    showAlertTabDoubleCheck = true
                }
                else if vm.rightItemsState && imageState {
                    print("nickname :: \(vm.nickname)")
                    print("profileImg :: \(profileImg)")
                    vm.requestClubMemberEdit(clubId: clubId, integUid: UserManager.shared.uid, profileImg: profileImg) { success in
                        if success {
                            vm.profileImg = profileImg
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }
                    }
                }
                else if vm.rightItemsState && nicknameState && !exist {
                    vm.requestClubMemberEdit(clubId: clubId, checkToken: vm.nicknameCheckToken, integUid: UserManager.shared.uid, nickname: nickname) { success in
                        if success {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                else if vm.rightItemsState && imageState && nicknameState && !exist {
                    vm.requestClubMemberEdit(clubId: clubId, checkToken: vm.nicknameCheckToken, integUid: UserManager.shared.uid, nickname: nickname, profileImg: profileImg) { success in
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
        .statusBarStyle(style: .darkContent)
    }
}
