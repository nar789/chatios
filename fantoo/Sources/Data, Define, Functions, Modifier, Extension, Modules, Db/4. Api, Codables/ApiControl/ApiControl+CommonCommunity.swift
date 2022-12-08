//
//  ApiControl+CommonCommunity.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/25.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    /**
     * 커뮤니티 게시글 - 좋아요/싫어요
     */
    static func postCommunityLike(likeType: String, targetType: String, targetId: Int, integUid: String, access_token: String) -> AnyPublisher<Community_Like, ErrorModel> {
        Future<Community_Like, ErrorModel> { promise in
            
            let apis: ApisCommonCommunity = .Like(likeType: likeType, targetType: targetType, targetId: targetId, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommonCommunity>()
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

                        let result = try?
                        JSONDecoder().decode(Community_Like.self, from: response.data)
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
     * 커뮤니티 게시글 - 좋아요/싫어요 취소
     */
    static func deleteCommunityLike(targetType: String, targetId: Int, integUid: String, access_token: String) -> AnyPublisher<Community_Like, ErrorModel> {
        Future<Community_Like, ErrorModel> { promise in
            
            let apis: ApisCommonCommunity = .DeleteLike(targetType: targetType, targetId: targetId, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommonCommunity>()
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

                        let result = try?
                        JSONDecoder().decode(Community_Like.self, from: response.data)
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
     * 카테고리 팬투 추천순 (회원)
     */
    static func getMemberRecogCategory(integUid: String, access_token: String) -> AnyPublisher<DataObj_CategoryFantooMember, ErrorModel> {
        Future<DataObj_CategoryFantooMember, ErrorModel> { promise in
            let apis: ApisCommonCommunity = .MemberRecogCategory(integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommonCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(DataObj_CategoryFantooMember.self, from: response.data)
                        
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
    
    
    /**
     * 카테고리 Sub (회원)
     */
    static func getMemberSubCategory(code: String, integUid: String, access_token: String) -> AnyPublisher<CommunitySubcategoryMember, ErrorModel> {
        Future<CommunitySubcategoryMember, ErrorModel> { promise in
            let apis: ApisCommonCommunity = .MemberSubCategory(code: code, integUid: integUid, access_token: access_token)
            
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }

                //call
                let provider = MoyaProvider<ApisCommonCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in

                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())

                        let result = try? JSONDecoder().decode(CommunitySubcategoryMember.self, from: response.data)

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
