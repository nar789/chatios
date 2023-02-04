//
//  ApiControl+HomeClubDelegate.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/31.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    static func clubDelegateMember0(clubId: String, integUid: String) -> AnyPublisher<ClubDelegateMemberData, ErrorModel> {
        Future<ClubDelegateMemberData, ErrorModel> { promise in
            
            let apis: ApisClubSetting = .ClubDelegateMember0(clubId: clubId, integUid: integUid)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisClubSetting>()
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
                        
                        let result = try? JSONDecoder().decode(ClubDelegateMemberData.self, from: response.data)
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
    
    static func clubDelegateRequest0_Ok(clubId: String, integUid: String) -> AnyPublisher<ResultModel, ErrorModel> {
        Future<ResultModel, ErrorModel> { promise in
            
            let apis: ApisClubSetting = .ClubDelegateMember0_Ok(clubId: clubId, integUid: integUid)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisClubSetting>()
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
    
    static func clubDelegateRequest0_No(clubId: String, integUid: String) -> AnyPublisher<ResultModel, ErrorModel> {
        Future<ResultModel, ErrorModel> { promise in
            
            let apis: ApisClubSetting = .ClubDelegateMember0_No(clubId: clubId, integUid: integUid)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisClubSetting>()
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
}
