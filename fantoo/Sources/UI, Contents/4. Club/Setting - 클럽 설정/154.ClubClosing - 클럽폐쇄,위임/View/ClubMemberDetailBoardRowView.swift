//
//  ClubMemberDetailBoardRowView.swift
//  NotificationService
//
//  Created by fns on 2022/07/26.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ClubMemberDetailBoardRowView {
    @StateObject var languageManager = LanguageManager.shared

    @State private var showDetail = false
    
    let viewType: String
    var communityBoardItem: CommunityBoardItem?
    
    @State var authorImage: String = ""
    @State var boardName: String = ""
    @State var authorNickname: String = ""
    @State var boardDate: String = ""
    @State var post_content_type: String = ""
    @State var title: String = ""
    @State var likeCount: Int = 0
    @State var honorCount: Int = 0
    @State var commentCount: Int = 0
    
}
