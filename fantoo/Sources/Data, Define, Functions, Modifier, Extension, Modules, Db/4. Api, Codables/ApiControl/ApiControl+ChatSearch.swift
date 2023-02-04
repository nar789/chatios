import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    static func chatSearchUser(accessToken: String, integUid: String, keyword: String) -> AnyPublisher<ChatSearchListModel, ErrorModel> {
        Future<ChatSearchListModel, ErrorModel> { promise in
            
            let apis: ApisChatSearch = .Search(accessToken: accessToken, integUid: integUid, keyword: keyword)
            //call
            let provider = MoyaProvider<ApisChatSearch>()
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
                    
                    let result = try? JSONDecoder().decode(ChatSearchListModel.self, from: response.data)
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
