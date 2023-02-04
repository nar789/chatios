//
//  ApiControl+MainTabHome.swift
//  fantoo
//
//  Created by kimhongpil on 2022/05/26.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    static func getMainHomeTab_Home(page: Int=1, pages: Int=10) -> AnyPublisher<MainHomeTabHome, ErrorModel> {
        Future<MainHomeTabHome, ErrorModel> { promise in
            
            let apis: ApisHome = .MainTabHome_Home(page: page, pages: pages)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHome>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())

                        let result = try? JSONDecoder().decode(MainHomeTabHome.self, from: response.data)

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
    
    static func getMainHomeTab_Popular(page: Int=1, pages: Int=10) -> AnyPublisher<MainHomeTabPopular, ErrorModel> {
        Future<MainHomeTabPopular, ErrorModel> { promise in
            
            let apis: ApisHome = .MainTabHome_Popular(page: page, pages: pages)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHome>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(MainHomeTabPopular.self, from: response.data)
                        
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
        
        static func getMainTabHome_PopularTrending(size: Int) -> AnyPublisher<MainHomeTabPopularTrending, ErrorModel> {
            Future<MainHomeTabPopularTrending, ErrorModel> { promise in
                let provider = MoyaProvider<ApisHome>()
                let apis: ApisHome = .MainTabHome_PopularTrending(size: size)
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
                        
                        let result = try? JSONDecoder().decode(MainHomeTabPopularTrending.self, from: response.data)
                        if result != nil {
                            promise(.success(result!))
                        }
                        else {
                            promise(.failure(ErrorModel(code: "error")))
                        }
                    })
                    .store(in: &canclelables)
            }
            .eraseToAnyPublisher()
        }
    
    static func getMainHome_Home(integUid: String, nextId: String, size: Int) -> AnyPublisher<MainHomeData, ErrorModel> {
        Future<MainHomeData, ErrorModel> { promise in
            let provider = MoyaProvider<ApisHome>()
            let apis: ApisHome = .MainHome_Home(integUid: integUid, nextId: nextId, size: size)
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
                    
                    let result = try? JSONDecoder().decode(MainHomeData.self, from: response.data)
                    if result != nil {
                        promise(.success(result!))
                    }
                    else {
                        promise(.failure(ErrorModel(code: "error")))
                    }
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func getMainHome_Popular(integUid: String, nextId: String, size: Int) -> AnyPublisher<MainHomeData, ErrorModel> {
        Future<MainHomeData, ErrorModel> { promise in
            let provider = MoyaProvider<ApisHome>()
            let apis: ApisHome = .MainHome_Popular(integUid: integUid, nextId: nextId, size: size)
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
                    
                    let result = try? JSONDecoder().decode(MainHomeData.self, from: response.data)
                    if result != nil {
                        promise(.success(result!))
                    }
                    else {
                        promise(.failure(ErrorModel(code: "error")))
                    }
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
}
