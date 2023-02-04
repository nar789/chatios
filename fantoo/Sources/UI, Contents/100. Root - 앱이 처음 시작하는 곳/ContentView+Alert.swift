//
//  ContentView+Alert.swift
//  fantoo
//
//  Created by mkapps on 2022/10/12.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentViewAlert: ViewModifier {
    
    @StateObject var userManager = UserManager.shared
    
    func body(content: Content) -> some View {
        content
        //로그인알럿
            .showAlert(isPresented: $userManager.showLoginAlert, type: .Default, title: "r_need_login".localized, message: "se_r_need_login".localized, detailMessage: "", buttons: ["c_cancel".localized, "h_confirm".localized], onClick: { buttonIndex in
                if buttonIndex == 1 {
                    userManager.showLoginView = true
                }
            })
        
        //인증오류 알럿, 로그인뷰에서는 안뜬다.
            .showAlert(isPresented: $userManager.showAlertAuthError, type: .Default, title: "", message: "alert_auth_error".localized, detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
                userManager.logout()
            })
        
            .showAlert(isPresented: $userManager.showSettingAuth, type: .Default, title: "테스트중", message: "허용해주세요", detailMessage: "", buttons: ["h_confirm".localized], onClick: { buttonIndex in
                if buttonIndex == 0 {
                    UserManager.shared.authorizedAlbum = true
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            })
        
        //보관함 삭제된 글
            .popup(isPresenting: $userManager.deletePostAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
                    ZStack {
                Spacer()
                Text("se_s_post_delete".localized)
                    .foregroundColor(Color.gray25)
                    .font(Font.body21420Regular)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.gray800)
            })
        
        //보관함 신고된 글
            .popup(isPresenting: $userManager.reportPostAlert, cornerRadius: 5, locationType: .bottom, autoDismiss: .after(2), popup:
                    ZStack {
                Spacer()
                Text("se_s_post_hide_by_report_long".localized)
                    .foregroundColor(Color.gray25)
                    .font(Font.body21420Regular)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.gray800)
            })
    }
}
