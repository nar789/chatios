//
//  ClubLeavePage.swift
//  fantoo
//
//  Created by mkapps on 2022/06/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubLeavePage: View {

    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let padding15: CGFloat = 15.0
        static let padding20: CGFloat = 20.0
        static let surmmaryEdgeInsets: EdgeInsets = EdgeInsets(top: 14.0, leading: 18.0, bottom: 14.0, trailing: 18.0)
        static let surmmaryCornerRadius: CGFloat = 12.0
        
        static let iconSize: CGFloat = 24.0
        
        static let buttonHeight: CGFloat = 42.0
    }
    
    @State var isChecked: Bool = false
    
    @State var showClubLeave: Bool = false
    
    @State var showAlertLeave: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("se_j_really_leave".localized)
                .font(Font.title32028Bold)
                .foregroundColor(Color.stateEnableGray900)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, sizeInfo.padding)
                .padding(.bottom, sizeInfo.padding20)
            
            Text("se_t_check_info_when_withdraw".localized)
                .font(Font.body21420Regular)
                .foregroundColor(Color.gray850)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, sizeInfo.padding15)
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("s_delete".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray900)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("j_delete_my_profile_info".localized)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray700)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("b_storage_etc".localized)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray700)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, sizeInfo.padding)
                    
                    Text("a_maintain".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray900)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("n_keep_my_post_2".localized)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray700)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(sizeInfo.surmmaryEdgeInsets)
            }
            .background(Color.bgLightGray50.cornerRadius(sizeInfo.surmmaryCornerRadius))
            
            Spacer().frame(maxHeight: .infinity)
            
            Button {
                isChecked.toggle()
            } label: {
                HStack(spacing: 0) {
                    Image(isChecked ? "Checkbox_login_checked" : "Checkbox_login_unchecked")
//                        .renderingMode(.template)
                        .resizable()
                        .frame(width: sizeInfo.iconSize, height: sizeInfo.iconSize, alignment: .leading)
                        .padding(.trailing, sizeInfo.padding)
//                            .padding([.trailing], DefineSize.Contents.HorizontalPadding)
                    
                    Text("se_j_agree_delete_retention_info".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray870)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, sizeInfo.padding20)
            }

            
            Button("k_club_leave".localized) {
                showAlertLeave = true
            }
            .buttonStyle(.borderless)
            .font(Font.buttons1420Medium)
            .foregroundColor(Color.gray25)
            .frame(maxWidth: .infinity)
            .frame(height: sizeInfo.buttonHeight)
            .background(isChecked ? Color.stateActivePrimaryDefault : Color.stateDisabledGray200)
            .cornerRadius(sizeInfo.buttonHeight/2)
            .disabled(!isChecked)
            .padding(.bottom, DefineSize.Contents.BottomPadding)
        }
        .padding(.top, DefineSize.Contents.TopPadding)
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .background(Color.gray25)
        
        .showAlert(isPresented: $showAlertLeave, type: .Default, title: "k_club_leave".localized, message: "se_t_sure_want_withdraw".localized, buttons: ["t_do_leave".localized, "t_cancel_leave".localized], onClick: { index in
            print("alert clicked : \(index)")
        })
        
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "k_club_leave".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
}


struct ClubLeavePage_Previews: PreviewProvider {
    static var previews: some View {
        ClubLeavePage()
    }
}

