//
//  ClubPostHeadTitlePage.swift
//  fantoo
//
//  Created by fns on 2022/07/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ClubPostHeadTitlePage: View {
    
    @StateObject var languageManager = LanguageManager.shared
    
    private struct sizeInfo {
        static let padding10: CGFloat = 10.0
        static let padding20: CGFloat = 20.0
        static let spacer15: CGFloat = 15.5
        static let dividerHeight: CGFloat = 1.0
        static let textFieldHeight: CGFloat = 42.0
        static let cellLeadingPadding: CGFloat = 20.0
        static let cellBottomPadding: CGFloat = 14.0
        static let cellTopPadding: CGFloat = 19.5
    }
    
    @State private var headTitle = ""
    @State private var showPassword = false
    @State var isFocus:Bool = false
    @State var correctStatus: CheckCorrectStatus = .Check
    @State private var limitTextCountAlert: Bool = false
    @State private var limitTagCountAlert: Bool = false
    @State private var limitTagTextAlert: Bool = false
    
    @State var tags: [ClubPostHeadTitleHashTag] = []
    
    @State var headTags = [
        ClubPostHeadTitleHashTag(text: "n_news".localized),
        ClubPostHeadTitleHashTag(text: "j_any_chat".localized),
        ClubPostHeadTitleHashTag(text: "j_question".localized),
        ClubPostHeadTitleHashTag(text: "g_etc".localized),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: sizeInfo.spacer15)
            ExDivider(color: Color.bgLightGray50, height: sizeInfo.dividerHeight)
            Text("m_summary".localized)
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray800)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: 0))
            
            CustomKeyboardTextField(returnVal: .done,
                                    placeholder: "se_m_write_headline_space".localized,
                                    tag: 0,
                                    text: $headTitle,
                                    isfocusAble: .constant([false]),
                                    isFirstResponder: true,
                                    onCommit: {
                if headTitle.count > 0 && tags.count < 6 && headTitle.validateHashTag() {
                    appendList()
                }
                else if !headTitle.validateHashTag() {
                    self.limitTagTextAlert.toggle()
                }
                else {
                    headTitle = ""
                    self.limitTagCountAlert.toggle()
                }
            })
                .padding(EdgeInsets(top: 0, leading: sizeInfo.cellLeadingPadding, bottom: 0, trailing: sizeInfo.cellLeadingPadding))
                .frame(height: sizeInfo.textFieldHeight)
                .onReceive(headTitle.publisher.collect()) {
                    self.headTitle = String($0.prefix(8))
                }
                .onChange(of: headTitle) { newValue in
                    if headTitle.count >= 8 {
                        self.limitTextCountAlert.toggle()
                    }
                    set(name: headTitle)
                }
            
            VStack(spacing: 0) {
                ClubPostHeadTitleView(maxLimit: 4, headTitleType: .Default, tags: $headTags)
                    .padding(.bottom, sizeInfo.padding10)
                ClubPostHeadTitleView(maxLimit: 6, headTitleType: .AddHeadTitle, tags: $tags)
            }
            .padding(.top, 20)
            .padding(.bottom, 29)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("[말머리 생성/삭제 주의사항]")
                    .foregroundColor(Color.stateDanger)
                    .font(Font.caption11218Regular)
                
                headTitleDescription()
            }
            .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
            
            Spacer()
            
        }
        .background(Color.gray25)
        .navigationType(leftItems: [.Back], rightItems: [.Save], leftItemsForegroundColor: .black, rightItemsForegroundColor: .primary500, title: "m_summary_setting".localized, onPress: { buttonType in
        })
        .popup(isPresenting: $limitTagTextAlert, cornerRadius: 5, locationType: .middle, autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text( "se_m_headline_length".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.gray800)
        }
               
        )
        .popup(isPresenting: $limitTagCountAlert, cornerRadius: 5, locationType: .middle, autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text("se_m_headline_count".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.gray800)
        }
               
        )
        .popup(isPresenting: $limitTextCountAlert, cornerRadius: 5, locationType: .middle, autoDismiss: .after(2), popup:
                ZStack {
            Spacer()
            Text("se_m_headline_length".localized)
                .foregroundColor(Color.gray25)
                .font(Font.body21420Regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.gray800)
        }
               
        )
        
        .navigationBarBackground {
            Color.gray25
        }
//        .statusBarStyle(style: .darkContent)
    }

}


extension ClubPostHeadTitlePage {
    
    func appendList() {
        tags.append(ClubPostHeadTitleHashTag(text: headTitle))
        headTitle = ""
    }
    
    func set(name: String) {
        if name.contains(" ") {
            headTitle.remove(at: name.index(before: name.endIndex))
            if headTitle.count > 0 && tags.count < 10 && headTitle.validateHashTag() {
                appendList()
            }
            else if !headTitle.validateHashTag() {
                limitTagTextAlert = true
            }
            else {
                headTitle = ""
                limitTagCountAlert = true
            }
        } else {
            print("Wrong value format")
        }
    }
    
    func RowView(tag: ClubPostHeadTitleHashTag) {
        if headTitle == tag.text {
            headTitle = ""
        }
    }
}
struct headTitleDescription: View {
    
    var body: some View {
        VStack {
            ExplainText(explainText: "생성된 말머리는 수정할 수 없으며, 말머리 간 순서 조정이 불가합니다.")
            ExplainText(explainText: "기본 제공되는 말머리는 뉴스, 잡담, 질문, 기타 입니다.")
            ExplainText(explainText: "기본 제공되는 말머리는 삭제할 수 없습니다.")
            ExplainText(explainText: "말머리 삭제 시 해당 말머리가 붙어있는 모든 게시글에서 말머리가 지워집니다.")
                .padding(.bottom, -10)
            ExplainLongText(icon: "·", explainText: "말머리가 삭제된 글들은 클럽 게시글 검색 또는 자유게시판의 '전체'선택 시에만 확인할 수 있습니다.")
                .padding(.leading, -15)
        }
    
    }
    
}
