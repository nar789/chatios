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
    }
}
