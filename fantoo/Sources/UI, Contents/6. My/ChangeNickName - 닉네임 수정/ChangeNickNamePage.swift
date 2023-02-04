//
//  EditProfilePage.swift
//  fantoo
//
//  Created by mkapps on 2022/05/21.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ChangeNickNamePage: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    
    //Size
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let padding5: CGFloat = 5.0
        
        static let inputHeight: CGFloat = 42.0
        static let buttonWidth: CGFloat = 86.0
        static let buttonCornerRadius: CGFloat = 7.0
    }
    
    
    //Binding
    @Binding var nickName: String
    
    
    //State
    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = [.UnSave]
    @State var rightSaveItems: [CustomNavigationBarButtonType] = [.Save]
    
    
    @StateObject var vm = ChangeNickNameViewModel()
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("n_nickname".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(format: "%ld/20", vm.textNickname.count))
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray300)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.top, DefineSize.Contents.TopPadding * 2)
            
            HStack(spacing: 0) {
                CustomTextField(text: $vm.textNickname, correctStatus: $vm.correctStatus, isKeyboardEnter: $vm.isKeyboardEnter,  placeholder: "se_n_write_nickname".localized)
                    .onChange(of: vm.textNickname) { newValue in
                        
                        vm.isCheckUsable = false
                        
                        if vm.textNickname.count == 0 {
                            vm.correctStatus = .Check
                            vm.warning = "se_n_change_nickname_notice_2".localized
                        }
                        else {
                            if vm.textNickname.count >= 2, vm.textNickname.count <= 20 {
                                vm.correctStatus = .Correct
                                vm.warning = "se_n_change_nickname_notice_2".localized
                            }
                            else {
                                vm.correctStatus = .Wrong
                                vm.warning = "se_num_write_within".localized
                            }
                        }
                    }
                
                Button {
                    if vm.correctStatus == .Correct {
                        vm.requestCheckNickName(nickName: vm.textNickname)
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
                .background(vm.correctStatus == .Correct ? Color.stateActivePrimaryDefault.cornerRadius(sizeInfo.buttonCornerRadius) : Color.stateDisabledGray200.cornerRadius(sizeInfo.buttonCornerRadius))
                .padding(.leading, sizeInfo.padding)
                .disabled(vm.correctStatus == .Correct ? false : true)
            }
            .frame(maxWidth: .infinity)
            .frame(height: sizeInfo.inputHeight)
            .padding(.top, sizeInfo.padding)
            
            Text(vm.warning)
                .font(Font.caption21116Regular)
                .foregroundColor(.gray600)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, sizeInfo.padding5)
        }
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray25)
        
        .navigationType(leftItems: leftItems, rightItems: vm.isCheckUsable ? rightSaveItems : rightItems, leftItemsForegroundColor: .black, rightItemsForegroundColor: vm.isCheckUsable ? .primary500 : .gray300, title: "p_setting_profile".localized, onPress: { buttonType in
            
            //닉네임 수정.
            if buttonType == .Save {
                vm.requestUserInfoUpdate(userInfoType: .userNick, userNick: vm.textNickname) { success in
                    if success {
                        nickName = vm.textNickname
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        
        //onAppear
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .onAppear(perform: {
            vm.textNickname = nickName
        })
        
        //alert
        .showAlert(isPresented: $vm.showAlert, type: .Default, title: "", message: vm.alertMessage, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
        })
    }
}


//struct ChangeNickNamePage_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeNickNamePage()
//    }
//}
