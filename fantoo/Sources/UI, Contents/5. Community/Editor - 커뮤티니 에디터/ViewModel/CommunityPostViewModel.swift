//
//  CommunityPostViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class CommunityPostViewModel: ObservableObject {
    
    var canclelables = Set<AnyCancellable>()
    
    /**
     * 언어팩 등록할 것
     */
    private let subCategoryTitle = "말머리 선택"
    
    
    // View 관련
    @Published var mainCategory_bottomSheetHeight: Float = 0.0
    @Published var subCategory_bottomSheetHeight: Float = 0.0
    @Published var isSecret: Bool = false
    @Published var txtTitle: String = ""
    @Published var placeholderTitle: String = "제목을 입력해 주세요"
    @Published var txtContents: String = ""
    @Published var placeholderContents: String = "내용을 입력해 주세요.\n게시판 주제와 맞지 않거나 다른 사람에게 불쾌감을 주는 내용이 포함된 경우, 관리자 또는 자동으로 숨김처리 될 수 있습니다."
    @Published var isPageLoading: Bool = true
    @Published var selectedMainCategoryCode: String = ""
    @Published var selectedMainCategoryName: String = "" {
        didSet(oldValue) {
            
            // 메인 카테고리 변경한 경우 -> 서브 카테고리 초기화
            if oldValue != selectedMainCategoryName {
                self.selectedSubCategoryName = subCategoryTitle
            }
            else if oldValue == selectedMainCategoryName {
                //
            }
        }
    }
    @Published var selectedSubCategoryCode: String = ""
    @Published var selectedSubCategoryName: String = ""
    @Published var isPostLoading: Bool = false
    
    // push
    @Published var showCategoryView = false
    @Published var showSubCategoryView = false
    
    @Published var postResultModel: ResultModel?
    
    // 카테고리 팬투 추천순 (회원)
    @Published var memberRecogCategory: DataObj_CategoryFantooMember?
    @Published var memberRecogCategoryList = [CategoryList_CategoryFantooMember]()
    // 카테고리 Sub (회원)
    @Published var memberSubCategory: CommunitySubcategoryMember?
    @Published var memberSubCategoryList = [CategoryList_SubcategoryMember]()
    
    
    
    /**
     * 카테고리 팬투 추천순 (회원)
     */
    func getMemberRecogCategory(integUid: String, access_token: String) {
        ApiControl.getMemberRecogCategory(integUid: UserManager.shared.uid, access_token: UserManager.shared.accessToken)
            .sink { error in
            } receiveValue: { value in
                
                self.memberRecogCategory = value
                guard let NOmemberRecogCategory = self.memberRecogCategory else {
                    return
                }
                
                self.memberRecogCategoryList = NOmemberRecogCategory.categoryList
                
                if self.memberRecogCategoryList.count > 0 {
                    switch self.memberRecogCategoryList.count {
                    case 1...3:
                        self.mainCategory_bottomSheetHeight = 220.0
                    case 4...6:
                        self.mainCategory_bottomSheetHeight = 360.0
                    case 7...9:
                        self.mainCategory_bottomSheetHeight = 480.0
                    case 10..<14:
                        self.mainCategory_bottomSheetHeight = 640.0
                    default:
                        self.mainCategory_bottomSheetHeight = .infinity
                    }
                    
                    self.showCategoryView = true
                }
                else if self.memberRecogCategoryList.count <= 0 {
                    self.showCategoryView = false
                }
                
            }
            .store(in: &canclelables)
    }
    
    /**
     * 카테고리 Sub (회원)
     */
    func getMemberSubCategory(code: String, integUid: String, access_token: String) {
        ApiControl.getMemberSubCategory(code: code, integUid: integUid, access_token: access_token)
            .sink { error in
            } receiveValue: { value in
                
                self.memberSubCategory = value
                guard let NOmemberSubCategory = self.memberSubCategory else {
                    return
                }

                self.memberSubCategoryList = NOmemberSubCategory.categoryList
                
                if self.memberSubCategoryList.count > 0 {
                    switch self.memberSubCategoryList.count {
                    case 1...3:
                        self.subCategory_bottomSheetHeight = 220.0
                    case 4...6:
                        self.subCategory_bottomSheetHeight = 360.0
                    case 7...9:
                        self.subCategory_bottomSheetHeight = 480.0
                    case 10..<14:
                        self.subCategory_bottomSheetHeight = 640.0
                    default:
                        self.subCategory_bottomSheetHeight = .infinity
                    }
                    
                    self.showSubCategoryView = true
                }
                else if self.memberSubCategoryList.count <= 0 {
                    self.showSubCategoryView = false
                }
            }
            .store(in: &canclelables)
    }
    
    /**
     * 게시글 글쓰기
     */
    func postBoard(code: String, anonymYn: Bool, attachList: [CommonReplyModel_AttachList], content: String, hashtagList: [Community_hashtagList], integUid: String, subCode: String, title: String, access_token: String, isPostComplete: ((Bool) -> Void)?) {
        
        self.isPostLoading = true
        
        ApiControl.postCommunityBoard(code: code, anonymYn: anonymYn, attachList: attachList, content: content, hashtagList: hashtagList, integUid: integUid, subCode: subCode, title: title, access_token: access_token)
            .sink { error in
                // 로딩 종료
                StatusManager.shared.loadingStatus = .Close
            } receiveValue: { value in
                
                self.postResultModel = value
                guard let NOpostResultModel = self.postResultModel else {
                    // The 'value' is nil
                    return
                }
                
                if NOpostResultModel.success {
                    // 로딩 종료
                    StatusManager.shared.loadingStatus = .Close
                    
                    guard let NOisPostComplete = isPostComplete else { return }
                    NOisPostComplete(true)
                }
            }
            .store(in: &canclelables)
    }
    
    func checkPostData() -> Bool {
        if !self.selectedMainCategoryName.isEmpty && !self.selectedSubCategoryName.isEmpty && !self.txtTitle.isEmpty && !self.txtContents.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func checkApiPostData() -> Bool {
        if !self.selectedMainCategoryName.isEmpty && !self.selectedSubCategoryName.isEmpty && !self.txtTitle.isEmpty && !self.txtContents.isEmpty && !self.selectedMainCategoryCode.isEmpty && !self.selectedSubCategoryCode.isEmpty {
            return true
        } else {
            return false
        }
    }
}
