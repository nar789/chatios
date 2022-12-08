//
//  BSCountryView.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/13.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

enum CountryBottomType: Int {
    case nonType
    case ClubOpen
}

struct BSCountryView: View {
    
    private struct sizeInfo {
        static let padding5: CGFloat = 5.0
        
        static let nonTypeHeaderBottomPadding: CGFloat = 15.0
        static let horizontalPadding: CGFloat = 20.0
        static let headerBottomPadding: CGFloat = 5.0
        static let headerTopPadding: CGFloat = 7.0
        static let headerDetailBottomPadding: CGFloat = 25.0
        
        
        static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
    }
    
    @Binding var isShow: Bool
    
    let selectedCountryCode: String
    let type: CountryBottomType
    let onPress: (CountryListData) -> Void
    
    @StateObject var vm = BSCountryViewModel()
    @StateObject var languageManager = LanguageManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("g_select_country".localized)
                .font(Font.title5Roboto1622Medium)
                .foregroundColor(Color.gray870)
                .padding(.bottom, type == .nonType ? sizeInfo.nonTypeHeaderBottomPadding : sizeInfo.headerBottomPadding)
            
            if type == .ClubOpen {
                Text("se_g_recommend_club_for_nation_user".localized)
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray600)
                .padding(.top, sizeInfo.headerTopPadding)
                .padding(.bottom, sizeInfo.headerDetailBottomPadding)
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(vm.countryList, id: \.self) { item in
                        BSCountryRow(obj: item, selectedCountryCode: selectedCountryCode) { obj in
                            isShow = false
                            onPress(obj)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, sizeInfo.horizontalPadding)
        .onAppear {
            vm.requestCountryList()
        }
    }
}

struct BSCountryRow: View {
    
    let obj: CountryListData
    let selectedCountryCode: String
    let onPress: (CountryListData) -> Void
    
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
                    
                    if selectedCountryCode == obj.iso2 {
                        Text(languageManager.getLanguageCode() == "ko" ? obj.nameKr : obj.nameEn)
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
                        Text(languageManager.getLanguageCode() == "ko" ? obj.nameKr : obj.nameEn)
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
