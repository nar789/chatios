//
//  PostDropDelegate.swift
//  fantoo
//
//  Created by fns on 2022/07/22.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import SwiftUI
import MobileCoreServices

struct PostDropDelegate<T: Equatable>: DropDelegate {
    
    let currentItem: T
    @Binding var items: [T]
    @Binding var draggedItem: T?
    
    // 드랍에서 벗어났을때
    func dropExited(info: DropInfo) {
        print("MyDropDelegate - dropExited() called")
    }
    
    // 드랍 처리
    func performDrop(info: DropInfo) -> Bool {
        print("MyDropDelegate - performDrop() called")
        return true
    }
    
    // 드랍변경
    func dropUpdated(info: DropInfo) -> DropProposal? {
        //        print("MyDropDelegate - dropUpdated() called")
        //        return nil
        // 같은 아이템에 드래그 했을때 +표시 없애기
        return DropProposal(operation: .move)
    }
    
    // 드랍 유효 여부
    func validateDrop(info: DropInfo) -> Bool {
        print("MyDropDelegate - validateDrop() called")
        return true
    }
    
    // 드랍 시작
    
    func dropEntered(info: DropInfo) {
        print("MyDropDelegate - dropEntered() called")
        
        // 드래깅된 아이템이랑 현재 내 아이템이랑 다르면
        guard let draggedItem = draggedItem,
              draggedItem != currentItem,
              let from = items.firstIndex(of: draggedItem),
              let to = items.firstIndex(of: currentItem)
        else {
            return
        }
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
        }
    }
}
