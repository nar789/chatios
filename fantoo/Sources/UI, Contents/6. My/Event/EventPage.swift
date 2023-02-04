//
//  EventPage.swift
//  fantooTests
//
//  Created by fns on 2022/06/28.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct EventPage: View {
    
    @State var showEventDetailPage: Bool = true
    
    var body: some View {
        
        ScrollView {
         Text("EventPage")
        }
        .modifier(ScrollViewLazyVStackModifier())
        .navigationType(leftItems: [.Back], rightItems: [], leftItemsForegroundColor: .black, rightItemsForegroundColor: .black, title: "a_event".localized, onPress: { buttonType in
            print("onPress buttonType : \(buttonType)")
        })
        .navigationBarBackground {
            Color.gray25
        }
        .statusBarStyle(style: .darkContent)
    }
    
}

struct EventPage_Previews: PreviewProvider {
    static var previews: some View {
        EventPage()
    }
}
