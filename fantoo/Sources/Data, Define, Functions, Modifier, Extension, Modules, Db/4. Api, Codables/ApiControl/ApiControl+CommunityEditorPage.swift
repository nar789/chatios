//
//  ApiControl+CommunityEditorPage.swift
//  fantoo
//
//  Created by kimhongpil on 2022/10/27.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    /**
     * 커뮤니티 게시글 쓰기
     */
    static func postCommunityBoard(code: String, anonymYn: Bool, attachList: [CommonReplyModel_AttachList], content: String, hashtagList: [Community_hashtagList], integUid: String, subCode: String, title: String, access_token: String) -> AnyPublisher<ResultModel, ErrorModel> {
        Future<ResultModel, ErrorModel> { promise in
            
            let apis: ApisCommunityEditorPage = .PostBoard(code: code, anonymYn: anonymYn, attachList: attachList, content: content, hashtagList: hashtagList, integUid: integUid, subCode: subCode, title: title, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunityEditorPage>()
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
//                        let result = try?
//                        JSONDecoder().decode(ResultEmptyModel.self, from: response.data)
//                        print("idpilLog::: result : \(result)" as String)
//                        if result != nil {
//                            promise(.success(result!))
//                        }
//                        else {
//                            promise(.failure(ErrorModel(code: "error")))
//                        }
                    })
                    .store(in: &canclelables)
            }
            
            
        }
        .eraseToAnyPublisher()
    }
    
    
    
    
}
