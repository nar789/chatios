//
//  RoundedCornersShape.swift
//  fantoo
//
//  Created by kimhongpil on 2022/06/23.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
