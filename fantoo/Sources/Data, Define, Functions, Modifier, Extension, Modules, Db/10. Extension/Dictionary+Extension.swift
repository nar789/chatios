//
//  Dictionary+Extension.swift
//  fantoo
//
//  Created by dklee on 2021/08/02.
//  Copyright © 2021 FNS. All rights reserved.
//

import Foundation

extension Dictionary {
    func toString() -> String? {
        do{
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        }catch{
            //_log.e(error.localizedDescription)
            return nil
        }
    }
}
