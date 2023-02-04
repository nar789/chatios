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
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var languageManager = LanguageManager.shared
    @StateObject var vm = ClubPostViewModel()
    
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
    
    @State var buttonTextToggle: Bool = false
    @State var cancelButtonTextToggle: Bool = false
    
    //Navi
    @State var showArchivePage: Bool = false
    @State var showEmptyArchivePage: Bool = false
    @State var showPostDetailPage: Bool = false
    
    @State var isEditModeOn: Bool = true
    
    @State var categoryCode: String = ""
    @State var categoryName: String = ""
    @State var categoryOpenYn: Bool = false
    @State var categoryBoardType: Int = 0
    @State var categoryArray: [String] = []
    @State var addCategory: String = ""
    @State var changeCategoryArray: [String] = []
    
    @Binding var clubId: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                //            Spacer().frame(height: 15.5)
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

                HStack(spacing: 0) {
                    Text("a_archive".localized)
                        .font(Font.caption11218Regular)
                        .foregroundColor(Color.gray800)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()

                    Button {
                        buttonTextToggle = false
                        vm.requestClubCategoryList(clubId: clubId)
                    } label: {
                        Text("c_cancel".localized)
                            .foregroundColor(Color.gray600)
                            .font(Font.caption11218Regular)
                            .opacity(buttonTextToggle ? 1 : 0)
                    }

                    Button {
                        //buttonTextToggle = !buttonTextToggle
                        buttonTextToggle.toggle()
                        
                        // 완료버튼 클릭
                        if !buttonTextToggle {
                            // List 변경했는지 검사
                            if vm.isChangedList {
                                vm.makeChangedBoardList() { success in
                                    if success {
                                        vm.changeBoardList(
                                            categoryCode: vm.boardCategoryCode,
                                            clubId: vm.boardClubId,
                                            categoryNameList: vm.changedBoardList,
                                            integUid: UserManager.shared.uid,
                                            result: { success in
                                                if success {
                                                    vm.resetIsChangedList()
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    } label: {
                        Text(buttonTextToggle ? "a_done".localized : "p_edit".localized)
                            .foregroundColor(Color.primary500)
                            .font(Font.caption11218Regular)
                    }
                }
                .padding(EdgeInsets(top: sizeInfo.cellTopPadding, leading: sizeInfo.cellLeadingPadding, bottom: sizeInfo.cellBottomPadding, trailing: sizeInfo.cellLeadingPadding))

                if !vm.post.isEmpty {
                    VStack(spacing: 0) {
                        ScrollView {
                            ForEach(vm.post, id: \.self) { element in
                                let categoryArr = element.categoryName ?? ""

                                if !buttonTextToggle {
                                    Button {
                                        categoryCode = element.categoryCode ?? ""
                                        categoryName = element.categoryName ?? ""
                                        categoryOpenYn = element.openYn ?? false
                                        categoryBoardType = element.boardType ?? 0

                                        showArchivePage = true
                                    } label: {
                                        ClubPostArchiveListView(type: .Default, draggedPost: element)
                                            .onAppear {
                                                addCategory = element.categoryName ?? ""
                                            }
                                    }
                                    .background(
                                        NavigationLink("", isActive: $showArchivePage) {
                                            ClubPostArchivePage(viewModel: self.vm, clubId: $clubId, categoryCode: $categoryCode, categoryName: $categoryName, categoryVisibility: $categoryOpenYn, categoryBoardType: $categoryBoardType, editType: .constant(1))
                                        }.hidden()
                                    )
                                }
                                else {
                                    ClubPostArchiveListView(type: .Edit, draggedPost: element)
                                        .onDrag({
                                            vm.currentItem = element
                                            return NSItemProvider(object: String(element.categoryName ?? "") as NSString)
                                        })
                                        .onDrop(of: [.text], delegate: DropViewDelegate(singleItem: element, viewModel: vm))
//                                        .onAppear {
//                                            addCategory = element.categoryName ?? ""
//                                            changeCategoryArray.append(categoryArr)
//
//                                        }
//                                        .onDisappear {
//
//                                            if changeCategoryArray.contains(categoryArr) {
//                                                changeCategoryArray = changeCategoryArray.filter{$0 != categoryArr}
//    //                                            approvalCheck = false
//                                            }
//                                        }
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
                else {
                    ClubPostListView(type: .None, text: "")
                }
                
                Spacer()
                
                if !buttonTextToggle {
                    Button {
                        showEmptyArchivePage = true
                        //                    appendList()
                    } label: {
                        CommonButton(title: "a_add_archive_board".localized, bgColor: Color.stateActivePrimaryDefault)
                            .padding([.horizontal, .bottom], DefineSize.Contents.HorizontalPadding)
                    }
                    .padding(.bottom, 20)
                    .background(
                        NavigationLink("", isActive: $showEmptyArchivePage) {
                            ClubPostArchivePage(viewModel: self.vm, clubId: $clubId, categoryCode: .constant(""), categoryName: .constant(""), categoryVisibility: .constant(true), categoryBoardType: .constant(0), editType: .constant(0))
                        }.hidden()
                    )
                }


            }
            .frame(maxHeight: .infinity)
        }
        .onAppear(perform: {
            vm.requestClubCategoryList(clubId: clubId)
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


func arrRule() {
    
}
