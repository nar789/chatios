//
//  CommonFunction.swift
//  fantoo
//
//  Created by mkapps on 2022/04/23.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import UIKit

struct CommonFucntion {
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
    
    static func defaultHeader() -> [String:String] {
        var header: [String:String] = [:]
        header[DefineKey.referer] = "http://fantoo.co.kr"
        header[DefineKey.user_agent] = "fantoo-iphone"
        
        return header
    }
    
}
