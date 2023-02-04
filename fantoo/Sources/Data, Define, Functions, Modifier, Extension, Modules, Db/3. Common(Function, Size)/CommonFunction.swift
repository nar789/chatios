//
//  CommonFunction.swift
//  fantoo
//
//  Created by mkapps on 2022/04/23.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import UIKit

struct CommonFunction {
    static func defaultParams() -> [String: Any] {
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let osVersion = UIDevice.current.systemVersion
        let countryCode = Locale.current.regionCode ?? ""
        
        var params: [String: Any] = [:]
        params[DefineKey.appVersion] = appVersion
        params[DefineKey.device] = "iphone"
        params[DefineKey.osVersion] = osVersion
        params[DefineKey.countryCode] = countryCode
        
        return params
    }
    
    static func defaultHeader(acceptLanguage: String = "") -> [String:String] {
        var header: [String:String] = [:]
        header[DefineKey.referer] = "http://fantoo.co.kr"
        header[DefineKey.user_agent] = "fantoo-iphone"
        if acceptLanguage == "" {
            header[DefineKey.accept_language] = LanguageManager.shared.getLanguageCode()
        } else {
            header[DefineKey.accept_language] = acceptLanguage
        }
        return header
    }
    
    static func onPageLoading() {
        // 페이지 내에서 로딩
        StatusManager.shared.loadingStatus = .ShowWithTouchable
    }
    static func offPageLoading() {
        // 로딩 종료
        StatusManager.shared.loadingStatus = .Close
    }
    
    
}
