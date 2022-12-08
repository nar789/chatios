//
//  Int+Extension.swift
//  fantoo
//
//  Created by Benoit Lee on 2022/07/11.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

extension Int {
    func timeStringMMSS() -> String {
        let minutes = self / 60 % 60
        let seconds = self % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
