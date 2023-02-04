//
//  ApiControl+HomeClubJoin.swift
//  fantoo
//
//  Created by sooyeol on 2023/01/27.
//  Copyright © 2023 FNS CO., LTD. All rights reserved.
//

import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    static func clubNicknameCheck(clubId: String, nickname: String) -> AnyPublisher<ClubNicknameCheck, ErrorModel> {
        Future<ClubNicknameCheck, ErrorModel> { promise in
            
            let apis: ApisHomeClubJoin = .ClubNicknameCheck(clubId: clubId, nickname: nickname)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubJoin>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        var result: ClubNicknameCheck? = nil
                        do {
                            result = try JSONDecoder().decode(ClubNicknameCheck.self, from: response.data)
                        } catch {
                            print("clubNicknameCheck error : \(error)")
                        }
                        
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
    
    static func clubJoin(clubId: String, nickname: String, checkToken: String, profileImg: String?) -> AnyPublisher<ClubHomeJoinResponse, ErrorModel> {
        Future<ClubHomeJoinResponse, ErrorModel> { promise in
            
            let apis: ApisHomeClubJoin = .ClubJoin(clubId: clubId,
                                                   nickname: nickname,
                                                   checkToken: checkToken,
                                                   integUid: UserManager.shared.uid,
                                                   accessToken: UserManager.shared.accessToken,
                                                   profileImg: profileImg)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubJoin>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        var result: ClubHomeJoinResponse? = nil
                        do {
                            result = try JSONDecoder().decode(ClubHomeJoinResponse.self, from: response.data)
                        } catch {
                            print("clubJoin error : \(error)")
                        }
                        
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
    
    static func clubJoinCancel(clubId: String) -> AnyPublisher<String, ErrorModel> {
        Future<String, ErrorModel> { promise in
            
            let apis: ApisHomeClubJoin = .ClubJoinCancel(clubId: clubId,
                                                         integUid: UserManager.shared.uid,
                                                         accessToken: UserManager.shared.accessToken)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisHomeClubJoin>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        if response.statusCode == 200 {
                            promise(.success("success"))
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
