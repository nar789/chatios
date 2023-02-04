//
//  DbControl.swift
//  fantoo
//
//  Created by mkapps on 2022/05/14.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import CoreData
import Combine

struct ApiCachingControl {
    static var viewContext = PersistenceController.shared.container.viewContext
    static var canclelables = Set<AnyCancellable>()
    
    //MARK : - ApiCaching
    static func getAll() -> AnyPublisher<Array<ApiCaching>, ErrorModel> {
        Future<Array<ApiCaching>, ErrorModel> { promise in
            let fetchReqeust = NSFetchRequest<NSFetchRequestResult>(entityName: "ApiCaching")
            let result = try? viewContext.fetch(fetchReqeust)
            if result != nil {
                promise(.success(result as! Array<ApiCaching>))
            }
            else {
                promise(.failure(ErrorModel(code: "error")))
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func get(key:String, cacheTime:Int) -> AnyPublisher<ApiCaching, ErrorModel> {
        Future<ApiCaching, ErrorModel> { promise in
            let fetchReqeust = NSFetchRequest<NSFetchRequestResult>(entityName: "ApiCaching")
            fetchReqeust.predicate = NSPredicate(format: "key == %@", key)
            let result = try? viewContext.fetch(fetchReqeust)
            if result != nil, result!.count > 0 {
                let apiCaching = result!.first as! ApiCaching
                let overTime = apiCaching.regDate?.checkOverTime(minutes: cacheTime) ?? false
                if overTime || cacheTime == 0 {
                    promise(.success(apiCaching))
                }
                else {
                    promise(.failure(ErrorModel(code: "error")))
                }
            }
            else {
                promise(.failure(ErrorModel(code: "error")))
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func set(key:String, json:String) -> AnyPublisher<Bool, ErrorModel> {
        Future<Bool, ErrorModel> { promise in
            get(key: key, cacheTime: 0)
                .sink { error in
                    let new = ApiCaching(context: viewContext)
                    new.key = key
                    new.json = json
                    new.regDate = Date()
                    
                    save()
                    
                    promise(.success(true))
                } receiveValue: { value in
                    value.json = json
                    value.regDate = Date()
                    
                    save()
                    
                    promise(.success(true))
                }
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func removeAll() -> AnyPublisher<Bool, ErrorModel> {
        Future<Bool, ErrorModel> { promise in
            getAll()
                .sink { error in
                    promise(.success(true))
                } receiveValue: { values in
                    values.forEach(viewContext.delete)
                    
                    save()
                    
                    promise(.success(true))
                }
                .store(in: &canclelables)
        }
        .eraseToAnyPublisher()
    }
    
    static func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
