//
//  View+Extension.swift
//  fantoo
//
//  Created by mkapps on 2022/06/08.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import UIKit
import SwiftUI

class StatusBarConfigurator: ObservableObject {
    
    private var window: UIWindow?
    
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    fileprivate func prepare(scene: UIWindowScene) {
        if window == nil {
            let window = UIWindow(windowScene: scene)
            let viewController = ViewController()
            viewController.configurator = self
            window.rootViewController = viewController
            window.frame = UIScreen.main.bounds
            window.alpha = 0
            self.window = window
        }
        window?.windowLevel = .statusBar
        window?.makeKeyAndVisible()
    }
    
    fileprivate class ViewController: UIViewController {
        weak var configurator: StatusBarConfigurator!
          override var preferredStatusBarStyle: UIStatusBarStyle {
              if configurator != nil {
                  return configurator.statusBarStyle
              }
              
              return .default
          }
    }
}

fileprivate struct SceneFinder: UIViewRepresentable {
    
    var getScene: ((UIWindowScene) -> ())?
    
    func makeUIView(context: Context) -> View { View() }
    func updateUIView(_ uiView: View, context: Context) { uiView.getScene = getScene }
    
    class View: UIView {
        var getScene: ((UIWindowScene) -> ())?
        override func didMoveToWindow() {
            if let scene = window?.windowScene {
                getScene?(scene)
            }
        }
    }
}

extension View {
    func prepareStatusBarConfigurator(_ configurator: StatusBarConfigurator) -> some View {
        return self.background(SceneFinder { scene in
            configurator.prepare(scene: scene)
        })
    }
}


struct StatusBarConfiguratorModifier: ViewModifier {
    
    //status bar config
    @StateObject var statusBarConfigurator = StatusBarConfigurator()
    
    let statusBarStyle: UIStatusBarStyle
    
    func body(content: Content) -> some View {
            content
            .prepareStatusBarConfigurator(statusBarConfigurator)
            .onAppear {
                statusBarConfigurator.statusBarStyle = statusBarStyle
            }
        }
}


extension View {
    func statusBarStyle(style:UIStatusBarStyle) -> some View {
        modifier(StatusBarConfiguratorModifier(statusBarConfigurator: StatusBarConfigurator(), statusBarStyle: style))
    }
}
