//
//  Button+Modifier.swift
//  fantoo
//
//  Created by mkapps on 2022/06/20.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct ButtonTextMinimunScaleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 5)
            .minimumScaleFactor(0.01)
    }
}
