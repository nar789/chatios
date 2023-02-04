//
//  PushAlarmPage.swift
//  fantoo
//
//  Created by fns on 2022/06/03.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import BottomSheet

struct PushAlarmPage: View {
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = SettingViewModel()
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellTop: CGFloat = 14.0
        static let cellLeadingPadding: CGFloat = 20.0
        static let cellBottomPadding: CGFloat = 5.0
        static let cellTrailingPadding: CGFloat = 16.0
        static let cellTopPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    @State var showList = false
    @State var leftItems: [CustomNavigationBarButtonType] = []
    @State var rightItems: [CustomNavigationBarButtonType] = [.UnLike]
    @State private var shouldShowSetting = false
    
    @State private var showCommunityAlarmPage = false
    //    @State private var showFirstPage = false
    @AppStorage("showFirstPage") var showFirstPage = false
    @AppStorage("showSecondPage") var showSecondPage = false
    @AppStorage("showThirdPage") var showThirdPage = false
    @AppStorage("showForthPage") var showForthPage = false
    @AppStorage("showFifthPage") var showFifthPage = false
    
    @State var toggleIsOn: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    
                    Text("k_community".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.primary500)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: 0))
                    
                    
                    PushAlarmListToggleView(text: "k_community".localized, textAlarm: "a_notification".localized, position: .Community, showLine: true, clubId: .constant(0), toggleIsOn: $vm.communityAgree) {
                        showCommunityAlarmPage = true
                    }
                    
                    Text("k_club".localized)
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.primary500)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: 0))
                    
                    ForEach($vm.alimClubConfigDtoList, id: \.self) { $alimClubConfigDtoList in
                        PushAlarmListToggleView(text: alimClubConfigDtoList.clubName, textAlarm: "a_notification".localized, position: .Club, showLine: true, clubId: $alimClubConfigDtoList.clubId, toggleIsOn: $alimClubConfigDtoList.clubAgree) {
                            showCommunityAlarmPage = true
                        }
                    }
                }
            }
            .modifier(ScrollViewLazyVStackModifier())
        }
        .onAppear(perform: {
            vm.requestAlim(integUid: UserManager.shared.uid)
            
        })
        
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "p_setting_push_alarm".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
}

struct PushAlarmPage_Previews: PreviewProvider {
    static var previews: some View {
        PushAlarmPage()
    }
}


//struct PushAlarmPage_RowView: View {
//
//    @State var bookmarkImageToggle = false
//
//    let index: Int
//    let element: AlimClubConfigDtoList
//    var viewModel = SettingViewModel()
//
//    @StateObject var languageManager = LanguageManager.shared
//    @StateObject var vm = SettingViewModel()
//
//    enum SettingListPosition: Int {
//        case Community
//        case Club
//    }
//
//    let text: String
//    let textAlarm: String
//    let position: SettingListPosition
//    let showLine: Bool
//    @Binding var toggleIsOn: Bool
//
//
//    private struct sizeInfo {
//        static let padding: CGFloat = 10.0
//        static let cellHeight: CGFloat = 50.0
//        static let cellPadding: CGFloat = 20.0
//        static let iconSize: CGSize = CGSize(width: 17, height: 16)
//    }
//
//    let onPress: () -> Void
//    var body: some View {
//        ZStack {
//            //            if position == .Community {
//            //            HStack() {
//            //                Text("\(text) ")
//            //                    .font(Font.buttons1420Medium)
//            //                    .foregroundColor(Color.gray870)
//            //                + Text(textAlarm)
//            //                    .font(Font.body21420Regular)
//            //                    .foregroundColor(Color.gray870)
//            //
//            //                Spacer()
//            //
//            //                Button(
//            //                    action: {
//            //                        onPress()
//            //                        vm.requestComAlimSetting(alimType: .COMMUNITY, integUid: UserManager.shared.uid) { success in
//            //                            if success {
//            //                                vm.communityAgree = toggleIsOn
//            //                            }
//            //                        }
//            //                    },
//            //                    label: {
//            //
//            //                        Toggle(isOn: $toggleIsOn, label: {
//            //                        })
//            //                            .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
//            //                            .frame(width: 48, height: 24, alignment: .trailing)
//            //                            .padding([.vertical], 12)
//            //                    }
//            //                )
//            //                    .buttonStyle(.borderless)
//            //            }
//            //            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            //            .padding(.horizontal, sizeInfo.cellPadding)
//            //            } else if position == .Club {
//            HStack() {
//                Text("\(text) ")
//                    .font(Font.buttons1420Medium)
//                    .foregroundColor(Color.gray870)
//                + Text(textAlarm)
//                    .font(Font.body21420Regular)
//                    .foregroundColor(Color.gray870)
//
//                Spacer()
//
//                Button(
//                    action: {
//                        onPress()
//                        print("@@@@@\(element.clubId)")
//                        viewModel.requestClubAlimSetting(alimType: .CLUB, integUid: UserManager.shared.uid, clubId: "\(element.clubId)") { success in
//                            if success {
//                                vm.clubAgree = toggleIsOn
//                            }
//                        }
//                    },
//                    label: {
//
//                        Toggle(isOn: $toggleIsOn, label: {
//                        })
//                            .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
//                            .frame(width: 48, height: 24, alignment: .trailing)
//                            .padding([.vertical], 12)
//                    }
//                )
//                    .buttonStyle(.borderless)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//            .padding(.horizontal, sizeInfo.cellPadding)
//
//
//            if showLine {
//                ExDivider(color: .bgLightGray50, height: 1)
//                    .frame(height: DefineSize.LineHeight, alignment: .bottom)
//                    .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading:0, bottom: 0, trailing: 0))
//            }
//        }
//        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
//    }
//}
