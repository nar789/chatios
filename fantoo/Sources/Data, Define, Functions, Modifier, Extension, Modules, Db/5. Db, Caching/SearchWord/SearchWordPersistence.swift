//
//  Persistence.swift
//  fantoo
//
//  Created by kimhongpil on 2022/07/20.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import CoreData

struct SearchWordPersistenceController {
    static let shared = SearchWordPersistenceController()

    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "SearchWord")   // .xcdatamodeld 파일 이름
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                fatalError("Unresolved Error \(error), \(error.localizedDescription)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
