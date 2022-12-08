//
//  ClubClosingPage.swift
//  fantoo
//
//  Created by fns on 2022/07/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct ClubClosingPage: View {
    
    enum ClubClosingType: Int {
        case WriteClubClosing
        case ConfirmClubClosing
    }
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = ClubClosingViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    private struct sizeInfo {
        static let spacing6: CGFloat = 6.0
        static let spacing8: CGFloat = 8.0
        static let spacing14: CGFloat = 14
        static let spacing15: CGFloat = 15.5
        static let padding33: CGFloat = 33.0
        static let padding335: CGFloat = 33.5
        static let textHeight: CGFloat = 28.0
        static let frameHeight: CGFloat = 180.0
        static let dividerHeight: CGFloat = 1.0
    }
    
    @State var clubClosingText = ""
    @State var didStartEditing = false
    @State var closingConfirm = false
    @State var changePage = false
    @State var showCancelClosing = false
    @State var showCancelConfirm = false
    @State var showClubClosing = false
    
    let clubClosingType: ClubClosingType
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: sizeInfo.spacing15)
            ExDivider(color: Color.bgLightGray50, height: sizeInfo.dividerHeight)
            
            //            if !closingConfirm {
            //                writeClubClosing
            //            }
            //            else {
            //                confirmClubClosing
            //            }
            
            if changePage {
                confirmClubClosing
            }
            else {
                if clubClosingType == .WriteClubClosing {
                    writeClubClosing
                }
                else if clubClosingType == .ConfirmClubClosing {
                    confirmClubClosing
                }
            }
            
            explainClubClosing
            
            Spacer().frame(maxHeight: .infinity)
            
            if !changePage {
                Button {
                    if clubClosingText.count > 0 {
                        showClubClosing = true
                    }
                } label: {
                    CommonButton(title: "k_close_club".localized, bgColor: clubClosingText.count > 0 ? Color.stateActivePrimaryDefault : Color.stateEnableGray200)
                        .padding([.horizontal, .bottom], DefineSize.Contents.HorizontalPadding)
                }
            }
            else {
                Button {
                    showCancelClosing = true
                } label: {
                    CommonButton(title: "k_cancel_close_club".localized, bgColor: Color.stateActivePrimaryDefault)
                        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
                }
                .padding(.bottom, DefineSize.Contents.HorizontalPadding)
            }
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        
        .showAlert(isPresented: $showClubClosing, type: .Default, title: "클럽 폐쇄", message: "클럽을 폐쇄하시겠습니까?", detailMessage: "", buttons: ["a_no".localized, "a_yes".localized], onClick: { button in
            if button == 1 {
                changePage = true
                vm.requestClubClosingRequest()
            }
        })
        .showAlert(isPresented: $showCancelClosing, type: .Default, title: "k_cancel_close_club".localized, message: "se_k_do_you_cancel_close_club".localized, detailMessage: "", buttons: ["a_no".localized, "a_yes".localized], onClick: { button in
            showCancelConfirm = true
            vm.requestClubClosingCancel()
        })
        .showAlert(isPresented: $showCancelConfirm, type: .Default, title: "k_done_close_club".localized, message: "se_k_cancel_close_club".localized, detailMessage: "", buttons: ["h_confirm".localized], onClick: { button in
            changePage = true
            self.presentationMode.wrappedValue.dismiss()
        })
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "k_close_delete_club".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
        
    }
    
}

extension ClubClosingPage {
    
    var writeClubClosing: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("p_reason_for_closure".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(format: "%ld/200", clubClosingText.count))
                    .font(Font.caption11218Regular)
                    .foregroundColor(.gray300)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(height: sizeInfo.textHeight)
            .padding(.top, DefineSize.Contents.TopPadding)
            
            Spacer().frame(height: sizeInfo.spacing6)
            
            CustomTextView(didStartEditing: $didStartEditing, text: $clubClosingText, placeholder: "se_k_why_close_club".localized)
                .frame(height: sizeInfo.frameHeight)
                .onReceive(clubClosingText.publisher.collect()) {
                    self.clubClosingText = String($0.prefix(200))
                }
                .onTapGesture {
                    didStartEditing = true
                }
        }
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
    }
    
    var confirmClubClosing: some View {
        VStack(alignment: .leading) {
            Text("se_k_club_closure".localized)
                .font(Font.title32028Bold)
                .foregroundColor(Color.gray900)
                .multilineTextAlignment(.leading)
            Spacer().frame(height: sizeInfo.spacing8)
            Text("p_date_will_closed_date".localized + "2022. 08. 31 09:53")
                .font(Font.body21420Regular)
                .foregroundColor(Color.primary500)
                .multilineTextAlignment(.leading)
        }
        .padding(.top, sizeInfo.padding335)
        .padding(.bottom, sizeInfo.padding33)
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var explainClubClosing: some View {
        VStack {
            ExplainText(explainText: "se_k_hold_period".localized)
            ExplainText(explainText: "se_b_notice_pending_period_1".localized)
            ExplainText(explainText: "se_b_notice_pending_period_2".localized)
            ExplainText(explainText: "se_p_delete_all_club_info".localized)
            ExplainText(explainText: "se_p_kdg_belongs_fantoo".localized)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, sizeInfo.spacing14)
        .padding(.horizontal, DefineSize.Contents.HorizontalPadding)
    }
    
}

struct ExplainText: View {
    
    let explainText: String
    
    var body: some View {
        VStack {
            Text("· \(explainText)")
                .font(Font.caption21116Regular)
                .foregroundColor(Color.gray500)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct ExplainLongText: View {
    var icon : String
    var explainText : String
    
    private struct sizeInfo {
        static let stackHeight: CGFloat = 60.0
        static let descriptionPadding: CGFloat = 25.0
        static let spacerWidth: CGFloat = 2.0
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text(icon)
                    .font(Font.caption21116Regular)
                    .foregroundColor(Color.gray500)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: sizeInfo.descriptionPadding, trailing: 0))
                
                Spacer().frame(width: sizeInfo.spacerWidth)
                
                Text(explainText)
                    .font(Font.caption21116Regular)
                    .foregroundColor(Color.gray500)
                    .lineLimit(3)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: sizeInfo.descriptionPadding, trailing: 0))
            }
        }
        .frame(height: sizeInfo.stackHeight)
    }
}
