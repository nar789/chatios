//
//  AlertModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation

struct AlertModel: Codable, Hashable {
    let code: Int
    let data: [AlertData]
}
struct AlertData: Codable, Hashable {
    let alert_thumbnail, alert_message, alert_title, alert_category, alert_date: String
}
