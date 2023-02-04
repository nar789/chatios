
import Foundation
import CombineMoya
import Moya
import Combine



extension ApiControl {
    
    
    static func chatTranslate(id:String, text:String, user:String) -> AnyPublisher<String, ErrorModel> {
        Future<String, ErrorModel> { promise in
            
            let apis: ApisChatTranslate = .translate(id: id, text: text, user: user)
            //call
            let provider = MoyaProvider<ApisChatTranslate>()
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
                    
                    let result = try? JSONDecoder().decode(ChatTranslateModel.self, from: response.data)
                    if result != nil {
                        let messages:[ChatTranslateMessageModel] = result!.messages
                        if messages.count > 0 {
                            let text = messages[0].text
                            promise(.success(text))
                        }
                        promise(.failure(ErrorModel(code: "error")))
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
