//
//  Localizable
//
//  Created by Roman Sorochak <roman.sorochak@gmail.com> on 6/23/17.
//  Copyright © 2017 MagicLab. All rights reserved.
//

import UIKit

enum Language: String {
    
    case kor = "ko"   // 한국어
    case eng = "en" // 영어
    case jpn = "ja" // 일본어
    case chi = "zh-Hans" // 중국어(간체)
    case chi_t = "zh-Hant" // 중국어(번체)
    case ind = "id" // 인도네시아어
    case spa = "es" // 스페인어
    case fre = "fr" // 프랑스어
    case rus = "ru" // 러시아어
    
    static var language: Language {
        get {
            guard let defaults = UserDefaults(suiteName: "group.rndeep.fantoo") else {
                return Language.eng
            }
            
            if let languageCode = defaults.string(forKey: "Apple"),
                let language = Language(rawValue: languageCode) {
                return language
            }
            else {
                var lang = NSLocale.current.languageCode ?? "en"
                if lang == "zh" {
                    lang = "zh-" + (NSLocale.current.scriptCode ?? "")
                }
                
                defaults.set(lang, forKey: "Apple")
                
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
                    defaults.set(newValue.rawValue, forKey: "Apple")
                    defaults.synchronize()
                    
                    NotificationCenter.default.post(name: Notification.Name("ChageLanguage"), object: self, userInfo: nil)
                }
            }
        }
    }
}

extension String {
    
    var localized: String {
        return Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
    }
}

extension Bundle {
    //Here magic happens
    //when you localize resources: for instance Localizable.strings, images
    //it creates different bundles
    //we take appropriate bundle according to language
    static var localizedBundle: Bundle {
        let languageCode = Language.language.rawValue
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
            return Bundle.main
        }
        return Bundle(path: path)!
    }
}

protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}

extension UITextField: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
   }
}
