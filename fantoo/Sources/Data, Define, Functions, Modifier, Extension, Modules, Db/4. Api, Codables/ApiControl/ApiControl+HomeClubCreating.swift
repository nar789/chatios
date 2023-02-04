//
//  ApiControl+HomeClubCreating.swift
//  fantoo
//
//  Created by fns on 2022/11/02.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    static func creatingClubNameCheck(clubName: String) -> AnyPublisher<ClubNameCheckData, ErrorModel> {
        Future<ClubNameCheckData, ErrorModel> { promise in
            
            let apis: ApisHomeClubCreating = .CreatingClubNameCheck(clubName: clubName)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubCreating>()
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
                        
                        let result = try? JSONDecoder().decode(ClubNameCheckData.self, from: response.data)
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

    static func creatingClub(activeCountryCode: String, bgImg: String, checkToken: String, clubName: String, integUid: String, interestCategoryId: Int, languageCode: String, memberJoinAutoYn: Bool, openYn: Bool, profileImg: String) -> AnyPublisher<CreatingClubData, ErrorModel> {
        Future<CreatingClubData, ErrorModel> { promise in
            
            let apis: ApisHomeClubCreating = .CreatingClub(activeCountryCode: activeCountryCode, bgImg: bgImg, checkToken: checkToken, clubName: clubName, integUid: integUid, interestCategoryId: interestCategoryId, languageCode: languageCode, memberJoinAutoYn: memberJoinAutoYn, openYn: openYn, profileImg: profileImg)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubCreating>()
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
                        
                        let result = try? JSONDecoder().decode(CreatingClubData.self, from: response.data)
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

    static func clubInterestList() -> AnyPublisher<ClubInterestModel, ErrorModel> {
        Future<ClubInterestModel, ErrorModel> { promise in
            
            let apis: ApisHomeClubCreating = .ClubInterestList
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubCreating>()
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
                        
                        let result = try? JSONDecoder().decode(ClubInterestModel.self, from: response.data)
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
