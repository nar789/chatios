
import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    static func chatMyFollow(accessToken: String, integUid: String) -> AnyPublisher<ChatMyFollowModel, ErrorModel> {
        Future<ChatMyFollowModel, ErrorModel> { promise in
            
            let apis: ApisChatMyFollow = .MyFollow(accessToken: accessToken, integUid: integUid)
            //call
            let provider = MoyaProvider<ApisChatMyFollow>()
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
                    
                    let result = try? JSONDecoder().decode(ChatMyFollowModel.self, from: response.data)
                    if result != nil {
                        print(result!)
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
