//
//  ClubStorageView.swift
//  fantoo
//
//  Created by mkapps on 2022/06/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

//사용 안 하는 중 22.10.05
//struct ClubStorageView: View {
//
//    private struct sizeInfo {
//        static let padding: CGFloat = 10.0
//        static let padding5: CGFloat = 5.0
//        static let spacing14: CGFloat = 14.0
//        static let spacing100: CGFloat = 100.0
//        static let stackSpacing: CGFloat = -10.0
//        static let dividerHeight: CGFloat = 1.0
//        static let imageSize: CGSize = CGSize(width: 100, height: 100)
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // 검색때 사용
//            Spacer().frame(height: sizeInfo.spacing100)
//
//            Image("character_club2")
//                .frame(width: sizeInfo.imageSize.width, height: sizeInfo.imageSize.height, alignment: .center)
//
//            Spacer().frame(height: sizeInfo.spacing14)
//
//            Text("se_g_no_result_member_search".localized)
//                .font(Font.body21420Regular)
//                .foregroundColor(Color.gray600)
//                .multilineTextAlignment(.center)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//    }
//}
//
//
//struct ClubStorageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClubStorageView()
//    }
//}
//
//extension ClubStorageView {
//    func tabPage(tabType: String, viewModel: ClubSettingViewModel) -> some View {
//        VStack(spacing: 0) {
//            if tabType == "myBoard" {
//                ScrollView {
//                    LazyVStack(spacing: 0) {
//                        ForEach(0..<viewModel.clubStorageReplyListData.count, id: \.self) { i in
//                            BoardRowView(
//                                viewType: BoardType.MainClub_My,
//                                clubStorageReplyListData: viewModel.clubStorageReplyListData[i]
//                            )
//                                .background(Color.gray25)
//                            Color.bgLightGray50.frame(height: 8)
//                        }
//                    }
//                }
//                .onAppear {
////                    viewModel.getMyBoardList()
//                    viewModel.requestMyClubStorageReply()
//
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//
//
//            }
//
//            else if tabType == "myComment" {
//                ScrollView {
//                    LazyVStack(spacing: 0) {
//                        ForEach(0..<viewModel.clubStorageReplyListData.count, id: \.self) { i in
//                            BoardRowView(
//                                viewType: BoardType.MyClub_Storage_Comment,
//                                clubStorageReplyListData: viewModel.clubStorageReplyListData[i]
//                            )
//                                .background(Color.gray25)
//                            Color.bgLightGray50.frame(height: 8)
//                        }
//                    }
//                }
//                .onAppear {
////                    viewModel.getMyBoardList()
//                    viewModel.requestMyClubStorageReply()
//
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//            }
//            else if tabType == "clubSave" {
//                ScrollView {
//                    LazyVStack(spacing: 0) {
//                        ForEach(0..<viewModel.clubStorageReplyListData.count, id: \.self) { i in
//                            BoardRowView(
//                                viewType: BoardType.MainClub_My,
//                                clubStorageReplyListData: viewModel.clubStorageReplyListData[i]
//                            )
//                                .background(Color.gray25)
//                            Color.bgLightGray50.frame(height: 8)
//                        }
//                    }
//                }
//                .onAppear {
////                    viewModel.getMyBoardList()
//                    viewModel.requestMyClubStorageReply()
//                }
//                // make disable the bouncing
//                .introspectScrollView {
//                    $0.bounces = false
//                }
//            }
//        }
//        .background(Color.bgLightGray50)
//    }
//}
//
