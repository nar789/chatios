//
//  ClubDetailPageViewModel.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine
import UIKit

class ClubDetailPageViewModel: ObservableObject {
    var canclelables = Set<AnyCancellable>()
    // 페이징
    var fetchMoreActionSubject = PassthroughSubject<(), Never>()
    private var replyNextId: String = "0"
    
    // 페이지 전환시 받는 데이터
    @Published var postId: Int = 0
    @Published var clubId: String = ""
    @Published var categoryCode: String = ""
    // 클럽 2뎁스(말머리) 게시물 상세
    @Published var clubDetailModel: ClubDetailModel?
    // 북마크 결과
    @Published var bookmarkModel: ClubDetailModel_BookMark?
    @Published var bookmark: Bool?
    @Published var bookmarkError: ErrorModel?
    @Published var showbookmarkErrorAlert: Bool = false
    @Published var bookmarkErrorMsg: String = ""
    // 클럽 2뎁스(말머리) 게시물 상세 - 댓글 리스트
    @Published var replyList = [ClubDetailReplyModel_ReplyList]()
    
    // 댓글 쓰기
    @Published var txtReply: String = ""
    @Published var isKeyboardFocused: Bool = false
    //@Published var pickedImage: UIImage = UIImage()
    @Published var pickedImage: String = ""
    @Published var isSecretClick: Bool = false
    @Published var isUnqualifiedImageSize: Bool = false
    // 댓글 작성 후, 리스트 밑으로 내리기
    @Published var isReplyComplete: Bool = false
    // 댓글 작성시, 이미지 업로드 에러
    //@Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    // 번역
    @Published var transData: TransData?
    @Published var transResultLists = [TransMessagesList]()
    @Published var isTransMode: Bool = false
    @Published var title_afterTrans: String = ""
    @Published var content_afterTrans: String = ""
    @Published var isTransFail: Bool = false
    
    /**
     * 댓글 페이징
     */
    init() {
        fetchMoreActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchMore()
        }.store(in: &canclelables)
    }
    
    fileprivate func fetchMore() {
        if replyNextId == "-1" {
            print("페이지 정보가 없습니다.")
            return
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.getClubDetailReply(
                    clubId: self.clubId,
                    categoryCode: self.categoryCode,
                    postId: self.postId,
                    integUid: UserManager.shared.uid,
                    access_token: UserManager.shared.accessToken,
                    size: String(DefineSize.ListSize.Common),
                    isReplyWrite: false // 댓글 작성시 호출하는 것인지 확인
                )
            }
        }
    }
    
    /**
     * 클럽상세
     */
    func getClubDetail(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String) {
        ApiControl.getClubDetail(
            clubId: clubId,
            categoryCode: categoryCode,
            postId: postId,
            integUid: integUid,
            access_token: access_token
        )
        .sink { error in
            CommonFunction.offPageLoading()
        } receiveValue: { value in
            CommonFunction.offPageLoading()
            
            self.clubDetailModel = value
            
//            debugPrint("clubId : \(self.clubId)")
//            debugPrint("categoryCode : \(self.categoryCode)")
//            debugPrint("postId : \(self.postId)")
            
            // for test
//            self.clubDetailModel?.hashtagList?.append("팬투1")
//            self.clubDetailModel?.hashtagList?.append("팬투2")
//            self.clubDetailModel?.hashtagList?.append("팬투3")
//            self.clubDetailModel?.hashtagList?.append("한류뱅크1")
//            self.clubDetailModel?.hashtagList?.append("한류뱅크2")
//            self.clubDetailModel?.hashtagList?.append("한류뱅크3")
            
            
            // 상세글 내용 다 받고, 댓글 내용 받기
            self.getClubDetailReply(
                clubId: clubId,
                categoryCode: categoryCode,
                postId: postId,
                integUid: integUid,
                access_token: access_token,
                size: String(DefineSize.ListSize.Common),
                isReplyWrite: false // 댓글 작성시 호출하는 것인지 확인
            )
        }
        .store(in: &canclelables)
    }
    
    /**
     * 클럽상세 댓글 목록
     */
    func getClubDetailReply(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String, size: String, isReplyWrite: Bool) {
        
        CommonFunction.onPageLoading()
        
        ApiControl.getClubDetailReply(clubId: clubId, categoryCode: categoryCode, postId: postId, integUid: integUid, access_token: access_token, nextId: self.replyNextId, size: size)
        .sink { error in
            CommonFunction.offPageLoading()
        } receiveValue: { value in
            
            // 스크롤 페이징인 경우
            if !isReplyWrite {
                CommonFunction.offPageLoading()
            }
            
            // 첫 페이지만 해당 (페이징 X)
            if self.replyNextId == "0" {
                if let NOnextId = value.nextId {
                    self.replyNextId = NOnextId
                }
                self.replyList = value.replyList
            }
            // 페이징으로 받아오는 데이터
            else {
                if let NOnextId = value.nextId {
                    
                    if !NOnextId.isEmpty {
                        self.replyNextId = NOnextId
                        
                        self.replyList.append(contentsOf: value.replyList)
                    } else {
                        self.replyNextId = "-1"
                    }
                    
                }
                // value.nextId is nil
                else {
                    self.replyNextId = "-1"
                }
            }
            
            
            // 댓글 작성한 경우
            if isReplyWrite {
//                print("댓글 작성한 경우")
//                print("replyNextId : \(self.replyNextId)")
                
                // 1. 모든 댓글 리스트 받아옴
                // (작성한 댓글은 리스트 맨 뒤에서 보내지기 때문에,
                // 만약 전체 페이지 5에서, 3페이지까지 로딩되어 있는 상태라면,
                // 나머지 4,5페이지까지 받아야 됨)
                if self.replyNextId != "-1" {
                    self.getClubDetailReply(
                        clubId: clubId,
                        categoryCode: categoryCode,
                        postId: postId,
                        integUid: integUid,
                        access_token: access_token,
                        size: size,
                        isReplyWrite: true
                    )
                }
                // 2. 모든 댓글 리스트 다 받아왔으면, 작성한 댓글 보여주기 위해 리스트 맨 아래로 내림
                else {
                    CommonFunction.offPageLoading()
                    
                    if self.replyList.count > 0 {
                        self.isReplyComplete = true
                    }
                }
                
                
            }
            
            
        }
        .store(in: &canclelables)
    }
    
    func setPassedInfo(postId: Int, clubId: String, categoryCode: String) {
        self.postId = postId
        self.clubId = clubId
        self.categoryCode = categoryCode
    }
    
    
    /**
     * 이미지 업로드
     */
    func requestUploadImage(image:UIImage, result:@escaping(String) -> Void) {
        CommonFunction.onPageLoading()
        
        ApiControl.uploadImage(image: image)
            .sink { error in
                CommonFunction.offPageLoading()
                
                guard case let .failure(error) = error else { return }
                print("\n--- userInfoUpdate error ---\n\(error.localizedDescription)\n")
                //self.alertMessage = error.message
                self.showAlert = true
                
                result("")
                
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                if value.success, value.result.id.count > 0 {
                    result(value.result.id)
                }
                else {
                    //self.alertMessage = ErrorHandler.getCommonMessage()
                    self.showAlert = true
                    
                    result("")
                }
            }.store(in: &canclelables)
    }
    
    
    /**
     * 댓글 글쓰기
     */
    func postReply(clubId: String, categoryCode: String, postId: Int, langCode: String, imageName: String, mediaType: String, replyTxt: String, integUid: String, access_token: String, isPostComplete: ((Bool) -> Void)?) {
        
        CommonFunction.onPageLoading()
        
        ApiControl.postClubReply(clubId: clubId, categoryCode: categoryCode, postId: postId, langCode: langCode, imageName: imageName, mediaType: mediaType, replyTxt: replyTxt, integUid: integUid, access_token: access_token)
            .sink { error in
                CommonFunction.offPageLoading()
            } receiveValue: { _ in
                CommonFunction.offPageLoading()

                guard let NOisPostComplete = isPostComplete else { return }
                NOisPostComplete(true)
            }
            .store(in: &canclelables)
    }
    
    
    /**
     * 북마크 조회
     */
    func fetchBookmark(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String) {
        ApiControl.fetchClubDetailBookmark(
            clubId: clubId,
            categoryCode: categoryCode,
            postId: postId,
            integUid: integUid,
            access_token: access_token
        )
        .sink { error in
            //
        } receiveValue: { value in
            
            self.bookmarkModel = value
            
            if let NObookmarkModel = self.bookmarkModel {
                self.bookmark = NObookmarkModel.bookmarkYn
            }
        }
        .store(in: &canclelables)
    }
    
    /**
     * 북마크 변경
     */
    func patchBookmark(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String) {
        ApiControl.patchClubDetailBookmark(
            clubId: clubId,
            categoryCode: categoryCode,
            postId: postId,
            integUid: integUid,
            access_token: access_token
        )
        .sink { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                self.bookmarkError = error
                
                if let NObookmarkError = self.bookmarkError {
                    self.showbookmarkErrorAlert = true
                    self.bookmarkErrorMsg = NObookmarkError.msg ?? ""
                }
            }
            
        } receiveValue: { value in
            
            self.bookmarkModel = value
            
            if let NObookmarkModel = self.bookmarkModel {
                self.bookmark = NObookmarkModel.bookmarkYn
            }
        }
        .store(in: &canclelables)
    }
    
    /**
     * 번역
     */
    func getTrans(language: String, messages: [TransMessagesReq]) {
        ApiControl.trans(language: language, messages: messages)
            .sink { error in
                
            } receiveValue: { value in
                CommonFunction.offPageLoading()
                
                self.transData = value
                guard let NOtransData = self.transData else {
                    // The 'value' is nil
                    return
                }

                if NOtransData.status == "success" {
                    self.transResultLists = NOtransData.messages

                    guard let NObodyContent = self.clubDetailModel else {
                        return
                    }

                    for (index, element) in self.transResultLists.enumerated() {

                        if index == 0, NObodyContent.subject == element.origin {
                            self.title_afterTrans = element.text
                        }
                        else if index == 1, NObodyContent.content == element.origin {
                            self.content_afterTrans = element.text
                        }
                            }

                    self.isTransMode = true
                }
                else {
                    // 번역 실패
                    self.isTransFail = true
                }
            }
            .store(in: &canclelables)
    }
    
    func resetReplyImage() {
        pickedImage = ""
    }
    
    func resetReplyAll() {
        txtReply = ""
        //pickedImage = UIImage()
        pickedImage = ""
    }
    
}
