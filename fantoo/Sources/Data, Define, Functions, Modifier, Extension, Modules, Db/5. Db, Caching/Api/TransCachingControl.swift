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

struct TransCachingControl {
    static var viewContext = PersistenceController.shared.container.viewContext
    static var canclelables = Set<AnyCancellable>()
    
    //MARK : - ApiCaching
    static func getAll() -> AnyPublisher<Array<ApiCaching>, ErrorModel> {
        Future<Array<ApiCaching>, ErrorModel> { promise in
            let fetchReqeust = NSFetchRequest<NSFetchRequestResult>(entityName: "TransCaching")
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
    
    static func get(key:String, lang:String, regDate:Date) -> AnyPublisher<TransCaching, ErrorModel> {
        Future<TransCaching, ErrorModel> { promise in
            let fetchReqeust = NSFetchRequest<NSFetchRequestResult>(entityName: "TransCaching")
            fetchReqeust.predicate = NSPredicate(format: "key == %@ && lang == %@ && regDate == %@", key, lang, regDate as CVarArg)
            let result = try? viewContext.fetch(fetchReqeust)
            if result != nil, result!.count > 0 {
                let transCaching = result!.first as! TransCaching
                promise(.success(transCaching))
            }
            else {
                promise(.failure(ErrorModel(code: "error")))
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func set(key:String, lang:String, text:String, regDate:Date) -> AnyPublisher<Bool, ErrorModel> {
        Future<Bool, ErrorModel> { promise in
            get(key: key, lang: lang, regDate: regDate)
                .sink { error in
                    let new = TransCaching(context: viewContext)
                    new.key = key
                    new.lang = lang
                    new.text = text
                    new.regDate = regDate
                    
                    save()
                    
                    promise(.success(true))
                } receiveValue: { value in
                    value.text = text
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
