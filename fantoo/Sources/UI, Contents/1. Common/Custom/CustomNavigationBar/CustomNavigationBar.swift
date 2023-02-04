//
//  NaviTop.swift
//  fantoo
//
//  Created by 김홍필 on 2022/04/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

enum CustomNavigationBarButtonType: Int {
    case None
    case Back
    case AlertBack
    case Close
    case Present
    case AlarmOff
    case AlarmOn
    case Setting
    case ClubSetting
    case Logo
    case Search
    case Profile
    case MarkActive
    case MarkInActive
    case More
    case Tooltip
    case Like
    case UnLike
    case Trans
    case TransOn
    case TransOff
    case UnSave
    case Save
    case Cancel
    case Next
    case Done
    case Register
    case PurpleDone
    case FanitImage
    case Fanit
    case Plus
    case Home
    case AlertAllRead
    
    func isTextButton() -> Bool {
        switch self {
        case .UnSave:
            return true
        case .Save:
            return true
        case .Cancel:
            return true
        case .Next:
            return true
        case .Done:
            return true
        case .Register:
            return true
        case .PurpleDone:
            return true
        case .Fanit:
            return true
        case .AlertAllRead:
            return true
            
        default: return false
        }
    }
    
    func getText() -> String {
        switch self {
        case .UnSave:
            return "j_save".localized
        case .Save:
            return "j_save".localized
        case .Cancel:
            return "c_cancel".localized
        case .Next:
            return "d_next".localized
        case .Done:
            return "a_done".localized
        case .Register:
            return "d_registration".localized
        case .PurpleDone:
            return "a_done".localized
        case .Fanit:
            return "1,974"
        case .AlertAllRead:
            return "모두 읽음"
            
        default: return ""
        }
    }
    
    func getTextForegroundColor() -> Color? {
        switch self {
        case .UnSave:
            return .gray300
        case .Save:
            return .gray800
        case .Cancel:
            return .gray800
        case .Next:
            return .gray300
        case .Done:
            return .gray800
        case .Register:
            return .stateEnableGray400
        case .PurpleDone:
            return .stateActivePrimaryDefault
        case .Fanit:
            return .gray850
        case .AlertAllRead:
            return .primary500
            
        default: return nil
        }
    }
    
    func isClickable() -> Bool {
        switch self {
        case .UnSave:
            return false
            
        default: return true
        }
    }
    
    func getImageString() -> String {
        switch self {
        case .Back:
            return "icon_outline_back"
        case .AlertBack:
            return "icon_outline_back"
        case .Close:
            return "icon_outline_cancel"
        case .Present:
            return "icon_outline_present"
        case .AlarmOff:
            return "icon_outline_alarm_off"
        case .AlarmOn:
            return "icon_outline_alarm"
        case .Setting:
            return "icon_outline_setting"
        case .ClubSetting:
            return "outlineIconOutlineSetting"
        case .Logo:
            return "bi_fantoo"
        case .Search:
            return "icon_outline_search"
        case .Profile:
            return "icon_outline_storagebox"
        case .MarkActive:
            return "icon_fill_bookmark-1"
        case .MarkInActive:
            return "icon_outline_favorite"
        case .More:
            return "icon_outline_more"
        case .Tooltip:
            return "icon_fill_tooltip"
        case .Like:
            return "icon_fill_bookmark"
        case .UnLike:
            return "icon_fill_bookmark"
        case .Trans:
            return "icon_outline_translate"
        case .TransOn:
            return "icon_outline_translate1"
        case .TransOff:
            return "icon_outline_translate1"
        case .FanitImage:
            return "fanit_default"
        case .Plus:
            return "icon_outline_plus"
        case .Home:
            return "icon_outline_home_n"
        default:
            return ""
        }
    }
    
    func getImageForegroundColor() -> Color? {
        switch self {
        case .Like:
            return .stateActiveSecondaryDefault
        case .UnLike:
            return .stateDisabledGray200
        case .FanitImage:
            return .green
        case .TransOn:
            return .primary500
        default: return nil
        }
    }
    
    func getImageSize() -> CGSize {
        switch self {
        case .Logo:
            return CGSize(width: 118, height: 22)
        default:
            return CGSize(width: 28, height: 28)
        }
    }
}

struct CustomNavigationBar: ViewModifier {
    let leftItems: [CustomNavigationBarButtonType]
    let rightItems: [CustomNavigationBarButtonType]
    
    let leftItemsForegroundColor: Color
    let rightItemsForegroundColor: Color
    let bookmarkForegroundColor: Color

    let title: String
    
    let isShowSearchBar: Bool
    var placeholder: String = ""
    @Binding var searchText: String
    @Binding var isKeyboardEnter: Bool
    
    let onPress: (CustomNavigationBarButtonType) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitle(" ", displayMode: .inline)
            .navigationBarItems(
                leading: HStack(spacing: 0) {
                    if isShowSearchBar {
                        CustomTextField(text: $searchText, correctStatus: .constant(.Check), isKeyboardEnter: $isKeyboardEnter, placeholder: placeholder, type: .Search)
                            .frame(width: DefineSize.Screen.Width - 80, height: 35, alignment: .center)
                            .animation(.spring())
                    }
                    else {
                        ForEach(leftItems, id: \.self) { item in
                            if item == .Back || item == .Close {
                                if self.presentationMode.wrappedValue.isPresented {
                                    CustomNavigationButton(type: item, foregroundColor: leftItemsForegroundColor) { buttonType in
                                        self.presentationMode.wrappedValue.dismiss()
                                        onPress(buttonType)
                                    }
                                }
                            }
                            else {
                                CustomNavigationButton(type: item, foregroundColor: leftItemsForegroundColor) { buttonType in
                                    onPress(buttonType)
                                }
                            }
                        }
                    }
                    
                    if isShowSearchBar {
                    }
                    else {
                        if title.count > 0 {
                            Text(title)
                                .foregroundColor(.gray900)
                                .font(Font.title41824Medium)
                                .frame(width: 190, alignment: .leading)
    //                            .padding(EdgeInsets(top: 0, leading: -30, bottom: 0, trailing: 0))
                        }
                    }
                    
                },
                trailing: HStack(spacing: 0) {
                    if isShowSearchBar {
                        CustomNavigationButton(type: .Cancel, foregroundColor: rightItemsForegroundColor) { buttonType in
                            onPress(buttonType)
                        }
                    }
                    else {
                        ForEach(rightItems, id: \.self) { item in
                            CustomNavigationButton(type: item, foregroundColor: rightItemsForegroundColor, bookmarkForegroundColor: bookmarkForegroundColor) { buttonType in
                                onPress(buttonType)
                            }
                        }
                    }
                }
            )
            .navigationBarBackButtonHidden(true)
    }
}

extension View {
    func navigationType(
        leftItems:[CustomNavigationBarButtonType] = [],
        rightItems:[CustomNavigationBarButtonType] = [],
        isShowSearchBar:Bool = false,
        searchText:Binding<String> = .constant(""),
        isKeyboardEnter:Binding<Bool> = .constant(false),
        placeholder:String = "",
        leftItemsForegroundColor: Color,
        rightItemsForegroundColor: Color,
        bookmarkForegroundColor: Color = Color.black,
        title: String,
        onPress: @escaping (CustomNavigationBarButtonType) -> Void) -> some View {
            modifier(CustomNavigationBar(leftItems: leftItems, rightItems: rightItems, leftItemsForegroundColor: leftItemsForegroundColor, rightItemsForegroundColor: rightItemsForegroundColor, bookmarkForegroundColor: bookmarkForegroundColor, title: title, isShowSearchBar: isShowSearchBar, placeholder: placeholder, searchText: searchText, isKeyboardEnter: isKeyboardEnter, onPress: onPress))
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                Text("navigation bar custom")
                
                    .navigationType(leftItems: [.Back], rightItems: [.Setting, .Search], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "".localized, onPress: { buttonType in
                        print("onPress buttonType : \(buttonType)")
                    })
            }
        }
    }
}
