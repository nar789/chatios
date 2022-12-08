//
//  Dependencies.swift
//  fantooManifests
//
//  Created by mkapps on 2022/04/22.
//

import ProjectDescription

let dependencies = Dependencies(
//    carthage: [
//        .github(path: "Alamofire/Alamofire", requirement: .exact("5.6.1")),
//    ],
    swiftPackageManager: [
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.6.1")),
    ],
    platforms: [.iOS]
)
