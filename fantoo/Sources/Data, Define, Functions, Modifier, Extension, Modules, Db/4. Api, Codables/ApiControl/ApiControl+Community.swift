//
//  ApiControl+MainTabCommunity.swift
//  fantoo
//
//  Created by kimhongpil on 2022/06/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import CombineMoya
import Moya
import Combine

extension ApiControl {
    
    /**
     * 전체공지 TOP고정 List
     */
    static func getCommunityTopNotice() -> AnyPublisher<Community_Notice, ErrorModel> {
        Future<Community_Notice, ErrorModel> { promise in
            
            let apis: ApisCommunity = .Community_TopNotice
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        //print("ApiControl - getCommunityTotalNotice() called !!!")
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(Community_Notice.self, from: response.data)
                        //print("ApiControl - result : \(result)" as String)
                        
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
    
    /**
     * 전체공지 List (Paging)
     */
    static func getCommunityTopNoticeMore(nextId: Int, size: Int) -> AnyPublisher<Community_Notice, ErrorModel> {
        Future<Community_Notice, ErrorModel> { promise in
            
            let apis: ApisCommunity = .Community_TopNoticeMore(nextId: nextId, size: size)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        //print("ApiControl - getCommunityTotalNotice() called !!!")
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(Community_Notice.self, from: response.data)
                        //print("ApiControl - result : \(result)" as String)
                        
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
    
    /**
     * 각 카테고리 TOP고정 List
     */
    static func getCommunityTopNoticeCategory(code: String) -> AnyPublisher<Community_Notice, ErrorModel> {
        Future<Community_Notice, ErrorModel> { promise in
            
            let apis: ApisCommunity = .Community_TopNoticeCategory(code: code)
            
            //call
            let provider = MoyaProvider<ApisCommunity>()
            provider.requestPublisher(apis)
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    print(error)
                    promise(.failure(ErrorModel(code: "error")))
                }, receiveValue: { response in
                    //print("ApiControl - getCommunityTotalNotice() called !!!")
                    jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                    
                    let result = try? JSONDecoder().decode(Community_Notice.self, from: response.data)
                    //print("ApiControl - result : \(result)" as String)
                    
                    if result != nil {
                        promise(.success(result!))
                    } else {
                        promise(.failure(ErrorModel(code: "error")))
                    }
                })
                .store(in: &canclelables)
            
            
        }
        .eraseToAnyPublisher()
    }
    
    /**
     * 전체공지 Detail
     * 각 카테고리 Detail
     */
    static func getCommunityNoticeDetail(type: CommunityNoticeDetailType, code: String?, postId: Int) -> AnyPublisher<CommunityNoticeDetail, ErrorModel> {
        Future<CommunityNoticeDetail, ErrorModel> { promise in
            
            var apis: ApisCommunity?
            if type == .TotalNoticeDetail {
                apis = .CommunityNoticeDetail_Total(postId: postId)
            }
            else if type == .CategoryNoticeDetail {
                if let NOcode = code {
                    apis = .CommunityNoticeDetail_Category(code: NOcode, postId: postId)
                }
            }
            
            if let NOapis = apis {
                Check().checkToken(isCheck: NOapis.isCheckToken()) { success in
                    if !success { return }
                    
                    //call
                    let provider = MoyaProvider<ApisCommunity>()
                    provider.requestPublisher(NOapis)
                        .sink(receiveCompletion: { completion in
                            guard case let .failure(error) = completion else { return }
                            print(error)
                            promise(.failure(ErrorModel(code: "error")))
                        }, receiveValue: { response in
                            //print("ApiControl - getCommunityTotalNotice() called !!!")
                            jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: NOapis.isResponseLog())
                            
                            let result = try? JSONDecoder().decode(CommunityNoticeDetail.self, from: response.data)
                            //print("ApiControl - result : \(result)" as String)
                            
                            if result != nil {
                                promise(.success(result!))
                            } else {
                                promise(.failure(ErrorModel(code: "error")))
                            }
                        })
                        .store(in: &canclelables)
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    // 비회원 카테고리
    static func getMainCommunity_GuestCategory() -> AnyPublisher<MainCommunity_Category, ErrorModel> {
        Future<MainCommunity_Category, ErrorModel> { promise in
            
            let apis: ApisCommunity = .MainCommunity_GuestCategory
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        //print("ApiControl - getCommunityTotalNotice() called !!!")
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(MainCommunity_Category.self, from: response.data)
                        //print("ApiControl - result : \(result)" as String)
                        
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
    
    
    // 비회원 인기 게시글
    static func getMainCommunity_GuestBoard() -> AnyPublisher<MainCommunity_Board, ErrorModel> {
        Future<MainCommunity_Board, ErrorModel> { promise in
            
            let apis: ApisCommunity = .MainCommunity_GuestBoard
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        //print("ApiControl - getMainCommunity_GuestBoard() called !!!")
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(MainCommunity_Board.self, from: response.data)
                        //print("ApiControl - result : \(result)" as String)
                        
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
    
    // 회원 카테고리 - 팬투 추천순
    static func getMainCommunity_UserCategory_Recog(integUid: String, access_token: String) -> AnyPublisher<MainCommunity_Category, ErrorModel> {
        Future<MainCommunity_Category, ErrorModel> { promise in
            let apis: ApisCommunity = .MainCommunity_UserCategory_Recog(integUid: integUid, access_token: access_token)
            
            Check().checkToken(isCheck: apis.isCheckToken()) { success in

                if !success { return }

                //call
                let provider = MoyaProvider<ApisCommunity>()
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
                        //error check end

                        let result = try? JSONDecoder().decode(MainCommunity_Category.self, from: response.data)

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
    
    // 회원 카테고리 - 인기순
    static func getMainCommunity_UserCategory_Popular(integUid: String, access_token: String) -> AnyPublisher<MainCommunity_Category, ErrorModel> {
        Future<MainCommunity_Category, ErrorModel> { promise in
            
            let apis: ApisCommunity = .MainCommunity_UserCategory_Popular(integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(MainCommunity_Category.self, from: response.data)
                        
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
    
    // 회원 인기 게시글
    static func getMainCommunity_UserBoard(integUid: String, access_token: String) -> AnyPublisher<MainCommunity_Board, ErrorModel> {
        Future<MainCommunity_Board, ErrorModel> { promise in
            
            let apis: ApisCommunity = .MainCommunity_UserBoard(integUid: integUid, access_token: access_token)
            
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }

                //call
                let provider = MoyaProvider<ApisCommunity>()
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

                        let result = try? JSONDecoder().decode(MainCommunity_Board.self, from: response.data)

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
    
    /**
     * 커뮤니티 카테고리 즐겨찾기 등록
     */
    static func postCommunityCategoryFavorite(code: String, integUid: String, access_token: String) -> AnyPublisher<ResultModel, ErrorModel> {
        Future<ResultModel, ErrorModel> { promise in
            
            let apis: ApisCommunity = .CategoryFavoritePost(code: code, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
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
    
    /**
     * 커뮤니티 카테고리 즐겨찾기 삭제
     */
    static func deleteCommunityCategoryFavorite(code: String, integUid: String, access_token: String) -> AnyPublisher<ResultModel, ErrorModel> {
        Future<ResultModel, ErrorModel> { promise in
            
            let apis: ApisCommunity = .CategoryFavoriteDelete(code: code, integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
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
    
    // 검색
    static func getMainCommunity_MemberSearch(integUid: String, nextId: Int, search: String, size: Int, access_token: String) -> AnyPublisher<Community_List, ErrorModel> {
        Future<Community_List, ErrorModel> { promise in
            
            let apis: ApisCommunity =
                .MemberSearch(integUid: integUid, nextId: nextId, search: search, size: size, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(Community_List.self, from: response.data)
                        
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
    
    // 각 카테고리 게시글 목록
    static func getEachCategoryBoards(code: String, globalYn: Bool, integUid: String, nextId: Int, size: Int, subCode: String, access_token: String) -> AnyPublisher<Community_List, ErrorModel> {
        Future<Community_List, ErrorModel> { promise in
            
            let apis: ApisCommunity =
                .EachCategoryBoards(code: code, globalYn: globalYn, integUid: integUid, nextId: nextId, size: size, subCode: subCode, access_token: access_token)
            
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
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
                        
                        let result = try? JSONDecoder().decode(Community_List.self, from: response.data)
                        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // ############################################
    /**
     * 광고 서버에서 임시로 만든 API 모델 (fantoo api 적용 후 삭제할 것)
     */
    // ############################################
    /**
     * 카테고리
     */
    static func getCommunityCategory() -> AnyPublisher<MainCommunityCategory, ErrorModel> {
        Future<MainCommunityCategory, ErrorModel> { promise in
            
            let apis: ApisCommunity = .CommunityCategory
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        //print("ApiControl - getCommunityTotalNotice() called !!!")
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(MainCommunityCategory.self, from: response.data)
                        //print("ApiControl - result : \(result)" as String)
                        
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
    
    /**
     * 카테고리 팬투 추천순 (회원)
     */
    static func getCommunityCategoryFantooMember(integUid: String, access_token: String) -> AnyPublisher<CommunityCategoryFantooMember, ErrorModel> {
        Future<CommunityCategoryFantooMember, ErrorModel> { promise in
            
            let apis: ApisCommunity = .CommunityCategoryFantooMember(integUid: integUid, access_token: access_token)
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(CommunityCategoryFantooMember.self, from: response.data)
                        
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
    
    /**
     * 카테고리 인기순 (회원)
     */
    static func getCommunityCategoryPopularMember() {
        
    }
    
    /**
     * Sub 카테고리 (회원)
     */
    static func getCommunitySubcategoryMember() {
        
    }
    
    /**
     * 카테고리 팬투 추천순 (비회원)
     */
    static func getCommunityCategoryFantooNonmember() -> AnyPublisher<CommunityCategoryFantooNonmember, ErrorModel> {
        Future<CommunityCategoryFantooNonmember, ErrorModel> { promise in
            
            let apis: ApisCommunity = .CommunityCategoryFantooNonmember
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(CommunityCategoryFantooNonmember.self, from: response.data)
                        
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
    
    
    
    /**
     * 광고 배너 & 실시간 이슈 TOP 5 & 주간 인기 TOP 5
     */
    static func getCommunityTopFive() -> AnyPublisher<CommunityTopFive, ErrorModel> {
        Future<CommunityTopFive, ErrorModel> { promise in
            
            let apis: ApisCommunity = .CommunityTopFive
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(CommunityTopFive.self, from: response.data)
                        
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
    
    /**
     * 검색 결과
     */
    static func getCommunitySearch() -> AnyPublisher<CommunityTopFive, ErrorModel> {
        Future<CommunityTopFive, ErrorModel> { promise in
            
            let apis: ApisCommunity = .CommunitySearch
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(CommunityTopFive.self, from: response.data)
                        
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
    
    /**
     * 내 작성 글 목록
     */
    static func getCommunityMyBoardList() -> AnyPublisher<CommunityTopFive, ErrorModel> {
        Future<CommunityTopFive, ErrorModel> { promise in
            
            let apis: ApisCommunity = .CommunityMyBoard
            Check().checkToken(isCheck: apis.isCheckToken()) { success in
                if !success { return }
                
                //call
                let provider = MoyaProvider<ApisCommunity>()
                provider.requestPublisher(apis)
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        promise(.failure(ErrorModel(code: "error")))
                    }, receiveValue: { response in
                        jsonLog(data: response.data, systemCode: response.statusCode, isLogOn: apis.isResponseLog())
                        
                        let result = try? JSONDecoder().decode(CommunityTopFive.self, from: response.data)
                        
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
    
    /**
     * 내 댓글 목록
     */
}
