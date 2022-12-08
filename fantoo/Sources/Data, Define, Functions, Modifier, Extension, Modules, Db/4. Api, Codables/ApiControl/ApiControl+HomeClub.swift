//
//  ApiControl+HomeClub.swift
//  fantoo
//
//  Created by kimhongpil on 2022/08/18.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {

    static func getHomeClub_TabHome() -> AnyPublisher<HomeClub_TabHomeModel, ErrorModel> {
        Future<HomeClub_TabHomeModel, ErrorModel> { promise in
            
            let apis: ApisHomeClub = .TabHome
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClub>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(HomeClub_TabHomeModel.self, from: response.data)
                        
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
    
    
    static func getHomeClub_TabFreeboard() -> AnyPublisher<HomeClub_TabFreeboardModel, ErrorModel> {
        Future<HomeClub_TabFreeboardModel, ErrorModel> { promise in
            
            let apis: ApisHomeClub = .TabFreeBoard
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClub>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(HomeClub_TabFreeboardModel.self, from: response.data)
                        
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
    
    static func getHomeClub_TabArchive() -> AnyPublisher<HomeClub_TabArchiveModel, ErrorModel> {
        Future<HomeClub_TabArchiveModel, ErrorModel> { promise in
            
            let apis: ApisHomeClub = .TabArchive
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClub>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(HomeClub_TabArchiveModel.self, from: response.data)
                        
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
    
    static func getHomeClub_TabBank() -> AnyPublisher<HomeClub_TabBankModel, ErrorModel> {
        Future<HomeClub_TabBankModel, ErrorModel> { promise in
            
            let apis: ApisHomeClub = .TabBank
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClub>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(HomeClub_TabBankModel.self, from: response.data)
                        
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
