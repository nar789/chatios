//
//  SettingListLinkView.swift
//  fantoo
//
//  Created by fns on 2022/07/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct SettingListLinkView: View {
    @StateObject var languageManager = LanguageManager.shared
    enum TestAccountLinkViewType: Int {
        case Default
        case ClickAll
        case ClickAllWithArrow
        case ClickAllWithTextAndArrow
        case ClickRight
        case ClickRightWithArrow
        case ClickToggle
        case ClickLanguage
        case ClickUpdate
        case ClickAccount
    }
    
    let text: String
    let subText: String
    let lang: String
    let type: TestAccountLinkViewType
    let showLine: Bool
    let onPress: () -> Void
    @State var imageToggle: Bool = false
    @State var showAlert: Bool = false
//    @State var toggleIsOn: Bool = false
    @State var textId: String = ""
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 48.0
        static let cellPadding: CGFloat = 16.0
        static let iconSize: CGSize = CGSize(width: 16, height: 16)
        static let textSize: CGSize = CGSize(width: 20, height: 16)
        static let toggleSize: CGSize = CGSize(width: 40, height: 16)
        static let updateSize: CGSize = CGSize(width: 70, height: 24)
        static let idIconSize: CGSize = CGSize(width: 24, height: 24)
        static let idSize: CGSize = CGSize(width: 200, height: 20)
    }
    
    @AppStorage("toggleIsOn") var toggleIsOn = false

    var body: some View {
        ZStack {
            if type == .Default || type == .ClickAll || type == .ClickAllWithArrow || type == .ClickAllWithTextAndArrow {
                Button(
                    action: {
                        onPress()
                    },
                    label: {
                        HStack(spacing: 0) {
                            Text(text)
                                .font(Font.body21420Regular)
                                .foregroundColor(Color.gray870)
                                .padding([.leading], sizeInfo.cellPadding)
                                .padding([.trailing], sizeInfo.padding)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            
                            Text(subText)
                                .font(Font.caption11218Regular)
                                .foregroundColor(Color.gray500)
                                .padding([.leading], sizeInfo.cellPadding)
                                .padding([.trailing], type == .ClickAllWithArrow ? sizeInfo.padding : sizeInfo.cellPadding)
                                .fixedSize(horizontal: true, vertical: true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                            
                            if type == .ClickAllWithArrow {
                                Image("icon_outline_go")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height, alignment: .trailing)
                                    .padding([.trailing], sizeInfo.cellPadding)
                                    .foregroundColor(.stateEnableGray200)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
                    .buttonStyle(.borderless)
                    .disabled(type == .Default ? true : false)
            }
            else {
                HStack(spacing: 0) {
                    Text(text)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray870)
                        .padding([.leading], sizeInfo.cellPadding)
                        .padding([.trailing], sizeInfo.padding)
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    
                    Button(
                        action: {
                            onPress()
                        },
                        label: {
                            HStack(spacing: 0) {
                                Text(subText)
                                    .font(Font.caption11218Regular)
                                    .foregroundColor(Color.gray500)
                                    .padding([.leading], sizeInfo.cellPadding)
                                    .padding([.trailing], type == .ClickRightWithArrow ? sizeInfo.padding : sizeInfo.cellPadding)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                                
                                if type == .ClickRightWithArrow {
                                    Image("icon_outline_go")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height, alignment: .trailing)
                                        .padding([.trailing], sizeInfo.cellPadding)
                                        .foregroundColor(.stateEnableGray200)
                                }
                                
                                if type == .ClickToggle {
                                   
                                    Toggle(isOn: $toggleIsOn, label: {
                                    })
                                        .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
//                                        .frame(width: sizeInfo.toggleSize.width, height: sizeInfo.toggleSize.height, alignment: .center)
                                        .padding([.trailing], sizeInfo.cellPadding)
                                        .onChange(of: toggleIsOn) { value in
                                                       // action...
                                                       print(value)
                                            if value {
                                                showAlert = true
                                            }
                                                   }
                                }
                                if type == .ClickLanguage {
                                    Text(lang)
                                        .font(Font.body21420Regular)
                                        .foregroundColor(Color.primary500)
                                        .fixedSize(horizontal: true, vertical: true)
                                        .frame(width: sizeInfo.textSize.width, height: sizeInfo.textSize.height, alignment: .trailing)
                                        .padding([.trailing], sizeInfo.cellPadding)
                                }
                                if type == .ClickAccount {
                                    HStack {
                                        Image("btn_logo_\(UserManager.shared.loginType)")
                                            .resizable()
                                            .frame(width: sizeInfo.idIconSize.width, height: sizeInfo.idIconSize.height, alignment: .trailing)
//                                        Text(textId)
                                        Text(verbatim: UserManager.shared.account)
                                            .foregroundColor(Color.gray400)
                                            .font(Font.body21420Regular)
                                    }
                                    .frame(width: sizeInfo.idSize.width, height: sizeInfo.idSize.height, alignment: .trailing)
                                    .padding([.trailing], sizeInfo.cellPadding)
                                }
                                if type == .ClickUpdate {
                                    ZStack {
                                        Capsule()
                                            .fill(imageToggle ? Color.gray200 : Color.primary100)
                                            .frame(width: sizeInfo.updateSize.width, height: sizeInfo.updateSize.height, alignment: .trailing)
                                        
                                        Text("a_update".localized)
                                            .font(Font.body21420Regular)
                                            .foregroundColor(imageToggle ? Color.gray25 : Color.primary600)
//                                            .background(imageToggle ? Color.gray200 : Color.primary100)
                                        
                                    }
                                    .padding([.leading], 10)
                                    .padding([.trailing], sizeInfo.cellPadding)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    )
                        .buttonStyle(.borderless)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            
            if showLine {
                ExDivider(color: .bgLightGray50, height: 1)
//                    .frame(height: DefineSize.LineHeight, alignment: .bottom)
                    .frame(height: DefineSize.LineHeight)
                    .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading:0, bottom: 0, trailing: 0))
            }
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
        .showAlert(isPresented: $showAlert, type: .DateAlert, title: "g_advertisement_alarm".localized, message: "팬투 마케팅 정보 수신에 동의하셨습니다.", detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
            
        })
    }
}

struct SettingListLinkView_Previews: PreviewProvider {
    static var previews: some View {
        SettingListLinkView(text: "title", subText: "sub", lang: "", type: .ClickRight, showLine: true, onPress: {
        })
            .previewLayout(.sizeThatFits)
    }
}
