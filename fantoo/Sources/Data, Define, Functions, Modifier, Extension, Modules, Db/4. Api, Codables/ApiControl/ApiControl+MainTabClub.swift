//
//  ApiControl+MainTabClub.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    /**
     * 내 클럽
     */
    static func getMainClub_MyPage(integUid: String, nextId: String, size: String) -> AnyPublisher<MainClub_MyClub, ErrorModel> {
        
        Future<MainClub_MyClub, ErrorModel> { promise in
            let apis: ApisMainClub = .MyPage(integUid: integUid, nextId: nextId, size: size)
            
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }

                //call
                let provider = MoyaProvider<ApisMainClub>()
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

                        let result = try? JSONDecoder().decode(MainClub_MyClub.self, from: response.data)
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
     * 인기 클럽 추천 - 카테고리 리스트
     */
    static func getMainClub_Popular_Category(integUid: String) -> AnyPublisher<MainClub_Popular_Category, ErrorModel> {
        
        Future<MainClub_Popular_Category, ErrorModel> { promise in
            let apis: ApisMainClub = .PopularClubCategory(integUid: integUid)
            
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }

                //call
                let provider = MoyaProvider<ApisMainClub>()
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

                        let result = try? JSONDecoder().decode(MainClub_Popular_Category.self, from: response.data)
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
     * 인기 클럽 추천 - 카테고리별 리스트
     */
    static func getMainClub_PopularList(categoryCode: String, integUid: String) -> AnyPublisher<ClubListCommonModel, ErrorModel> {
        
        Future<ClubListCommonModel, ErrorModel> { promise in
            let apis: ApisMainClub = .PopularClub(categoryCode: categoryCode, integUid: integUid)
            
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }

                //call
                let provider = MoyaProvider<ApisMainClub>()
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

                        let result = try? JSONDecoder().decode(ClubListCommonModel.self, from: response.data)
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
     * 신규 클럽 추천
     */
    static func getMainClub_NewList(integUid: String) -> AnyPublisher<ClubListCommonModel, ErrorModel> {
        
        Future<ClubListCommonModel, ErrorModel> { promise in
            let apis: ApisMainClub = .NewClub(integUid: integUid)
            
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }

                //call
                let provider = MoyaProvider<ApisMainClub>()
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

                        let result = try? JSONDecoder().decode(ClubListCommonModel.self, from: response.data)
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
     * 인기 게시글 TOP10
     */
    static func getMainClub_PopularTop10(integUid: String) -> AnyPublisher<MainClub_Popular10, ErrorModel> {
        
        Future<MainClub_Popular10, ErrorModel> { promise in
            let apis: ApisMainClub = .PopularTop10(integUid: integUid)
            
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }

                //call
                let provider = MoyaProvider<ApisMainClub>()
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

                        let result = try? JSONDecoder().decode(MainClub_Popular10.self, from: response.data)
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
     * 인기 클럽 TOP100 (검색 페이지)
     */
    static func getMainClub_PopularClubTop100(integUid: String) -> AnyPublisher<ClubListCommonModel, ErrorModel> {
        
        Future<ClubListCommonModel, ErrorModel> { promise in
            let apis: ApisMainClub = .PopularClubTop100(integUid: integUid)
            
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }

                //call
                let provider = MoyaProvider<ApisMainClub>()
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

                        let result = try? JSONDecoder().decode(ClubListCommonModel.self, from: response.data)
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
     * 클럽 검색 (검색 페이지)
     */
    static func getMainClub_ClubSearch(keyword: String, nextId: String, size: String) -> AnyPublisher<ClubListCommonModel, ErrorModel> {
        
        Future<ClubListCommonModel, ErrorModel> { promise in
            let apis: ApisMainClub = .ClubSearch(keyword: keyword, nextId: nextId, size: size)
            
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }

                //call
                let provider = MoyaProvider<ApisMainClub>()
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

                        let result = try? JSONDecoder().decode(ClubListCommonModel.self, from: response.data)
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
