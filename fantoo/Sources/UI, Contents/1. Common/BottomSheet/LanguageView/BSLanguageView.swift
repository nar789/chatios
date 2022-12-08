//
//  BSLanguageView.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/05.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI


enum LangBottomType: Int {
    case nonType
    case ClubOpen
}

struct BSLanguageView: View {
    
    private struct sizeInfo {
        static let padding5: CGFloat = 5.0
        static let nonTypeHeaderBottomPadding: CGFloat = 15.0
        static let headerBottomPadding: CGFloat = 5.0
        static let headerTopPadding: CGFloat = 7.0
        static let headerDetailBottomPadding: CGFloat = 25.0
        static let horizontalPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
    }
    
    @Binding var isShow: Bool
    @Binding var selectedLangName: String
    var selectedLangCode: String = ""
    var isChangeAppLangCode: Bool = false       //주 언어 변경시만
    let type: LangBottomType
    let onClick: (String) -> Void
    
    @StateObject var vm = BSLanguageViewModel()
    @StateObject var languageManager = LanguageManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("b_select_trans_language".localized)
                .font(Font.title5Roboto1622Medium)
                .foregroundColor(Color.gray870)
                .padding(.bottom, type == .nonType ? sizeInfo.nonTypeHeaderBottomPadding : sizeInfo.headerBottomPadding)
            
            if type == .ClubOpen {
                Text("se_g_recommend_club_for_language_user".localized)
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray600)
                .padding(.top, sizeInfo.headerTopPadding)
                .padding(.bottom, sizeInfo.headerDetailBottomPadding)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    let langList = vm.languageList ?? nil
                    if langList != nil {
                        ForEach(langList!, id: \.self) { item in
                            BSLanguageRow(obj: item, selectedLangCode: selectedLangCode) { obj in
                                print("\n--- select language -------------------\nname : \(obj.name)\ncode : \(obj.langCode)\n")
                                
                                if !isChangeAppLangCode {
                                    languageManager.setLanguageCode(code: obj.langCode)
                                }
                                selectedLangName = obj.name
                                onClick(obj.langCode)
                                
                                isShow = false
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, sizeInfo.horizontalPadding)
        .onAppear {
            vm.getLanguageList()
        }
    }
}

struct BSLanguageRow: View {
    
    let obj: LanguageListData
    var selectedLangCode: String = ""
    let onPress: (LanguageListData) -> Void
    
    @StateObject var languageManager = LanguageManager.shared
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 40.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    var body: some View {
        HStack {
            Button {
                onPress(obj)
            } label: {
                
                HStack {
                    if obj.langCode == selectedLangCode {
                        Text(obj.name)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.primary500)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        
                        Spacer().frame(maxWidth: .infinity)
                        
                        Image("icon_fill_check")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(Color.primary500)
                            .frame(width: sizeInfo.iconSize.width, height: sizeInfo.iconSize.height)
                    }
                    else {
                        Text(obj.name)
                            .font(Font.body21420Regular)
                            .foregroundColor(Color.gray850)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }.modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
    }
}
