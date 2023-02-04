//
//  ClubInfoSettingBottomModel.swift
//  fantoo
//
//  Created by fns on 2022/07/08.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

enum BottomType: Int {
    case ClubOpen
    case MemberNumberList
    case MemberList
    case JoinApproval
    case CommunityFavorite
    case ClubOpenTitleaOfClub
    case JoinApprovalTitleOfClub
   
}

struct subTitleDescription: Hashable {
    var SEQ: Int
    var subTitle: String = ""
    var subDescription: String = ""
}
