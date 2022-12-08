//
//  ErrorHandler.swift
//  fantoo
//
//  Created by mkapps on 2022/07/08.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//


/*
 http://129.154.201.232:9121/common/error/code
 http://129.154.201.232:8121/common/error/code
 
 위 2개의 json을 통해서
 
 - 번역 https://docs.google.com/spreadsheets/d/1Gcxwm10QmhNbFt7mgEnYSKbKsxypfikEA5orX5oFowU/edit#gid=0
 - case
 
 추가를 하여 갱신을 해야한다.
 */


import Foundation
import SwiftUI

struct ErrorHandler {
    enum ErrorCode: String {
        
        case FE1000, FE1001, FE1002, FE1003, FE1004, FE1005, FE1006, FE1007, FE1008, FE1009, FE1010,
             FE1011, FE1012, FE1013, FE1014, FE1015, FE1016, FE1017, FE1018, FE1019, FE1020,
             FE1021, FE1022, FE1023, FE1024, FE1025, FE1026, FE1027, FE1028, FE1029, FE1030,
             FE1031, FE1032, FE1033, FE1034,
             
             FE2000, FE2001, FE2002, FE2003, FE2004, FE2005, FE2006, FE2007, FE2008, FE2009, FE2010,
             FE2011, FE2012, FE2013, FE2014, FE2015, FE2016, FE2017, FE2018, FE2019, FE2020,
             FE2021, FE2022, FE2023,
             
             FE2824, FE2825, FE2826, FE2827, FE2828, FE2829, FE2830,
             FE2831, FE2832, FE2833, FE2834, FE2835, FE2836, FE2837, FE2838, FE2839, FE2840,
             
             FE3000, FE3001, FE3002, FE3003, FE3004, FE3005, FE3006, FE3007, FE3008, FE3009, FE3010,
             FE3011, FE3012, FE3013, FE3014, FE3015, FE3016, FE3017, FE3018, FE3019, FE3020,
             FE3021, FE3022, FE3023, FE3024, FE3025, FE3026, FE3027, FE3028, FE3029, FE3030,
             FE3031, FE3032, FE3033, FE3034, FE3035, FE3036, FE3037, FE3038, FE3039, FE3040,
             FE3041, FE3042, FE3043, FE3044, FE3045, FE3046, FE3047,
             
             FE3100, FE3101, FE3102, FE3103, FE3104,
             
             FE3050, FE3051,
             
             //Login
             AE5000, AE5001, AE5002, AE5003, AE5004, AE5005, AE5006, AE5007, AE5008, AE5009, AE5010,
             
             AE5100, AE5101
        
        func getMessage() -> String {
            let str = "Error_" + self.rawValue
            let message = str.localized
            
            //관련 localized가 있을때
            if message.count > 0, message != str {
                return message
            }
            
            //관련 localized가 없을때, 기본메세지 출력
            return ErrorHandler.getCommonMessage()
        }
    }
    
    
    /**
     에러코드 체크
     ==
     ---
     Bool : 코드가 200이면 true, 아니면 false
     Bool : 예외처리에 코드가 있으면 true, 코드가 없으면 false, 커스텀이 필요하면 false 일때 따로 처리.
     String : 타이틀
     String : 메시지
     ---
     */
    static func checkErrorCode(code: String, result:@escaping(Bool, Bool, String, String) -> Void) {
        if code == "200" {
            result(true, true, "", "")
            return
        }
        guard let errorCode = ErrorCode(rawValue: code) else {
            result(false, false, "", "alert_network_error".localized)
            return
        }
        
        result(false, true, "", errorCode.getMessage())
    }
    
    static func getErrorMessage(code: String) -> String {
        guard let errorCode = ErrorCode(rawValue: code) else {
            return getCommonMessage()
        }
        
        return errorCode.getMessage()
    }
    
    static func checkAuthError(code: Int) -> Bool {
        if code == 201 || code == 401 {
            StatusManager.shared.stopAllLoading()
            UserManager.shared.showAlertAuthError = true
            return true
        }
        
        return false
    }
    
    static func getCommonMessage() -> String {
        return "alert_network_error".localized
    }
}
