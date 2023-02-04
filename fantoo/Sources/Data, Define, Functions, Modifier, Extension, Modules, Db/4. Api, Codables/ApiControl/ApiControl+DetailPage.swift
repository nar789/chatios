//
//  ApiControl+DetailPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/09/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    /**
     * 게시글 Detail (회원)
     */
    static func getCommunityDetail(integUid: String, access_token: String, code: String, postId: Int) -> AnyPublisher<CommunityDetailModel, ErrorModel> {
        Future<CommunityDetailModel, ErrorModel> { promise in
            
            let apis: ApisDetailPage = .CommunityDetail(integUid: integUid, access_token: access_token, code: code, postId: postId)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisDetailPage>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        //error check start --------------------------------------------------------------------------------
                        if ErrorHandler.checkAuthError(code: response.statusCode) {
                            return
                        }
                        
                        if response.statusCode != 200 {
                            let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            if result != nil {
                                promise(.failure(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }
                            
                            return
                        }
                        //error check end --------------------------------------------------------------------------------
                        
                        let result = try? JSONDecoder().decode(CommunityDetailModel.self, from: response.data)
                        if result != nil {
                            promise(.success(result!))
                        }
                        else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                    })
                    .store(in: &canclelables)
            }
            
            
        }
        .eraseToAnyPublisher()
    }
    /**
     * 게시글 댓글 List (회원)
     */
    static func getCommunityDetailReply(integUid: String, access_token: String, postId: Int, size: Int, nextPage: Int) -> AnyPublisher<CommunityDetailReplyModel, ErrorModel> {
        Future<CommunityDetailReplyModel, ErrorModel> { promise in
            
            let apis: ApisDetailPage = .CommunityDetailReply(integUid: integUid, access_token: access_token, postId: postId, size: size, nextPage: nextPage)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisDetailPage>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        //error check start --------------------------------------------------------------------------------
                        if ErrorHandler.checkAuthError(code: response.statusCode) {
                            return
                        }
                        
                        if response.statusCode != 200 {
                            let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            if result != nil {
                                promise(.failure(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }
                            
                            return
                        }
                        //error check end --------------------------------------------------------------------------------
                        
                        let result = try? JSONDecoder().decode(CommunityDetailReplyModel.self, from: response.data)
                        if result != nil {
                            promise(.success(result!))
                        }
                        else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                    })
                    .store(in: &canclelables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    /**
     * 커뮤니티 댓글 쓰기
     */
    static func postCommunityReply(postId: Int, anonymYn: Bool, imageName: String, mediaType: String, content: String, integUid: String, access_token: String) -> AnyPublisher<ResultModel, ErrorModel> {
        Future<ResultModel, ErrorModel> { promise in
            
            let apis: ApisDetailPage = .CommunityPostReply(postId: postId, anonymYn: anonymYn, imageName: imageName, mediaType: mediaType, content: content, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisDetailPage>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())

                        //error check start --------------------------------------------------------------------------------
                        if ErrorHandler.checkAuthError(code: response.statusCode) {
                            return
                        }

                        if response.statusCode != 200 {
                            let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            if result != nil {
                                promise(.failure(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }

                            return
                        }
                        //error check end --------------------------------------------------------------------------------

                        promise(.success(ResultModel(success: true)))
//                        let result = try?
//                        JSONDecoder().decode(ResultEmptyModel.self, from: response.data)
//                        print("idpilLog::: result : \(result)" as String)
//                        if result != nil {
//                            promise(.success(result!))
//                        }
//                        else {
//                            promise(.failure(ErrorModel(code: "error")))
//                        }
                    })
                    .store(in: &canclelables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    /**
     * 커뮤니티 북마크 등록
     */
    static func postCommunityBookmark(postId: Int, integUid: String, access_token: String) -> AnyPublisher<ResultModel, ErrorModel> {
        Future<ResultModel, ErrorModel> { promise in
            let apis: ApisDetailPage = .CommunityPostBookmark(postId: postId, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisDetailPage>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())

                        //error check start --------------------------------------------------------------------------------
                        if ErrorHandler.checkAuthError(code: response.statusCode) {
                            return
                        }

                        if response.statusCode != 200 {
                            let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            if result != nil {
                                promise(.failure(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }

                            return
                        }
                        //error check end --------------------------------------------------------------------------------

                        promise(.success(ResultModel(success: true)))
                    })
                    .store(in: &canclelables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    /**
     * 커뮤니티 북마크 삭제
     */
    static func deleteCommunityBookmark(postId: Int, integUid: String, access_token: String) -> AnyPublisher<ResultModel, ErrorModel> {
        Future<ResultModel, ErrorModel> { promise in
            let apis: ApisDetailPage = .CommunityDeleteBookmark(postId: postId, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisDetailPage>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())

                        //error check start --------------------------------------------------------------------------------
                        if ErrorHandler.checkAuthError(code: response.statusCode) {
                            return
                        }

                        if response.statusCode != 200 {
                            let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            if result != nil {
                                promise(.failure(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }

                            return
                        }
                        //error check end --------------------------------------------------------------------------------

                        promise(.success(ResultModel(success: true)))
                    })
                    .store(in: &canclelables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    
    
    /**
     * Club DetailPage
     */
    static func getClubDetail(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String) -> AnyPublisher<ClubDetailModel, ErrorModel> {
        Future<ClubDetailModel, ErrorModel> { promise in
            
            let apis: ApisDetailPage = .ClubDetail(clubId: clubId, categoryCode: categoryCode, postId: postId, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisDetailPage>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())

                        //error check start --------------------------------------------------------------------------------
                        if ErrorHandler.checkAuthError(code: response.statusCode) {
                            return
                        }

                        if response.statusCode != 200 {
                            let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            if result != nil {
                                promise(.failure(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }

                            return
                        }
                        //error check end --------------------------------------------------------------------------------

                        let result = try? JSONDecoder().decode(ClubDetailModel.self, from: response.data)
                        if result != nil {
                            promise(.success(result!))
                        }
                        else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                    })
                    .store(in: &canclelables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    /**
     * Club DetailPage Reply
     */
    static func getClubDetailReply(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String, nextId: String, size: String) -> AnyPublisher<ClubDetailReplyModel, ErrorModel> {
        Future<ClubDetailReplyModel, ErrorModel> { promise in
            
            let apis: ApisDetailPage = .ClubDetailReply(clubId: clubId, categoryCode: categoryCode, postId: postId, integUid: integUid, access_token: access_token, nextId: nextId, size: size)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisDetailPage>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())

                        //error check start --------------------------------------------------------------------------------
                        if ErrorHandler.checkAuthError(code: response.statusCode) {
                            return
                        }

                        if response.statusCode != 200 {
                            let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            if result != nil {
                                promise(.failure(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }

                            return
                        }
                        //error check end --------------------------------------------------------------------------------

                        let result = try? JSONDecoder().decode(ClubDetailReplyModel.self, from: response.data)
                        if result != nil {
                            promise(.success(result!))
                        }
                        else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                    })
                    .store(in: &canclelables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    /**
     * 북마크 조회
     */
    static func fetchClubDetailBookmark(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String) -> AnyPublisher<ClubDetailModel_BookMark, ErrorModel> {
        Future<ClubDetailModel_BookMark, ErrorModel> { promise in
            
            let apis: ApisDetailPage = .FetchClubDetailBookmark(clubId: clubId, categoryCode: categoryCode, postId: postId, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisDetailPage>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())

                        //error check start --------------------------------------------------------------------------------
                        if ErrorHandler.checkAuthError(code: response.statusCode) {
                            return
                        }

                        if response.statusCode != 200 {
                            let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            if result != nil {
                                promise(.failure(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }

                            return
                        }
                        //error check end --------------------------------------------------------------------------------

                        let result = try? JSONDecoder().decode(ClubDetailModel_BookMark.self, from: response.data)
                        if result != nil {
                            promise(.success(result!))
                        }
                        else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                    })
                    .store(in: &canclelables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    /**
     * 북마크 변경
     */
    static func patchClubDetailBookmark(clubId: String, categoryCode: String, postId: Int, integUid: String, access_token: String) -> AnyPublisher<ClubDetailModel_BookMark, ErrorModel> {
        Future<ClubDetailModel_BookMark, ErrorModel> { promise in
            
            let apis: ApisDetailPage = .PatchClubDetailBookmark(clubId: clubId, categoryCode: categoryCode, postId: postId, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisDetailPage>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())

                        //error check start --------------------------------------------------------------------------------
                        if ErrorHandler.checkAuthError(code: response.statusCode) {
                            return
                        }

                        if response.statusCode != 200 {
                            let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            if result != nil {
                                promise(.failure(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }

                            return
                        }
                        //error check end --------------------------------------------------------------------------------

                        let result = try? JSONDecoder().decode(ClubDetailModel_BookMark.self, from: response.data)
                        if result != nil {
                            promise(.success(result!))
                        }
                        else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                    })
                    .store(in: &canclelables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    /**
     * 클럽 댓글 쓰기
     */
    static func postClubReply(clubId: String, categoryCode: String, postId: Int, langCode: String, imageName: String, mediaType: String, replyTxt: String, integUid: String, access_token: String) -> AnyPublisher<ClubDetailReplyModel_ReplyList, ErrorModel> {
        Future<ClubDetailReplyModel_ReplyList, ErrorModel> { promise in
            
            let apis: ApisDetailPage = .ClubPostReply(clubId: clubId, categoryCode: categoryCode, postId: postId, langCode: langCode, imageName: imageName, mediaType: mediaType, replyTxt: replyTxt, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisDetailPage>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())

                        //error check start --------------------------------------------------------------------------------
                        if ErrorHandler.checkAuthError(code: response.statusCode) {
                            return
                        }

                        if response.statusCode != 200 {
                            let result = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            if result != nil {
                                promise(.failure(result!))
                            }
                            else {
                                promise(.failure(ErrorModel(code: "error")))
                            }

                            return
                        }
                        //error check end --------------------------------------------------------------------------------

                        let result = try? JSONDecoder().decode(ClubDetailReplyModel_ReplyList.self, from: response.data)
                        if result != nil {
                            promise(.success(result!))
                        }
                        else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                    })
                    .store(in: &canclelables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**
     * 아래는 더비 API용이다.
     * 팬투2.0 API 적용 후, 삭제할 것.
     */
    /**
     * Community DetailPage
     */
    static func getCommunityDetailPage() -> AnyPublisher<CommunityDetailPageModel, ErrorModel> {
        Future<CommunityDetailPageModel, ErrorModel> { promise in
            
            let apis: ApisDetailPage = .CommunityDetailPage
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisDetailPage>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(CommunityDetailPageModel.self, from: response.data)
                        
                        if result != nil {
                            promise(.success(result!))
                        } else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                    })
                    .store(in: &canclelables)
            }
            
            
        }
        .eraseToAnyPublisher()
    }
    
    
    
}
