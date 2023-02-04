


import Foundation
import CombineMoya
import Moya
import Combine



extension ApiControl {
    
    
    static func chatIsBlockConversation(accessToken: String, conversationId: String) -> AnyPublisher<Bool, ErrorModel> {
        Future<Bool, ErrorModel> { promise in
            
            let apis: ApisChatBlock = .isblockconversation(accessToken: accessToken, conversationId: conversationId)
            //call
            let provider = MoyaProvider<ApisChatBlock>()
            provider.requestPublisher(apis)
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    print(error)
                    promise(.failure(ErrorModel(code: "error")))
                }, receiveValue: { response in
                    jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: true)
                    
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
                    
                    let result = try? JSONDecoder().decode(ChatBlockConversationModel.self, from: response.data)
                    if result != nil {
                        print("is block = \(result?.blockYn ?? false)")
                        promise(.success(result?.blockYn ?? false))
                    }
                    else {
                        promise(.failure(ErrorModel(code: "error")))
                    }
                    
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    
    
    
    static func chatUnblockConversation(accessToken: String, conversationId: String) -> AnyPublisher<Bool, ErrorModel> {
        Future<Bool, ErrorModel> { promise in
            
            let apis: ApisChatBlock = .unblockconversation(accessToken: accessToken, conversationId: conversationId)
            //call
            let provider = MoyaProvider<ApisChatBlock>()
            provider.requestPublisher(apis)
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    print(error)
                    promise(.failure(ErrorModel(code: "error")))
                }, receiveValue: { response in
                    jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: true)
                    
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
                    
                    promise(.success(true))
                    
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    
    static func chatBlockConversation(accessToken: String, conversationId: String) -> AnyPublisher<Bool, ErrorModel> {
        Future<Bool, ErrorModel> { promise in
            
            let apis: ApisChatBlock = .blockconversation(accessToken: accessToken, conversationId: conversationId)
            //call
            let provider = MoyaProvider<ApisChatBlock>()
            provider.requestPublisher(apis)
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    print(error)
                    promise(.failure(ErrorModel(code: "error")))
                }, receiveValue: { response in
                    jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: true)
                    
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
                    
                    promise(.success(true))
                    
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    
    
    static func chatUnblock(accessToken: String, integUid: String) -> AnyPublisher<Bool, ErrorModel> {
        Future<Bool, ErrorModel> { promise in
            
            let apis: ApisChatBlock = .unblock(accessToken: accessToken, targetUid: integUid)
            //call
            let provider = MoyaProvider<ApisChatBlock>()
            provider.requestPublisher(apis)
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    print(error)
                    promise(.failure(ErrorModel(code: "error")))
                }, receiveValue: { response in
                    jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: true)
                    
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
                    
                    promise(.success(true))
                    
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func chatBlock(accessToken: String, integUid: String) -> AnyPublisher<Bool, ErrorModel> {
        Future<Bool, ErrorModel> { promise in
            
            let apis: ApisChatBlock = .block(accessToken: accessToken, targetUid: integUid)
            //call
            let provider = MoyaProvider<ApisChatBlock>()
            provider.requestPublisher(apis)
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    print(error)
                    promise(.failure(ErrorModel(code: "error")))
                }, receiveValue: { response in
                    jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: true)
                    
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
                    
                    promise(.success(true))
                    
                })
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    
}
