//
//  ClubProfileSetting.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/06/30.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct ClubProfileSettingPage: View {
    
    @StateObject var vm = ClubInfoSettingViewModel()
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var clubId: String
    
    private struct sizeInfo {
        static let padding5: CGFloat = 5.0
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 50.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
        
        static let inputHeight: CGFloat = 42.0
        static let buttonWidth: CGFloat = 86.0
        static let buttonCornerRadius: CGFloat = 7.0
        
        static let textViewHeight: CGFloat = 96.0
        static let textViewCornerRadius: CGFloat = 3.0
    }
    
    @State var leftItems: [CustomNavigationBarButtonType] = [.AlertBack]
    @State var rightSaveItems: [CustomNavigationBarButtonType] = [.Save]
    
    @State var rightItemsColorBlack: Color = .black
    @State var rightItemsColor: Color = .primary500
    
    @State var correctStatus:CheckCorrectStatus = .Check
    @State var isKeyboardEnter: Bool = false
    @State var editCancelAlert: Bool = false
    
    @State var textFieldState: Bool = false
    @State var changeState: Bool = false
    @State var imageState: Bool = false
    @State var nickCheckAlert: Bool = false
    @State var nicknameChange: Bool = false
    
    @State var clubIntroduce:String = ""
    
    @State var showBackgoundImagePicker = false
    @State var showProfileImagePicker = false
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ClubProfileSettingProfileView(profileUrl: vm.profileImg.imageOriginalUrl, backgroundUrl: vm.bgImg.imageOriginalUrl, imgState: $vm.imgState) { buttonType in
                        print("buttonType : \(buttonType)")
                        if buttonType == .Profile {
                            showProfileImagePicker = true
                            
                        }
                        else if buttonType == .Background {
                            showBackgoundImagePicker = true
                            
                        }
                    }
                    
                    writeClubName
                    writeClubIntroduce
                    
                }
                .modifier(ScrollViewLazyVStackModifier())
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)

            //imagePicker
            .sheet(isPresented: $showProfileImagePicker, content: {
                ImagePicker(sourceType: .photoLibrary, imageType: .ProfileImage) { success, image, message in
                    
                    if !success {
                        vm.alertMessage = message
                        vm.showAlert = true
                        return
                    }
                    
                    vm.requestUploadImage(image: image) { url in
                        vm.profileImg = url
                        vm.rightItemsState = true
                        changeState = true
                        
                    }
                }
            })
            
            .sheet(isPresented: $showBackgoundImagePicker, content: {
                ImagePicker(sourceType: .photoLibrary, imageType: .BgImage) { success, image, message in
                    
                    if !success {
                        vm.alertMessage = message
                        vm.showAlert = true
                        return
                    }
                    
                    vm.requestUploadImage(image: image) { url in
                        vm.bgImg = url
                        vm.rightItemsState = true
                        changeState = true
                        
                    }
                }
            })
            
            //alert
            .showAlert(isPresented: $vm.showAlert, type: .Default, title: "", message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
                if buttonIndex == 0 {
                    //                    self.presentationMode.wrappedValue.dismiss()
                }
            })
            .showAlert(isPresented: $editCancelAlert, type: .Default, title: "", message: "se_p_cancel_modify_profile", detailMessage: "", buttons: ["c_cancel".localized, "h_confirm".localized], onClick: { buttonIndex in
                if buttonIndex == 1 {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
            .showAlert(isPresented: $nickCheckAlert, type: .Default, title: "", message: "se_n_do_checking_duplicate_nickname".localized, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
                if buttonIndex == 1 {
                    
                }
            })
            
            .onAppear(perform: {
                vm.requestClubFullInfoList(clubId: clubId) { success in
                }
            })
            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            
            .background(Color.gray25)
            .navigationType(leftItems: leftItems, rightItems: rightSaveItems, leftItemsForegroundColor: .black, rightItemsForegroundColor: vm.rightItemsState ? rightItemsColor : rightItemsColorBlack, title: "k_club_profile_settings".localized, onPress: { buttonType in
                if buttonType == .AlertBack {
                    if textFieldState || changeState {
                        editCancelAlert = true
                    }
                    else {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
                else if buttonType == .Save {

                    if nicknameChange && vm.clubNameCheckText.count == 0 {
                        nickCheckAlert = true

                    }
                    else {
                        if textFieldState {
                            vm.requestClubInfoEdit(clubId: clubId, bgImg: vm.bgImg, checkToken: vm.checkToken, clubName: vm.clubName, integUid: UserManager.shared.uid, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn, profileImg: vm.profileImg) { success in
                                if success {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                else {
                                    
                                }

                            }
                        }
                        else if changeState {
                            vm.requestClubInfoEdit(clubId: clubId, bgImg: vm.bgImg, integUid: UserManager.shared.uid, introduction: vm.introduction, memberCountOpenYn: vm.memberCountOpenYn, memberJoinAutoYn: vm.memberJoinAutoYn, memberListOpenYn: vm.memberListOpenYn, openYn: vm.openYn, profileImg: vm.profileImg) { success in
                                if success {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                else {
                                    
                                }
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
    
    
    var writeClubName: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("k_club_name".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(format: "%ld/30", vm.clubName.count))
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray300)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.top, DefineSize.Contents.TopPadding * 2)
            
            
            HStack(spacing: 0) {
                CustomTextField(text: $vm.clubName, correctStatus: $correctStatus, isKeyboardEnter: $isKeyboardEnter, placeholder: "se_n_write_nickname".localized)
                    .onChange(of: vm.clubName) { newValue in
                        if vm.clubName.count == 0 {
                            correctStatus = .Check
                        }
                        else {
                            if vm.clubName.count >= 1 && vm.clubName.count <= 30 {
                                correctStatus = .Correct
                            }
                            else {
                                correctStatus = .Wrong
                            }
                        }
                        
                        if vm.officialClubName == newValue {
                            nicknameChange = false
                            
                        } else {
                            nicknameChange = true
                        }
                    }
                
                Button {
                    vm.requestClubNameCheck(clubName: vm.clubName) { success in
                        print("vm.rightItemsState clubName :: \(vm.rightItemsState)")
                        if !vm.existYn {
                            vm.rightItemsState = true
                            textFieldState = true
                        } else {
                            vm.rightItemsState = false
                            textFieldState = false
                        }
                        
                    }
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
                if vm.clubNameCheckText.count > 0 {
                    Text(vm.clubNameCheckText)
                        .font(Font.caption21116Regular)
                        .foregroundColor(vm.existYn ? .gray600 : .stateEnablePrimaryDefault)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .leading], sizeInfo.padding5)
                }
                else {
                    Text("se_k_can_change_club_name".localized)
                        .font(Font.caption21116Regular)
                        .foregroundColor(.gray600)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, sizeInfo.padding5)
                }
            }
        }
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        
    }
    
    var writeClubIntroduce: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("k_club_introduce".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(format: "%ld/100", vm.introduction.count))
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray300)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.top, DefineSize.Contents.TopPadding * 2)
            
            TextView("se_k_write_club_introduction".localized, text: $vm.introduction, onEditingChanged: { editing in
                print(editing)
                
                clubIntroduce = vm.introduction
            })
                .textContainerInset(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
                .font(UIFont.body21420Regular)
                .foregroundColor(UIColor.gray900)
            
                .background(Color.gray50)
                .frame(height: sizeInfo.textViewHeight)
                .frame(maxWidth: .infinity)
                .clipped()
                .border(Color.gray100, width: 1.0)
                .cornerRadius(sizeInfo.textViewCornerRadius)
                .padding(.top, sizeInfo.padding5)
                .onChange(of: vm.introduction) { newValue in
                    
                    if clubIntroduce == newValue || clubIntroduce.count == 0 {
                        vm.rightItemsState = false
                        changeState = false
                    }
                    else {
                        vm.rightItemsState = true
                        changeState = true
                    }
                }
        }
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
    }
}


struct ClubProfileSettingPage_Previews: PreviewProvider {
    static var previews: some View {
        ClubProfileSettingPage(clubId: .constant(""))
    }
}

