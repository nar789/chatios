


import Foundation
import CombineMoya
import Moya
import Combine



extension ApiControl {
    
    static func chatUnfollow(accessToken: String, integUid: String) -> AnyPublisher<Bool, ErrorModel> {
        Future<Bool, ErrorModel> { promise in
            
            let apis: ApisChatFollow = .unfollow(accessToken: accessToken, targetUid: integUid)
            //call
            let provider = MoyaProvider<ApisChatFollow>()
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
    
    static func chatFollow(accessToken: String, integUid: String) -> AnyPublisher<Bool, ErrorModel> {
        Future<Bool, ErrorModel> { promise in
            
            let apis: ApisChatFollow = .follow(accessToken: accessToken, targetUid: integUid)
            //call
            let provider = MoyaProvider<ApisChatFollow>()
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
