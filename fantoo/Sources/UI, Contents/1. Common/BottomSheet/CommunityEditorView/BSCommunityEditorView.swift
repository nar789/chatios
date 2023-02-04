//
//  BSCommunityView.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

enum BSCommunityEditorViewType: Int {
    case MainCategory
    case SubCategory
}

struct BSCommunityEditorView: View {
    
    private struct sizeInfo {
        static let padding5: CGFloat = 5.0
        static let headerBottomPadding: CGFloat = 15.0
        static let horizontalPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
    }
    
    let viewType: BSCommunityEditorViewType
    var memberRecogCategoryList: [CategoryList_CategoryFantooMember]?
    var memberSubCategoryList: [CategoryList_SubcategoryMember]?
    @Binding var isShow: Bool
    @Binding var selectedName: String
    @Binding var selectedCategoryCode: String
    @StateObject var vm = BSLanguageViewModel()
    @StateObject var languageManager = LanguageManager.shared
    
    /**
     * 언어팩 등록할 것
     */
    private let BStitle = "게시판 선택"
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(BStitle)
                .font(.title51622Medium)
                .foregroundColor(.stateEnableGray900)
            
            Group {
                if viewType == .MainCategory {
                    memberRecogCategoryView
                }
                else if viewType == .SubCategory {
                    memberSubCategory
                }
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(.horizontal, sizeInfo.horizontalPadding)
    }
    
    var memberRecogCategoryView: some View {
        VStack(spacing: 15) {
            if let NOmemberRecogCategoryList = memberRecogCategoryList {
                ForEach(Array(NOmemberRecogCategoryList.enumerated()), id: \.offset) { index, element in
                    
                    BSCommunityEditorRow(
                        viewType: BSCommunityEditorViewType.MainCategory,
                        memberRecogCategory: element,
                        selectedName: selectedName,
                        onPressRecogCategory: { item in
                            //print("idpilLog::: item : \(item)" as String)
                            
                            selectedName = item.codeNameKo
                            selectedCategoryCode = item.code
                            isShow = false
                    })
                }
            }
        }
    }
    
    var memberSubCategory: some View {
        VStack(spacing: 15) {
            if let NOmemberSubCategoryList = memberSubCategoryList {
                ForEach(Array(NOmemberSubCategoryList.enumerated()), id: \.offset) { index, element in
                    
                    BSCommunityEditorRow(
                        viewType: BSCommunityEditorViewType.SubCategory,
                        memberSubCategory: element,
                        selectedName: selectedName,
                        onPressSubCategory: { item in
                            //print("idpilLog::: item : \(item)" as String)
                            
                            selectedName = item.codeNameKo
                            selectedCategoryCode = item.code
                            isShow = false
                    })
                }
            }
        }
    }
    
}

struct BSCommunityEditorRow: View {
    let viewType: BSCommunityEditorViewType
    var memberRecogCategory: CategoryList_CategoryFantooMember?
    var memberSubCategory: CategoryList_SubcategoryMember?
    var selectedName: String = ""
    var onPressRecogCategory: ((CategoryList_CategoryFantooMember) -> Void)?
    var onPressSubCategory: ((CategoryList_SubcategoryMember) -> Void)?
    
    @StateObject var languageManager = LanguageManager.shared
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellHeight: CGFloat = 40.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    var body: some View {
        HStack {
            if viewType == .MainCategory {
                mainCategoryBtn
            }
            else if viewType == .SubCategory {
                subCategoryBtn
            }
        }
    }
    
    var mainCategoryBtn: some View {
        Group {
            if let NOmemberRecogCategory = memberRecogCategory {
                Button {
                    if let NOonPressRecogCategory = onPressRecogCategory {
                        NOonPressRecogCategory(NOmemberRecogCategory)
                    }
                } label: {
                    HStack {
                        Text(NOmemberRecogCategory.codeNameKo)
                            .font(Font.body11622Regular)
                            .foregroundColor(NOmemberRecogCategory.codeNameKo == selectedName ? Color.primaryDefault : Color.gray800)
                        
                        Spacer()
                        
                        if NOmemberRecogCategory.codeNameKo == selectedName {
                            Image("icon_fill_check")
                                .renderingMode(.template)
                                .foregroundColor(Color.primaryDefault)
                        }
                    }
                    .frame(height: 24)
                }
            }
        }
    }
    
    var subCategoryBtn: some View {
        Group {
            if let NOmemberSubCategory = memberSubCategory {
                Button {
                    if let NOonPressSubCategory = onPressSubCategory {
                        NOonPressSubCategory(NOmemberSubCategory)
                    }
                } label: {
                    HStack {
                        Text(NOmemberSubCategory.codeNameKo)
                            .font(Font.body11622Regular)
                            .foregroundColor(NOmemberSubCategory.codeNameKo == selectedName ? Color.primaryDefault : Color.gray800)
                        
                        Spacer()
                        
                        if NOmemberSubCategory.codeNameKo == selectedName {
                            Image("icon_fill_check")
                                .renderingMode(.template)
                                .foregroundColor(Color.primaryDefault)
                        }
                    }
                    .frame(height: 24)
                }
            }
        }
    }
}

