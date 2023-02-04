//
//  TermMainBox.swift
//  fantoo
//
//  Created by fns on 2022/05/12.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct JoinAgreeCheckView : View {
    
    private struct sizeInfo {
        static let allAgreeViewHeight: CGFloat = 48.0
        static let agreeViewHeight: CGFloat = 32.0
        static let agreeViewSpacing: CGFloat = 5.0
        static let horizontalPadding: CGFloat = 12.0
        static let checkSize: CGSize = CGSize(width: 24.0, height: 24.0)
        
        static let padding8: CGFloat = 8.0
        static let padding12: CGFloat = 12.0
    }
    
    enum JoinAgreeCheckViewButtonType {
        case Check
        case ShowServiceTerm
        case ShowPrivacyTerm
        case ShowYouthTerm
        case ShowEventTerm
    }

    @State var checkAll:Bool = false
    @State var checkAgreeAge:Bool = false
    @State var checkAgreeService:Bool = false
    @State var checkAgreePrivacy:Bool = false
    @State var checkAgreeYouth:Bool = false
    @State var checkAgreeAd:Bool = false
    
    //필수체크 전부 하였는지, 선택체크 하였는지
    //착각금물. 여기서는 checkAll는 전체체크 여부이지만 밖으로 나가는 AllAgree는 필수사항만이다.
    let onPress: (JoinAgreeCheckViewButtonType, Bool, Bool) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Button {
                    checkAll.toggle()
                    
                    checkAgreeAge = checkAll
                    checkAgreeService = checkAll
                    checkAgreePrivacy = checkAll
                    checkAgreeYouth = checkAll
                    checkAgreeAd = checkAll
                    
                    onPress(.Check, checkAll, checkAgreeAd)
                } label: {
                    HStack(alignment: .center, spacing: 0) {
                        Image(self.checkAll ? "Checkbox_login_checked" : "Checkbox_login_unchecked")
                            .frame(width:sizeInfo.checkSize.width, height:sizeInfo.checkSize.height)
                            .padding(.leading, sizeInfo.padding12)
                            .padding(.trailing, sizeInfo.padding8)
                        
                        Text("se_a_agree_all_term".localized)
                            .font(Font.title51622Medium)
                            .foregroundColor(Color.primary500)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                }
            }
            .frame(height: sizeInfo.allAgreeViewHeight)
            .frame(maxWidth: .infinity)
            .background(Color.gray50.cornerRadius(sizeInfo.horizontalPadding))
            .padding(.bottom, sizeInfo.padding8)
            
            VStack(alignment: .leading, spacing: 0) {
                
                //만 14세 이상 (필수)
                JoinAgreeCheckSubView(isCheck: $checkAgreeAge, title: "m_more_than_14_required".localized, isOptional: false, isMore: false) { type in
                    if type == .Check {
                        checkAgreeAge.toggle()
                        checkAgree()
                    }
                }
                .padding(.bottom, sizeInfo.agreeViewSpacing)
                
                //서비스 이용약관에 동의 (필수)
                JoinAgreeCheckSubView(isCheck: $checkAgreeService, title: "s_agree_sevice_term_required".localized, isOptional: false, isMore: true) { type in
                    if type == .Check {
                        checkAgreeService.toggle()
                        checkAgree()
                    }
                    else {
                        onPress(.ShowServiceTerm, checkAll, checkAgreeAd)
                    }
                }
                .padding(.bottom, sizeInfo.agreeViewSpacing)
                
                //개인정보 취급방침 동의 (필수)
                JoinAgreeCheckSubView(isCheck: $checkAgreePrivacy, title: "g_agree_privacy_term_required".localized, isOptional: false, isMore: true) { type in
                    if type == .Check {
                        checkAgreePrivacy.toggle()
                        checkAgree()
                    }
                    else {
                        onPress(.ShowPrivacyTerm, checkAll, checkAgreeAd)
                    }
                }
                .padding(.bottom, sizeInfo.agreeViewSpacing)
                
                //청소년 보호정책 (필수)
                JoinAgreeCheckSubView(isCheck: $checkAgreeYouth, title: "c_agree_youth_term_required".localized, isOptional: false, isMore: true) { type in
                    if type == .Check {
                        checkAgreeYouth.toggle()
                        checkAgree()
                    }
                    else {
                        onPress(.ShowYouthTerm, checkAll, checkAgreeAd)
                    }
                }
                .padding(.bottom, sizeInfo.agreeViewSpacing)
                
                //이벤트 정보 수신 동의 (선택)
                JoinAgreeCheckSubView(isCheck: $checkAgreeAd, title: "a_agree_recieve_event_optional".localized, isOptional: true, isMore: true) { type in
                    if type == .Check {
                        checkAgreeAd.toggle()
                        checkAgree()
                    }
                    else {
                        onPress(.ShowEventTerm, checkAll, checkAgreeAd)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, sizeInfo.horizontalPadding)
        }
    }
    
    func checkAgree() {
        if checkAgreeAge, checkAgreeService, checkAgreePrivacy, checkAgreeYouth, checkAgreeAd {
            checkAll = true
        }
        else {
            checkAll = false
        }
        
        //착각금물. 여기서는 checkAll는 전체체크 여부이지만 밖으로 나가는 AllAgree는 필수사항만이다.
        if checkAgreeAge, checkAgreeService, checkAgreePrivacy, checkAgreeYouth {
            onPress(.Check, true, checkAgreeAd)
        }
        else {
            onPress(.Check, false, checkAgreeAd)
        }
    }
}

struct JoinAgreeCheckView_Previews: PreviewProvider {
    static var previews: some View {
        JoinAgreeCheckView { type, checkAll, checkAd in
        }
    }
}
