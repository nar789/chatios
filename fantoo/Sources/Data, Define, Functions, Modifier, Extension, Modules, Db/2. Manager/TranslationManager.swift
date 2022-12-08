//
//  TranslationManager.swift
//  fantoo
//
//  Created by mkapps on 2022/10/06.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import Combine

class TranslationManager: ObservableObject {
    static let shared = TranslationManager()
    
    
    //MARK: - Variables : State
    struct Show {
        var bottomSheet: Bool = false
    }
    
//    let ver = PopupType.BottomSheet.Post
    
    
    @Published var show = Show()
}
