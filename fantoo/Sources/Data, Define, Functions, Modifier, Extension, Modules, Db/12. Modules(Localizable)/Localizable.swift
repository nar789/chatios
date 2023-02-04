//
//  Localizable.swift
//  fantoo
//
//  Created by mkapps on 2022/04/27.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

enum Language: String {
    case arabic = "ar"
    case german = "de"
    case eng = "en" // 영어
    case spa = "es" // 스페인어
    case fre = "fr" // 프랑스어
    
    case hindi = "hi"
    case ind = "id" // 인도네시아어
    case italian = "it"
    case jpn = "ja" // 일본어
    case kor = "ko"   // 한국어
    
    case polish = "pl"  //폴란드
    case portuguese = "pt-PT"    //포루투칼
    case rus = "ru" // 러시아어
    case thai = "th"    //태국
    case vietnamese = "vi-VN"       //베트남
    
    case chi = "zh-Hans" // 중국어(간체)
    case chi_t = "zh-Hant" // 중국어(번체)
    
    func getCodeForTrans() -> String {
        switch self {
        case .polish:
            return "pt"
            
        case .vietnamese:
            return "vi"
            
        case .chi:
            return "zh_cn"
            
        case .chi_t:
            return "zn_tw"
            
        default:
            return self.rawValue
        }
    }
    
    static func getCodeForLanguage(code: String) -> String {
        if code == "vi" {
            return "vi-VN"
        }
        else if code == "pt" {
            return "pt-PT"
        }
        else if code == "zh_cn" {
            return "zh-Hans"
        }
        else if code == "zn_tw" {
            return "zh-Hant"
        }
        
        return code
    }
    
    
    
    static var language: Language {
        get {
            guard let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") else {
                return Language.eng
            }
            
            if let languageCode = defaults.string(forKey: Define.LANGUAGE_KEY),
                let language = Language(rawValue: languageCode) {
                return language
            }
            else {
                var lang = NSLocale.current.languageCode ?? "en"
                if lang == "zh" || lang == "pt" || lang == "vi" {
                    lang = lang + "-" + (NSLocale.current.scriptCode ?? "")
                }
                guard let localization = Language(rawValue: lang) else {
                    return Language.eng
                }
                
                
                return localization
            }
        }
        set {
            guard language != newValue else {
                return
            }
            
            //change language in the app
            //the language will be changed after restart
            DispatchQueue.main.async {
                if let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") {
                    defaults.set(newValue.rawValue, forKey: Define.LANGUAGE_KEY)
                    defaults.synchronize()
                    
                    NotificationCenter.default.post(name: Notification.Name("ChageLanguage"), object: self, userInfo: nil)
                }
            }
        }
    }
}
