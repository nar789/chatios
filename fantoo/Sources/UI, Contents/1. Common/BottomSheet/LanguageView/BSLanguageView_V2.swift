//
//  BSLanguageView_V2.swift
//  fantoo
//
//  Created by kimhongpil on 2022/11/29.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct BSLanguageView_V2: View {
    
    private struct sizeInfo {
        static let padding5: CGFloat = 5.0
        static let headerTopPadding: CGFloat = 7.0
        static let headerDetailBottomPadding: CGFloat = 25.0
        static let horizontalPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
    }
    
    @Binding var isShow: Bool
    let onClick: (String) -> Void
    
    @StateObject var vm = BSLanguageViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    if let NOlanguageList = vm.languageList {
                        ForEach(NOlanguageList, id: \.self) { item in
                            
                            BSLanguageRow_V2(
                                obj: item
                            ) { obj in
                                print("\n--- select language -------------------\nname : \(obj.name)\ncode : \(obj.langCode)\n")
                                
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

struct BSLanguageRow_V2: View {
    
    let obj: LanguageListData
    let onPress: (LanguageListData) -> Void
    
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
                    Text(obj.name)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray850)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }.modifier(ListRowModifier(rowHeight: sizeInfo.cellHeight))
    }
}
