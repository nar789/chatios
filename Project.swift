import ProjectDescription
import ProjectDescriptionHelpers
import Foundation

/*
 참고 : https://baechukim.tistory.com/100
 */

let version: InfoPlist.Value = "1.0.0"
let projectName: String = "fantoo" /// 프로젝트 이름
let organizationName: String = "FNS CO., LTD." /// organization 이름
let bundleName: String = "com.rndeep" /// 번들 앞 prefix -> 이렇게 안해줘도 됨
let dependencies: [ProjectDescription.TargetDependency] = [
    //.cocoapods(path: ".") /// 코코아 팟으로 의존성 관리, tuist generate하면 pod install 자동으로 됨
    .target(name: "NotificationService"),
    
    .external(name: "CombineMoya"),
    .external(name: "Alamofire"),
    .external(name: "BottomSheet"),
//    .external(name: "CodeScanner"),
    .external(name: "SwiftUIX"),
    
    //push, link, analytics
    .external(name: "FirebaseAnalytics"),
    .external(name: "FirebaseDynamicLinks"),
    .external(name: "FirebaseMessaging"),
    
    //sns
    .external(name: "GoogleSignIn"),
    .external(name: "FirebaseAuth"),
    .external(name: "KakaoSDKAuth"),
    .external(name: "KakaoSDKCommon"),
    .external(name: "KakaoSDKUser"),
    .external(name: "LineSDK"),
    .external(name: "LineSDKObjC"),
    .external(name: "GoogleAppMeasurement"),
    
    .external(name: "FacebookLogin"),
    .external(name: "FacebookCore"),
    
    
    .external(name: "SwiftUINavigationBarColor"),
    //.external(name: "Introspect"),
    .external(name: "PopupView"),
    .external(name: "AttributedText")
]

let baseSettings: SettingsDictionary = [
    "OTHER_LDFLAGS": "-ObjC",
    "DEVELOPMENT_TEAM":"5ZQT74SG9D"
//    "SWIFT_OBJC_BRIDGING_HEADER": "\(projectName)/Sources/Common/Bridging/BridgingHeader.h",
]

func debugSettings() -> SettingsDictionary {
//    var settings = baseSettings
//    settings["ENABLE_TESTABILITY"] = "YES"
//    return settings
    baseSettings
}

func releaseSettings() -> SettingsDictionary {
    baseSettings
}

/// info
let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleShortVersionString": version,
    "CFBundleVersion": "1",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "CFBundleURLTypes": [
        "FANTOO", "Fantoo", "fantoo",
        "kakao8edfe579ce93eb519c38f165f1d5568b",
        "2509885855929003",
        "fb2509885855929003",
        "com.googleusercontent.apps.382755949407-68i7mnl4avi2j2cms9u0l3pjt3drlld1",
        "line3rdp.$(PRODUCT_BUNDLE_IDENTIFIER)",
        "com.rndeep.fantoo",
        "twitterfns",
        "naverlogin"
    ],
    "CFBundleURLSchemes": [
        "fb2509885855929003",
        "com.googleusercontent.apps.382755949407-68i7mnl4avi2j2cms9u0l3pjt3drlld1",
    ],
    "FacebookAppID":"2509885855929003",
    "FacebookDisplayName":"FNS",
    "FacebookClientToken":"ed31ef48298bca810ddddf980659a884",
    "FirebaseDynamicLinksCustomDomains": [
        "https://fantoo.page.link",
        "https://rndeep.page.link/welcome",
        "http://140.238.28.29:3000/user/join-success"
    ],
    "GADApplicationIdentifier":"ca-app-pub-3901397200757979~2675242560",
    "KAKAO_APP_KEY":"8edfe579ce93eb519c38f165f1d5568b",
    "LSApplicationQueriesSchemes": [
        "com.googleusercontent.apps.382755949407-68i7mnl4avi2j2cms9u0l3pjt3drlld1",
        "kakao8edfe579ce93eb519c38f165f1d5568b",
        "kakaokompassauth",
        "storykompassauth",
        "kakaolink",
        "kakaotalk-5.9.7",
        "storylink",
        "naversearchapp",
        "naversearchthirdlogin",
        "fbapi",
        "fb-messenger-share-api",
        "fbauth2",
        "fbshareextension",
        "lineauth2",
    ],
    "LSSupportsOpeningDocumentsInPlace":true,
    "NSAppleMusicUsageDescription":"프로필 사진, 피드 업로드, 대화방 내 공유시 사용",
    "NSCameraUsageDescription":"프로필 사진, 피드 업로드, 대화방 내 공유시 사용",
    "NSContactsUsageDescription":"친구 추가시 연락처 연동",
    "NSLocationWhenInUseUsageDescription":"대화방에 위치 정보 전송",
    "NSMicrophoneUsageDescription":"노래방, 라이브 방송",
    "NSPhotoLibraryAddUsageDescription":"프로필 사진, 피드 업로드, 대화방 내 공유시 사용",
    "NSPhotoLibraryUsageDescription":"프로필 사진, 피드 업로드, 대화방 내 공유시 사용",
    "NSUserTrackingUsageDescription":"이벤트에 대한 통계에 사용하기 위해 사용자의 광고 활동 정보를 수집합니다.",
//    "SKAdNetworkItems": [
//        "SKAdNetworkIdentifier":"cstr6suwn9.skadnetwork",
//        "SKAdNetworkIdentifier":"4fzdc2evr5.skadnetwork",
//        "SKAdNetworkIdentifier":"2fnua5tdw4.skadnetwork",
//        "SKAdNetworkIdentifier":"ydx93a7ass.skadnetwork",
//        "SKAdNetworkIdentifier":"5a6flpkh64.skadnetwork",
//        "SKAdNetworkIdentifier":"p78axxw29g.skadnetwork",
//        "SKAdNetworkIdentifier":"v72qych5uu.skadnetwork",
//        "SKAdNetworkIdentifier":"c6k4g5qg8m.skadnetwork",
//        "SKAdNetworkIdentifier":"s39g8k73mm.skadnetwork",
//        "SKAdNetworkIdentifier":"3qy4746246.skadnetwork",
//        "SKAdNetworkIdentifier":"3sh42y64q3.skadnetwork",
//        "SKAdNetworkIdentifier":"f38h382jlk.skadnetwork",
//        "SKAdNetworkIdentifier":"hs6bdukanm.skadnetwork",
//        "SKAdNetworkIdentifier":"prcb7njmu6.skadnetwork",
//        "SKAdNetworkIdentifier":"v4nxqhlyqp.skadnetwork",
//        "SKAdNetworkIdentifier":"wzmmz9fp6w.skadnetwork",
//        "SKAdNetworkIdentifier":"yclnxrl5pm.skadnetwork",
//        "SKAdNetworkIdentifier":"t38b2kh725.skadnetwork",
//        "SKAdNetworkIdentifier":"7ug5zh24hu.skadnetwork",
//        "SKAdNetworkIdentifier":"9rd848q2bz.skadnetwork",
//        "SKAdNetworkIdentifier":"n6fk4nfna4.skadnetwork",
//        "SKAdNetworkIdentifier":"kbd757ywx3.skadnetwork",
//        "SKAdNetworkIdentifier":"9t245vhmpl.skadnetwork",
//        "SKAdNetworkIdentifier":"4468km3ulz.skadnetwork",
//        "SKAdNetworkIdentifier":"2u9pt9hc89.skadnetwork",
//        "SKAdNetworkIdentifier":"8s468mfl3y.skadnetwork",
//        "SKAdNetworkIdentifier":"av6w8kgt66.skadnetwork",
//        "SKAdNetworkIdentifier":"klf5c3l5u5.skadnetwork",
//        "SKAdNetworkIdentifier":"ppxm28t8ap.skadnetwork",
//        "SKAdNetworkIdentifier":"424m5254lk.skadnetwork",
//        "SKAdNetworkIdentifier":"uw77j35x4d.skadnetwork",
//        "SKAdNetworkIdentifier":"578prtvx9j.skadnetwork",
//        "SKAdNetworkIdentifier":"4dzt52r2t5.skadnetwork",
//        "SKAdNetworkIdentifier":"e5fvkxwrpn.skadnetwork",
//        "SKAdNetworkIdentifier":"8c4e2ghe7u.skadnetwork",
//        "SKAdNetworkIdentifier":"zq492l623r.skadnetwork",
//        "SKAdNetworkIdentifier":"3qcr597p9d.skadnetwork"
//    ],
    "UIFileSharingEnabled":true,
    "NSAppTransportSecurity":[
        "NSAllowsArbitraryLoads":true
    ]
]

/// 앱의 타겟 설정
let targets = [
    Target(
        name: projectName, /// 타겟 이름
        platform: .iOS, /// 플랫폼
        product: .app, /// 앱인지 프레임워크인지 라이브러리인지 등
        bundleId: "\(bundleName).\(projectName)", /// 번들 아이디
        deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]), /// 배포 타겟 정보, 혹시 generate에서 버전정보 워닝이 뜬다면 pod파일 버전 제어, 프로젝트 deploy는 default로 설정되는 거 같다.
        infoPlist: "\(projectName)/Supporting/Info.plist", /// plist 관리 위치 - .default로도 사용 가능
//        infoPlist: .extendingDefault(with: infoPlist),
        sources: [
            "\(projectName)/Sources/**"
        ],
        resources: [
            "\(projectName)/Resources/**"
        ],
        entitlements: "\(projectName)/Supporting/fantoo.entitlements",
//        actions: targetActions, /// 빌드 스크립트 실행
        dependencies: dependencies
    ),
    Target(
        name: "NotificationService", /// 타겟 이름
        platform: .iOS, /// 플랫폼
        product: .appExtension, /// 앱인지 프레임워크인지 라이브러리인지 등
        bundleId: "\(bundleName).\(projectName).NotificationService", /// 번들 아이디
        deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]), /// 배포 타겟 정보, 혹시 generate에서 버전정보 워닝이 뜬다면 pod파일 버전 제어, 프로젝트 deploy는 default로 설정되는 거 같다.
        infoPlist: "NotificationService/Supporting/Info.plist", /// plist 관리 위치 - .default로도 사용 가능
//        infoPlist: .extendingDefault(with: infoPlist),
        sources: [
            "NotificationService/Sources/**"
        ],
//        resources: [
//            "NotificationService/Resources/**"
//        ],
        entitlements: "NotificationService/Supporting/NotificationService.entitlements"
//        actions: targetActions, /// 빌드 스크립트 실행
//        dependencies: dependencies
    ),
    Target( /// unit test
        name: "\(projectName)Tests",
        platform: .iOS,
        product: .unitTests,
        bundleId: "\(bundleName).\(projectName)Tests",
        infoPlist: "\(projectName)Tests/Info.plist",
        sources: "\(projectName)Tests/**",
        dependencies: [
            .target(name: projectName) /// 테스트의 의존성은 실제 프로젝트에 있음
        ]
    ),
    Target( /// ui test
        name: "\(projectName)UITests",
        platform: .iOS,
        product: .uiTests,
        bundleId: "\(bundleName).\(projectName)UITests",
        infoPlist: "\(projectName)UITests/Info.plist",
        sources: "\(projectName)UITests/**",
        dependencies: [
            .target(name: projectName)
        ]
    )
]



/// 실제 프로젝트
let project = Project(
    name: projectName,
    organizationName: organizationName,
    settings: .settings(
        configurations: [
            .debug(name: "Debug", settings: debugSettings(), xcconfig: nil),
            .release(name: "Release", settings: releaseSettings(), xcconfig: nil),
        ]
    ),
    targets: targets
//    schemes: schemes
)
