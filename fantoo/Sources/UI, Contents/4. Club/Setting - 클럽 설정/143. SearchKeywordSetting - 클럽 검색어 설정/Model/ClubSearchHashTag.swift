//
//  ClubSearchHashTag.swift
//  fantoo
//
//  Created by fns on 2022/07/07.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ClubSearchHashTag: Identifiable, Hashable {
    var id = UUID()
    var text: String
    var size: CGFloat = 0
}
