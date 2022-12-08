//
//  ClubMemberDetailSubView.swift
//  NotificationService
//
//  Created by fns on 2022/07/26.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI

//struct ClubMemberDetailSubView: View {
//    @StateObject var languageManager = LanguageManager.shared
//
//    var tabType: String = ""
//
//    var body: some View {
//        VStack {
//            if tabType == "myBoard" {
//                ScrollView(showsIndicators: false) {
//                    LazyVStack(spacing: 10) {
//                        ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
//                            ClubMemberDetailBoardRowView(
//                                viewType: "community",
//                                communityBoardItem: viewModel.issueTop5_listTopFive[i]
//                            )
//                            .background(Color.gray25)
//                        }
//                    }
//                }
//                .onAppear {
//                    viewModel.getMyBoardList()
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//
//
//            } else if tabType == "myComment" {
//                ScrollView(showsIndicators: false) {
//                    LazyVStack(spacing: 10) {
//                        if viewModel.issueTop5_listTopFive.count > 0 {
//                            let forTestData: [Comment_Community] =
//                            viewModel.issueTop5_listTopFive[0].comment
//
//                            ForEach(forTestData, id: \.self) { item in
//                                CommentRowView(itemData: item)
//                                    .background(Color.gray25)
//                            }
//                        }
//                    }
//                }
//                .onAppear {
//                    viewModel.getCommentList()
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//            }  else if tabType == "myLocalBoard" {
//                ScrollView(showsIndicators: false) {
//                    LazyVStack(spacing: 10) {
//                        ForEach(0..<viewModel.issueTop5_listTopFive.count, id: \.self) { i in
//                            ClubMemberDetailBoardRowView(
//                                viewType: "community",
//                                communityBoardItem: viewModel.issueTop5_listTopFive[i]
//                            )
//                            .background(Color.gray25)
//                        }
//                    }
//                }
//                .onAppear {
//                    viewModel.getMyBoardList()
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//            }
//
//        }
//        .background(Color.bgLightGray50)
//    }
//}
//
//struct ClubMemberDetailSubView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClubMemberDetailSubView()
//    }
//}
