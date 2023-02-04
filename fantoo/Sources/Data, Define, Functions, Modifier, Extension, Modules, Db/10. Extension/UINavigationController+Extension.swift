//
//  UINavigationController+Extension.swift
//  fantoo
//
//  Created by mkapps on 2022/11/01.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
