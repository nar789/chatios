//
//  ClubPostSettiongModel.swift
//  fantoo
//
//  Created by fns on 2022/07/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

struct ClubPostSettiongModel: Identifiable {
    var id : UUID
    var title: String
    var color: Color
}

struct DraggedPost: Identifiable, Equatable {
    var id = UUID()
    var title: String
}

struct ClubPostHeadTitleHashTag: Identifiable, Hashable {
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}

enum ClubPostArchiveBottomType: Int {
    case PostVisibilitySetting
    case ArchiveType
}

struct ClubPostArchiveBottomDescription {
    var SEQ: Int
    var subTitle: String = ""
    var subDescription: String = ""
}
