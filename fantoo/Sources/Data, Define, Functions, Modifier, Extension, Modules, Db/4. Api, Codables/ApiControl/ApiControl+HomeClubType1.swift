//
//  ApiControl+FantooTVClub.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/17.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    /**
     * 팬투TV & 한류타임즈 - 상단 상세설명
     */
    static func getHomeClubType1DetailTop(clubId: String) -> AnyPublisher<Club_DetailTopModel, ErrorModel> {
        Future<Club_DetailTopModel, ErrorModel> { promise in
            
            let apis: ApisHomeClubType1 = .DetailTop(clubId: clubId)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubType1>()
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
                        
                        let result = try? JSONDecoder().decode(Club_DetailTopModel.self, from: response.data)
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
     * 팬투TV & 한류타임즈 - 팔로우
     */
    static func getHomeClubType1FollowInfo(clubId: String, integUid: String, access_token: String) -> AnyPublisher<Club_FollowModel, ErrorModel> {
        Future<Club_FollowModel, ErrorModel> { promise in
            
            let apis: ApisHomeClubType1 = .FollowInfo(clubId: clubId, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubType1>()
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
                        
                        let result = try? JSONDecoder().decode(Club_FollowModel.self, from: response.data)
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
     * 팬투TV & 한류타임즈 - 탭 정보
     */
    static func getHomeClubType1TabInfo(clubId: String, integUid: String) -> AnyPublisher<Club_TabInfoModel, ErrorModel> {
        Future<Club_TabInfoModel, ErrorModel> { promise in
            
            let apis: ApisHomeClubType1 = .TabInfo(clubId: clubId, integUid: integUid)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubType1>()
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
                        
                        let result = try? JSONDecoder().decode(Club_TabInfoModel.self, from: response.data)
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
     * 팬투TV & 한류타임즈 - 홈 탭
     */
    static func getHomeClubType1HomeTab(clubId: String, categoryCode: String, integUid: String, nextId: Int?, size: Int?) -> AnyPublisher<Club_TabHomeModel, ErrorModel> {
        Future<Club_TabHomeModel, ErrorModel> { promise in
            
            let apis: ApisHomeClubType1 = .HomeTab(clubId: clubId, categoryCode: categoryCode, integUid: integUid, nextId: nextId, size: size)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubType1>()
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
                        
                        let result = try? JSONDecoder().decode(Club_TabHomeModel.self, from: response.data)
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
     * 팬투TV & 한류타임즈 - 카테고리 탭
     */
    static func getHomeClubType1CategoryTab(clubId: String, integUid: String, categoryCode: String) -> AnyPublisher<ClubCategoryModel, ErrorModel> {
        Future<ClubCategoryModel, ErrorModel> { promise in
            
            let apis: ApisHomeClubType1 = .ChannelTab(clubId: clubId, integUid: integUid, categoryCode: categoryCode)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubType1>()
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
                        
                        let result = try? JSONDecoder().decode(ClubCategoryModel.self, from: response.data)
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
     * 클럽 게시글 - 좋아요/싫어요
     */
    static func patchClubLike(clubId: String, likeType: String, categoryCode: String, url_postId: Int, integUid: String, access_token: String) -> AnyPublisher<Club_Like, ErrorModel> {
        Future<Club_Like, ErrorModel> { promise in
            
            let apis: ApisHomeClubType1 = .Like(clubId: clubId, likeType: likeType, categoryCode: categoryCode, url_postId: url_postId, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubType1>()
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
                        JSONDecoder().decode(Club_Like.self, from: response.data)
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
    
    
    
}
