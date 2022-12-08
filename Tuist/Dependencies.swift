//
//  Dependencies.swift
//  Config
//
//  Created by mkapps on 2022/04/22.
//

import ProjectDescription

let dependencies = Dependencies(
//    carthage: [
//        .github(path: "Alamofire/Alamofire", requirement: .exact("5.0.4")),
//    ],
    swiftPackageManager: [
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.6.1")),
        .remote(url: "https://github.com/google/GoogleSignIn-iOS", requirement: .exact("6.0.2")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "8.0.0")),
        .remote(url: "https://github.com/kakao/kakao-ios-sdk", requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/line/line-sdk-ios-swift", requirement: .upToNextMajor(from: "5.0.0")),
        .remote(url: "https://github.com/facebook/facebook-ios-sdk", requirement: .upToNextMajor(from: "13.0.0")),
        .remote(url: "https://github.com/Moya/Moya", requirement: .upToNextMajor(from: "15.0.0")),
        .remote(url: "https://github.com/haifengkao/SwiftUI-Navigation-Bar-Color", requirement: .upToNextMajor(from: "0.9.0")),
        //.remote(url: "https://github.com/siteline/SwiftUI-Introspect.git", requirement: .upToNextMajor(from: "0.1.4")),
        .remote(url: "https://github.com/exyte/PopupView", requirement: .upToNextMajor(from: "1.0.0")),
        .remote(url: "https://github.com/weitieda/bottom-sheet", requirement: .upToNextMajor(from: "1.0.0")),
//        .remote(url: "https://github.com/twostraws/CodeScanner", requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/gonzalezreal/AttributedText", requirement: .upToNextMajor(from: "1.0.0")),
        .remote(url: "https://github.com/SwiftUIX/SwiftUIX", requirement: .upToNextMajor(from: "0.1.2")),
    ],
    platforms: [.iOS]
)




