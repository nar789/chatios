//
//  ClubPostSettiongPage.swift
//  fantoo
//
//  Created by fns on 2022/07/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct ClubPostPage: View {
    
    @StateObject var languageManager = LanguageManager.shared
    
    //    @State var dataList = [
    //        DataItem(title: "자유게시판")
    //    ]
    
    private struct sizeInfo {
        static let padding: CGFloat = 10.0
        static let cellLeadingPadding: CGFloat = 20.0
        static let cellBottomPadding: CGFloat = 10.0
        static let cellTopPadding: CGFloat = 20.0
        static let iconSize: CGSize = CGSize(width: 17, height: 16)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var buttonTextToggle: Bool = false
    @State var cancelButtonTextToggle: Bool = false
    
    //Navi
    @State var showArchivePage: Bool = false
    @State var showPostDetailPage: Bool = false
    
    @State var isEditModeOn: Bool = true
    
    @StateObject var vm = ClubPostVM()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 15.5)
            ExDivider(color: Color.bgLightGray50, height: 1)
            Text("j_free_board".localized)
                .font(Font.caption11218Regular)
                .foregroundColor(Color.gray800)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: 0))
            Button {
                showPostDetailPage = true
            } label: {
                ClubPostListView(type: .Default, text: "j_free_board".localized)
            }
            .background(
                NavigationLink("", isActive: $showPostDetailPage) {
                    ClubPostDetailPage()
                }.hidden()
            )
            HStack {
                Text("a_archive".localized)
                    .font(Font.caption11218Regular)
                    .foregroundColor(Color.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Button {
                    //                cancelButtonTextToggle = true
                    buttonTextToggle = false
                } label: {
                    Text("c_cancel".localized)
                        .foregroundColor(Color.gray600)
                        .font(Font.caption11218Regular)
                        .opacity(buttonTextToggle ? 1 : 0)
                }
                
                Button {
                    buttonTextToggle = !buttonTextToggle
                } label: {
                    Text(buttonTextToggle ? "완료" : "편집")
                        .foregroundColor(Color.primary500)
                        .font(Font.caption11218Regular)
                }
            }
            .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: sizeInfo.cellLeadingPadding))
            
            //            ClubPostListView(type: .Image, text: "")
            
            if vm.post.count == 0 {
                ClubPostListView(type: .None, text: "")
            }
            else {
//                let clubCategoryList = vm.clubCategoryListData ?? nil
//                if clubCategoryList != nil {
                ScrollView {
                    ForEach(vm.post) { post in
                        if !buttonTextToggle {
                            Button {
                                showArchivePage = true
                            } label: {
                                ClubPostArchiveListView(type: .Default, draggedPost: post)
                            }
                            .background(
                                NavigationLink("", isActive: $showArchivePage) {
                                    ClubPostArchivePage(viewModel: self.vm)
                                }.hidden()
                            )
                        }
                        else {
                            ClubPostArchiveListView(type: .Edit, draggedPost: post)
                                .onDrag({
                                    vm.draggedItem = post
                                    return NSItemProvider(item: nil, typeIdentifier: post.title)
                                })
                                .onDrop(of: [UTType.text], delegate:   PostDropDelegate<DraggedPost>(currentItem: post, items: $vm.post, draggedItem: $vm.draggedItem)
                                )
                        }
                    }
                }
            
//                ScrollView {
//                    ForEach(vm.post) { post in
//                        if !buttonTextToggle {
//                            Button {
//                                showArchivePage = true
//                            } label: {
//                                ClubPostArchiveListView(type: .Default, draggedPost: post)
//                            }
//                            .background(
//                                NavigationLink("", isActive: $showArchivePage) {
//                                    ClubPostArchivePage(viewModel: self.vm)
//                                }.hidden()
//                            )
//                        }
//                        else {
//                            ClubPostArchiveListView(type: .Edit, draggedPost: post)
//                                .onDrag({
//                                    vm.draggedItem = post
//                                    return NSItemProvider(item: nil, typeIdentifier: post.title)
//                                })
//                                .onDrop(of: [UTType.text], delegate:   PostDropDelegate<DraggedPost>(currentItem: post, items: $vm.post, draggedItem: $vm.draggedItem)
//                                )
//                        }
//                    }
//                }
            }
            
            Spacer().frame(maxHeight: .infinity)
            
            if !buttonTextToggle {
                Button {
                    showArchivePage = true
                    //                    appendList()
                } label: {
                    CommonButton(title: "a_add_archive_board".localized, bgColor: Color.stateActivePrimaryDefault)
                        .padding([.horizontal, .bottom], DefineSize.Contents.HorizontalPadding)
                }
                .background(
                    NavigationLink("", isActive: $showArchivePage) {
                                                ClubPostArchivePage(viewModel: self.vm)
                    }.hidden()
                )
            }
        }
        .onAppear(perform: {
            vm.requestClubCategoryList()
        })
        .background(Color.gray25)
        .navigationType(leftItems: [.Close], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "g_board_management".localized, onPress: { buttonType in
        })
        .navigationBarBackground {
            Color.gray25
        }
//        .statusBarStyle(style: .darkContent)
    }
}
