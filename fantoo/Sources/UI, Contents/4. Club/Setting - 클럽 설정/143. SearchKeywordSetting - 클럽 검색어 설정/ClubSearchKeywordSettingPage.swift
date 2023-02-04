//
//  ClubSearchKeywordSettingPage.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/06/30.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ClubSearchKeywordSettingPage: View {
    
    @StateObject var languageManager = LanguageManager.shared
    
    private struct sizeInfo {
        static let padding10: CGFloat = 10.0
        static let padding15: CGFloat = 15.5
        static let padding16: CGFloat = 16.0
        static let padding20: CGFloat = 20.0
        static let textSpacerHeight: CGFloat = 16.0
        static let textFieldHeight: CGFloat = 42.0
        
        static let tagHeight: CGFloat = 32.0
        static let tagLineWidth: CGFloat = 2.0
        static let tagWidthPadding: CGFloat = 40.0
        static let spacing: CGFloat = 4.0
        static let tagCornerRadius: CGFloat = 15.0
        static let tagCancelIconSize: CGSize = CGSize(width: 12, height: 12)
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var vm = ClubSearchHashtagViewModel()

    @State var leftItems: [CustomNavigationBarButtonType] = [.Back]
    @State var rightItems: [CustomNavigationBarButtonType] = [.Save]
    
    @State var rightItemsColorBlack: Color = .black
    @State var rightItemsColor: Color = .primary500
    
    @State private var keyword = ""
    @State private var addKeyword = ""
    @State private var limitTextCountAlert: Bool = false
    @State private var limitTagCountAlert: Bool = false
    @State private var limitTagTextAlert: Bool = false
    @State var lastName: String = ""
    @State var tags: [ClubSearchHashTag] = []
    @State var isKeyboardEnter: Bool = false
    @State var correctStatus:CheckCorrectStatus = .Check
    @State var isFirstResponder = true
    @State var rightItemState = false
    
    @Binding var clubId: String
    
    let fontSize: CGFloat = 16
    
//    @State var hashtags: [String] = []
    
    
    var body: some View {
        VStack{
            ExDivider(color: Color.gray50, height: 1)
            Spacer().frame(height: sizeInfo.padding15)
            VStack {
                HStack {
                    Text("se_k_keyword_for_search_club".localized)
                        .font(Font.body21420Regular)
                        .foregroundColor(Color.gray600)
                        .frame(alignment: .leading)
                        .frame(height: sizeInfo.textSpacerHeight)
                    Spacer()
                }
                Spacer().frame(height: sizeInfo.padding16)
                
                CustomKeyboardTextField(returnVal: .done,
                                        placeholder: "a_space_after_input".localized,
                                        tag: 0,
                                        text: $keyword,
                                        isfocusAble: .constant([false]),
                                        isFirstResponder: true,
                                        onCommit: {
                    if keyword.count > 0 && vm.tagList.count < 10 && keyword.validateHashTag() {
                        appendList()
                    }
                    else if !keyword.validateHashTag() {
                        self.limitTagTextAlert.toggle()
                    }
                    else {
                        keyword = ""
                        self.limitTagCountAlert.toggle()
                    }
                })
                    .frame(height: sizeInfo.textFieldHeight)
                    .onReceive(keyword.publisher.collect()) {
                        self.keyword = String($0.prefix(15))
                    }
                    .onChange(of: keyword) { newValue in
                        if keyword.count > 14 {
                            self.limitTextCountAlert.toggle()
                        }
                        set(name: keyword)
                    }
                Spacer().frame(height: sizeInfo.padding20)
                if vm.hashtagList.count > 0 {
//                    appendHashtagList()
                }
                clubSearchHashTagView
                
                Spacer()
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        }
        
        .modifier(ScrollViewLazyVStackModifier())
        .background(Color.gray25)
        .navigationType(leftItems: leftItems, rightItems: rightItems, leftItemsForegroundColor: .black, rightItemsForegroundColor: rightItemState ? rightItemsColor : rightItemsColorBlack, title: "k_club_search_keyword_settings".localized, onPress: { buttonType in
            if buttonType == .Save && rightItemState {
                
                vm.requestClubAddHashtag(clubId: clubId, hashtagList: vm.hashtagList, integUid: UserManager.shared.uid) { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
                        print("태그 저장")
                    }
                }
            }
        })
        .navigationBarBackground {
            Color.gray25
        }
//        .statusBarStyle(style: .darkContent)
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .onAppear {
            vm.requestClubHashtag(clubId: clubId, integUid: UserManager.shared.uid) { success in
                if success {
                }
            }
        }
        .popup(isPresenting: $limitTagTextAlert, cornerRadius: 5, locationType: .middle, autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text("se_h_tag_cannot_contain".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            //                        .multilineTextAlignment(.center)
                .background(Color.gray800)
        }
               
        )
        .popup(isPresenting: $limitTagCountAlert, cornerRadius: 5, locationType: .middle, autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text("se_k_club_keyword_count".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            //                        .multilineTextAlignment(.center)
                .background(Color.gray800)
        }
               
        )
        .popup(isPresenting: $limitTextCountAlert, cornerRadius: 5, locationType: .middle, autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text("se_k_club_keyword_length".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            //                        .multilineTextAlignment(.center)
                .background(Color.gray800)
        }
               
        )
        
    }
    
    var clubSearchHashTagView: some View {
        VStack(alignment: .leading) {
            
            ForEach(getRows(),id: \.self){ rows in
                HStack(spacing: sizeInfo.spacing) {
                    ForEach(rows){ row in
                        tagRowView(tag: row)
                    }
                }
            }
            .frame(width: DefineSize.Screen.Width - sizeInfo.tagWidthPadding, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .onChange(of: vm.tagList) { newValue in
            guard let last = vm.tagList.last else { return }
            let font = UIFont.systemFont(ofSize: fontSize)
            let attibutes = [NSAttributedString.Key.font: font]
            let size = (last.text as NSString).size(withAttributes: attibutes)
//            print(size)
            vm.tagList[getIndex(tag: last)].size = size.width
        }
    }
}

extension ClubSearchKeywordSettingPage {

    func appendList() {
        vm.tagList.append(ClubSearchHashTag(text: keyword))
        vm.hashtagList.append(keyword)
        keyword = ""
        compareTag()
    }
    
    func set(name: String) {
        if name.contains(" ") {
            keyword.remove(at: name.index(before: name.endIndex))
            if keyword.count > 0 && vm.tagList.count < 10 && keyword.validateHashTag() {
                appendList()
            }
            else if !keyword.validateHashTag() {
                limitTagTextAlert = true
            }
            else {
                keyword = ""
                limitTagCountAlert = true
            }
        } else {
//            print("Wrong value format")
        }
    }
    
    func RowView(tag: ClubSearchHashTag) {
        if keyword == tag.text {
            keyword = ""
        }
    }
    
    func tagRowView(tag: ClubSearchHashTag) -> some View {
        HStack {
            Text("#\(tag.text)")
                .font(Font.body21420Regular)
                .foregroundColor(Color.primary500)
            
            Button(
                action: {
                    deleteTag(getIndex(tag: tag))
                    deleteHashtag(element: tag.text)
                    compareTag()

                },
                label: {
                    Image("icon_outline_cancel")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.primary500)
                        .frame(width: sizeInfo.tagCancelIconSize.width, height: sizeInfo.tagCancelIconSize.height)
                }
            )
        }
        .padding(.horizontal, sizeInfo.padding10)
        .frame(height: sizeInfo.tagHeight)
        .buttonStyle(BorderlessButtonStyle())
        .overlay(RoundedRectangle(cornerRadius: sizeInfo.tagCornerRadius)
                    .stroke(Color.primary500, lineWidth: sizeInfo.tagLineWidth))
        .cornerRadius(sizeInfo.tagCornerRadius)
        .background(Color.gray25)
    }
    
    func getIndex(tag: ClubSearchHashTag) -> Int {
        let index = vm.tagList.firstIndex { currentTag in
            return tag.id == currentTag.id } ?? 0
        
        return index
    }
    
    func getRows()->[[ClubSearchHashTag]]{
        var rows: [[ClubSearchHashTag]] = []
        var currentRow: [ClubSearchHashTag] = []
        
        var totalWidth: CGFloat = 0
        let screenWidth: CGFloat = (DefineSize.Screen.Width - sizeInfo.tagWidthPadding) - sizeInfo.tagWidthPadding
        //        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
        
        vm.tagList.forEach { tag in
            totalWidth += (tag.size + sizeInfo.tagWidthPadding)
            if totalWidth > screenWidth {
                
                totalWidth = (!currentRow.isEmpty ? (tag.size + sizeInfo.tagWidthPadding) : 0)
                
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
                
            } else {
                currentRow.append(tag)
            }
        }
        if !currentRow.isEmpty {
            rows.append(currentRow)
            currentRow.removeAll()
        }
        return rows
    }
    
    func deleteTag(_ i: Int) {
        vm.tagList.remove(at: i)
    }

    func deleteHashtag(element: String) {
        if vm.hashtagList.contains(element) {
            vm.hashtagList = vm.hashtagList.filter{ $0 != element }
        }
    }
    
    func compareTag() {
        if vm.saveHashtagList != vm.hashtagList {
            rightItemState = true
        }
        else {
            rightItemState = false
        }
    }
}
