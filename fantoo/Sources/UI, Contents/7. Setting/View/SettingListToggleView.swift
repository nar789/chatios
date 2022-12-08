//
//  PushAlarmListToggleView.swift
//  fantoo
//
//  Created by fns on 2022/05/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import BottomSheet
import AttributedText

struct PushAlarmListToggleView: View {
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = SettingViewModel()
    enum SettingListPosition: Int {
        case Community
        case Club
    }
    
    let text: String
    let textAlarm: String
    let position: SettingListPosition
    let showLine: Bool
    @Binding var clubId: Int
    @Binding var toggleIsOn: Bool
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 50.0
        static let cellPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    let onPress: () -> Void
    
    var body: some View {
        ZStack {
            if position == .Community {
                HStack() {
                    Text("\(text) ")
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray870)
                    + Text(textAlarm)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray870)
                    
                    Spacer()
                    
                    Button(
                        action: {
                            onPress()
                            vm.requestComAlimSetting(alimType: .COMMUNITY, integUid: UserManager.shared.uid) { success in
                                if success {
                                    vm.communityAgree = toggleIsOn
                                }
                            }
                        },
                        label: {
                            
                            Toggle(isOn: $toggleIsOn, label: {
                            })
                                .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
                                .frame(width: 48, height: 24, alignment: .trailing)
                                .padding([.vertical], 12)
                        }
                    )
                        .buttonStyle(.borderless)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, sizeInfo.cellPadding)
            } else if position == .Club {
                HStack() {
                    Text("\(text) ")
                        .font(Font.buttons1420Medium)
                        .foregroundColor(Color.gray870)
                    + Text(textAlarm)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray870)
                    
                    Spacer()
                    
                    Toggle(isOn: $toggleIsOn.didSet { val in
                        vm.requestClubAlimSetting(alimType: .CLUB, integUid: UserManager.shared.uid, clubId: "\(clubId)") { success in
                            if success {
                                vm.clubAgree = toggleIsOn
                            }
                        }
                    }) {
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.primary300))
                    .frame(width: 48, height: 24, alignment: .trailing)
                    .padding([.vertical], 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, sizeInfo.cellPadding)
            }
            
            if showLine {
                ExDivider(color: .bgLightGray50, height: 1)
                    .frame(height: DefineSize.LineHeight, alignment: .bottom)
                    .padding(EdgeInsets(top: sizeInfo.cellHeight - DefineSize.LineHeight, leading:0, bottom: 0, trailing: 0))
            }
        }
        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
        
    }
}

struct PushAlarmListToggleView_Previews: PreviewProvider {
    static var previews: some View {
        PushAlarmListToggleView(text: "text", textAlarm: "알림", position: .Club, showLine: true, clubId: .constant(0), toggleIsOn: .constant(false), onPress: {
            
        })
            .previewLayout(.sizeThatFits)
    }
}

// langBottomView 인데 @AppStorage 사용 않고 바텀뷰에 체크 필요시 사용하면 됨 아니면 지움 22.11.04
//struct settingBSLanguageView: View {
//    @StateObject var languageManager = LanguageManager.shared
//    @StateObject var vm = BSLanguageViewModel()
//
//    let type: LangBottomType
//    @Binding var isShow: Bool
//    @Binding var selectedText: String
//    var isChangeAppLangCode: Bool = false       //주 언어 변경시만
//    let onPress: () -> Void
//
//    private struct sizeInfo {
//        static let titleBottomPadding: CGFloat = 14.0
//        static let padding: CGFloat = 32.0
//        static let padding5: CGFloat = 5.0
//
//        static let nonTypeHeaderBottomPadding: CGFloat = 15.0
//        static let headerBottomPadding: CGFloat = 5.0
//        static let headerTopPadding: CGFloat = 7.0
//        static let headerDetailBottomPadding: CGFloat = 25.0
//        static let horizontalPadding: CGFloat = 20.0
//
//        static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
//    }
//
//    var body: some View {
//
//        VStack(alignment: .leading, spacing: 0) {
//            Text("b_select_trans_language".localized)
//                .font(Font.title5Roboto1622Medium)
//                .foregroundColor(Color.gray870)
//                .padding(.bottom, type == .nonType ? sizeInfo.nonTypeHeaderBottomPadding : sizeInfo.headerBottomPadding)
//
//            if type == .ClubOpen {
//                Text("se_g_recommend_club_for_language_user".localized)
//                    .font(Font.caption11218Regular)
//                    .foregroundColor(Color.gray600)
//                    .padding(.top, sizeInfo.headerTopPadding)
//                    .padding(.bottom, sizeInfo.headerDetailBottomPadding)
//            }
//
//            ScrollView(showsIndicators: false) {
//                VStack(spacing: 0) {
//                    if let langList = vm.languageList ?? nil {
//                        ForEach(langList, id: \.self) { subTitle in
//                            settingBSLanguageRow(selectedTitle: $selectedText, subTitle: subTitle.name, onPress: {
//                                selectedText = subTitle.name
//                                isShow = false
//
//                                if !isChangeAppLangCode {
//                                    languageManager.setLanguageCode(code: subTitle.langCode)
//                                }
//
//                                onPress()
//                            })
//                        }
//                    }
//
//                    Spacer().frame(maxHeight: .infinity)
//                }
//            }
//        }
//        .padding(.horizontal, sizeInfo.horizontalPadding)
//        .onAppear {
//            vm.getLanguageList()
//        }
//
//    }
//}
//
//
//struct settingBSLanguageRow: View {
//
//    @Binding var selectedTitle: String
//    let subTitle: String
//    let onPress: () -> Void
//
//    private struct sizeInfo {
//        static let subTitleHeight: CGFloat = 80.0
//        static let bottomPadding: CGFloat = 14.0
//        static let iconSize: CGSize = CGSize(width: 17, height: 16)
//        static let padding: CGFloat = 10.0
//        static let cellHeight: CGFloat = 40.0
//    }
//
//    var body: some View {
//
//        HStack(spacing: 0) {
//            Button {
//                self.selectedTitle = self.subTitle
//                onPress()
//            } label: {
//                Text(subTitle)
//                    .font(Font.body21420Regular)
//                    .foregroundColor(subTitle == selectedTitle ? Color.primaryDefault : Color.gray800)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                Spacer()
//                Image(systemName: "checkmark")
//                    .foregroundColor(Color.primary300)
//                    .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
//                    .opacity( subTitle == selectedTitle ? 1 : 0)
//            }
//        }
//        .modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
//    }
//}
//
