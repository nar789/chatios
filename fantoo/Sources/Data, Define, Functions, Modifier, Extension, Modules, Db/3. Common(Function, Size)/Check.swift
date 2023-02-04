//
//  Check.swift
//  fantoo
//
//  Created by mkapps on 2022/11/09.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class Check: NSObject, ObservableObject {
    
    var checkCount: Int = 0
    
    //최대 10초 기다리자.
    let delay = 0.5
    let maxCount: Int = 20
    
    override init() {
        super.init()
    }
    
    func checkToken(isCheck:Bool, result:@escaping((_ success:Bool) -> Void)) {
        if !isCheck {
            result(true)
            return
        }
        
        if !UserManager.shared.isLogin {
            result(true)
            return
        }
        
        if UserManager.shared.checkExpiredToken() {
            result(true)
            return
        }
        
        //재귀함수로 체크를 계속하게 했는데 문제가 없는지 미지수...
        if UserManager.shared.isCheckingToken {
            
            if checkCount > maxCount {
                checkCount = 0
            }
            else {
                checkCount += 1
                print("checkCount : \(checkCount)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.checkToken(isCheck: isCheck, result: result)
                }
            }
            
            return
        }
        
        UserManager.shared.refreshToken { success in
            result(success)
        }
    }
}
