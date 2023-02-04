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
    
    static func getHomeClub_Login(clubId: String) -> AnyPublisher<ClubHomeLoginResponse, ErrorModel> {
        Future<ClubHomeLoginResponse, ErrorModel> { promise in
            
            let apis: ApisHomeClub = .ClubLogin(clubId: clubId,
                                                intergUid: UserManager.shared.uid,
                                                accessToken: UserManager.shared.accessToken)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClub>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        var result: ClubHomeLoginResponse? = nil
                        do {
                            result = try JSONDecoder().decode(ClubHomeLoginResponse.self, from: response.data)
                        } catch {
                            print("getHomeClub_login error : \(error)")
                        }
                        
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
    
    static func getHomeClub_Visit(clubId: String) -> AnyPublisher<String, ErrorModel> {
        Future<String, ErrorModel> { promise in
            
            let apis: ApisHomeClub = .ClubVisit(clubId: clubId,
                                                intergUid: UserManager.shared.uid)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClub>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        var result: String? = nil
                        if response.statusCode == 200 {
                            result = "OK"
                        }
                        
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
    
    static func getHomeClub_BasicInfo(clubId: String) -> AnyPublisher<HomeClub_Basic_Info, ErrorModel> {
        Future<HomeClub_Basic_Info, ErrorModel> { promise in
            
            let apis: ApisHomeClub = .ClubBasicInfo(clubId: clubId, intergUid: UserManager.shared.uid)
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
                        var result: HomeClub_Basic_Info? = nil
                        do {
                            result = try JSONDecoder().decode(HomeClub_Basic_Info.self, from: response.data)
                        } catch {
                            print("getHomeClub_BasicInfo error : \(error)")
                        }
                        
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
    
    static func getHomeClub_Category(clubId: String, categoryCode: String? = nil) -> AnyPublisher<HomeClub_CategoryModel, ErrorModel> {
        Future<HomeClub_CategoryModel, ErrorModel> { promise in
            
            let apis: ApisHomeClub = .ClubCategory(
                clubId: clubId,
                categoryCode: categoryCode,
                integUid: UserManager.shared.uid
            )
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
                        var result: HomeClub_CategoryModel? = nil
                        do {
                            result = try JSONDecoder().decode(HomeClub_CategoryModel.self, from: response.data)
                        } catch {
                            print("getHomeClub_Category error : \(error)")
                        }
                        
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

    static func getHomeClub_TabHome() -> AnyPublisher<HomeClub_TabHomeModel, ErrorModel> {
        Future<HomeClub_TabHomeModel, ErrorModel> { promise in
            
            let apis: ApisHomeClub = .TabHomeDummy
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
    
    static func getHomeClub_TabHome(clubId: String, nextId: Int? = nil, size: Int = 10) -> AnyPublisher<HomeClub_TabHome_Response, ErrorModel> {
        Future<HomeClub_TabHome_Response, ErrorModel> { promise in
            
            let apis: ApisHomeClub = .TabHome(
                clubId: clubId,
                integUid: UserManager.shared.uid,
                nextId: nextId,
                size: size
            )
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
                        if response.statusCode == 403 {
                            let error = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            promise(.failure(error ?? ErrorModel(code: "error")))
                        } else {
                            var result: HomeClub_TabHome_Response? = nil
                            do {
                                result = try JSONDecoder().decode(HomeClub_TabHome_Response.self, from: response.data)
                            } catch {
                                print("getHomeClub_TabHome error : \(error)")
                            }
                            if result != nil {
                                promise(.success(result!))
                            } else {
                                promise(.failure(ErrorModel(code: "error")))
                            }
                        }
                       
                    })
                    .store(in: &canclelables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func getHomeClub_Board(clubId: String, categoryCode: String, nextId: Int? = nil, size: Int = 10) -> AnyPublisher<HomeClub_Board_Model, ErrorModel> {
        Future<HomeClub_Board_Model, ErrorModel> { promise in
            
            let apis: ApisHomeClub = .ClubBoard(
                clubId: clubId,
                categoryCode: categoryCode,
                integUid: UserManager.shared.uid,
                nextId: nextId,
                size: size
            )
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
                        if response.statusCode == 403 {
                            let error = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                            promise(.failure(error ?? ErrorModel(code: "error")))
                        } else {
                            var result: HomeClub_Board_Model? = nil
                            do {
                                result = try JSONDecoder().decode(HomeClub_Board_Model.self, from: response.data)
                            } catch {
                                print("getHomeClub_Board error : \(error)")
                            }
                            
                            if result != nil {
                                promise(.success(result!))
                            } else {
                                promise(.failure(ErrorModel(code: "error")))
                            }
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
