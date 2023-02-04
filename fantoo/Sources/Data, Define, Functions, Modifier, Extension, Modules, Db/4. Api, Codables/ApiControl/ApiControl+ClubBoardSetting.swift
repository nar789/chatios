//
//  ApiControl+ClubBoardSetting.swift
//  fantoo
//
//  Created by fns on 2022/12/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//


import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    static func clubBoardCategoryList(categoryCode: String, clubId: String, integUid: String) -> AnyPublisher<ClubBoardCategoryData, ErrorModel> {
        Future<ClubBoardCategoryData, ErrorModel> { promise in
            let provider = MoyaProvider<ApisClubBoardSetting>()
            let apis: ApisClubBoardSetting = .ClubBoardCategoryList(categoryCode: categoryCode, clubId: clubId, integUid: integUid)
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
                    
                    let result = try? JSONDecoder().decode(ClubBoardCategoryData.self, from: response.data)
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
    
    static func createClubBoardList(categoryCode: String, clubId: String, boardType: Int, categoryName: String, integUid: String, openYn: Bool) -> AnyPublisher<CreateClubBoardListData, ErrorModel> {
        Future<CreateClubBoardListData, ErrorModel> { promise in
            let provider = MoyaProvider<ApisClubBoardSetting>()
            let apis: ApisClubBoardSetting = .CreateClubBoardList(categoryCode: categoryCode, clubId: clubId, boardType: boardType, categoryName: categoryName, integUid: integUid, openYn: openYn)
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
                    
                    let result = try? JSONDecoder().decode(CreateClubBoardListData.self, from: response.data)
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
    
    static func deleteClubBoardList(categoryCode: String, clubId: String, integUid: String) -> AnyPublisher<ResultModel, ErrorModel> {
        Future<ResultModel, ErrorModel> { promise in
            let provider = MoyaProvider<ApisClubBoardSetting>()
            let apis: ApisClubBoardSetting = .DeleteClubBoardList(categoryCode: categoryCode, clubId: clubId, integUid: integUid)
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
                    
//                    let result = try? JSONDecoder().decode(ResultModel.self, from: response.data)
//                    if result != nil {
//                        promise(.success(result!))
//                    }
//                    else {
//                        promise(.failure(ErrorModel(code: "error")))
//                    }
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func settingClubBoardList(categoryCode: String, clubId: String, boardType: Int, categoryName: String, integUid: String, openYn: Bool) -> AnyPublisher<ResultModel, ErrorModel> {
        Future<ResultModel, ErrorModel> { promise in
            let provider = MoyaProvider<ApisClubBoardSetting>()
            let apis: ApisClubBoardSetting = .SettingClubBoardCategoryList(categoryCode: categoryCode, clubId: clubId, boardType: boardType, categoryName: categoryName, integUid: integUid, openYn: openYn)
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
                    
//                    let result = try? JSONDecoder().decode(ResultModel.self, from: response.data)
//                    if result != nil {
//                        promise(.success(result!))
//                    }
//                    else {
//                        promise(.failure(ErrorModel(code: "error")))
//                    }
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func clubBoardListSortSetting(categoryCode: String, clubId: String, categoryNameList: [String], integUid: String) -> AnyPublisher<ResultModel, ErrorModel> {
        Future<ResultModel, ErrorModel> { promise in
            let provider = MoyaProvider<ApisClubBoardSetting>()
            let apis: ApisClubBoardSetting = .ClubBoardListSortSetting(categoryCode: categoryCode, clubId: clubId, categoryNameList: categoryNameList, integUid: integUid)
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
                    
//                    let result = try? JSONDecoder().decode(ResultModel.self, from: response.data)
//                    if result != nil {
//                        promise(.success(result!))
//                    }
//                    else {
//                        promise(.failure(ErrorModel(code: "error")))
//                    }
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
}
