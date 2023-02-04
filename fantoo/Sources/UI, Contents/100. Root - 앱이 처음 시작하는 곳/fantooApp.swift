//
//  fantooApp.swift
//  fantoo
//
//  Created by mkapps on 2022/04/22.
//


import SwiftUI
import UserNotifications
import GoogleSignIn
import Firebase
import FirebaseCore

import KakaoSDKCommon
import KakaoSDKAuth

import GoogleSignIn
import Firebase
import FBSDKCoreKit
import LineSDK
import AuthenticationServices
import CoreData

@main
struct fantooApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey:"8edfe579ce93eb519c38f165f1d5568b")
        
        //init
        LanguageManager.shared.start()
        UserManager.shared.start()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    
                    guard let scheme = url.scheme else { return }
                    
                    if scheme.contains("kakao") {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                    else if scheme.contains("fb") {
                        ApplicationDelegate.shared.application(UIApplication.shared, open: url, options: [UIApplication.OpenURLOptionsKey.annotation:  (Any).self])
                    }
                    else if scheme.contains("twitter") {
                        //twitter
                    }
                    else if scheme.contains("line") {
                        let _ = LoginManager.shared.application(UIApplication.shared, open: url, options: [UIApplication.OpenURLOptionsKey.annotation:  (Any).self])
                    }
                    else if scheme.contains("fantoo") {
                        let components = URLComponents(string: url.absoluteString)
                        let parameters = components?.query ?? ""
                        if parameters.count > 0, parameters != "" {
                            let items = components?.queryItems ?? []
                            
                            var parameters: Dictionary<String, String> = [:]
                            
                            for item in items {
                                parameters[item.name] = item.value ?? ""
                            }
                            
                            self.checkLink(params: parameters)
                        }
                    }
                    else {
                        let _ = ApplicationDelegate.shared.application(UIApplication.shared, open: url, options: [UIApplication.OpenURLOptionsKey.annotation:  (Any).self])
                    }
                }
                //.environmentObject(EnvironmentViewModel())
        }.onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                print("App is active")
                Messaging.messaging().token { token, error in
                    print("\n----------------------------------------\nFCM Token : \(token ?? "")\n")
                }
            case .inactive:
                print("App is inactive")
            case .background:
                print("App is in background")
            @unknown default:
                print("Oh - interesting: I received an unexpected new value.")
            }
        }
    }
    
    //Check Link
    func checkLink(params: Dictionary<String, String>) {
        print("\n--- checkLink -------------------------\nparams : \(params)\n")
        
        let type = params[DefineKey.type] ?? ""
        
        //게시글 상세 이동 (클럽/커뮤니티) ----------------------------------------------
        if type == DefineKey.post {
            let part = params[DefineKey.part] ?? ""
            if part == DefineKey.club {
                let categoryCode = params[DefineKey.categoryCode] ?? ""
                let clubId = params[DefineKey.clubId] ?? ""
                let postId = params[DefineKey.postId] ?? ""
                
                if categoryCode.count > 0, clubId.count > 0, postId.count > 0 {
                    print("\n--- 클럽 게시글 이동 -------------------\ncategoryCode : \(categoryCode), clubId : \(clubId), postId : \(postId)\n")
                }
            }
            else if part == DefineKey.community {
                let code = params[DefineKey.code] ?? ""
                let postId = params[DefineKey.postId] ?? ""
                
                if code.count > 0, postId.count > 0 {
                    print("\n--- 커뮤니티 게시글 이동 -------------------\ncode : \(code), postId : \(postId)\n")
                }
            }
        }
        //댓글 상세 이동 (클럽/커뮤니티) ----------------------------------------------
        else if type == DefineKey.reply {
            let part = params[DefineKey.part] ?? ""
            if part == DefineKey.club {
                let categoryCode = params[DefineKey.categoryCode] ?? ""
                let clubId = params[DefineKey.clubId] ?? ""
                let postId = params[DefineKey.postId] ?? ""
                
                if categoryCode.count > 0, clubId.count > 0, postId.count > 0 {
                    print("\n--- 클럽 댓글 이동 -------------------\ncategoryCode : \(categoryCode), clubId : \(clubId), postId : \(postId)\n")
                }
            }
            else if part == DefineKey.community {
                let code = params[DefineKey.code] ?? ""
                let postId = params[DefineKey.postId] ?? ""
                
                if code.count > 0, postId.count > 0 {
                    print("\n--- 커뮤니티 댓글 이동 -------------------\ncode : \(code), postId : \(postId)\n")
                }
            }
        }
        //게시판 이동 (클럽/커뮤니티) ----------------------------------------------
        else if type == DefineKey.board {
            let part = params[DefineKey.part] ?? ""
            if part == DefineKey.club {
                let categoryCode = params[DefineKey.categoryCode] ?? ""
                let clubId = params[DefineKey.clubId] ?? ""
                
                if categoryCode.count > 0, clubId.count > 0 {
                    print("\n--- 클럽 게시판 이동 -------------------\ncategoryCode : \(categoryCode), clubId : \(clubId)\n")
                }
            }
            else if part == DefineKey.community {
                let code = params[DefineKey.code] ?? ""
                
                if code.count > 0 {
                    print("\n--- 커뮤니티 게시판 이동 -------------------\ncode : \(code)\n")
                }
            }
        }
        //클럽 이동 ----------------------------------------------
        else if type == DefineKey.club {
            let clubId = params[DefineKey.clubId] ?? ""
            
            if clubId.count > 0 {
                print("\n--- 클럽 이동 -------------------\nclubId : \(clubId)\n")
            }
        }
        //가입승인 대기 ----------------------------------------------
        else if type == DefineKey.club_join_manage {
            let clubId = params[DefineKey.clubId] ?? ""
            
            if clubId.count > 0 {
                print("\n--- 가입승인대기 이동 -------------------\nclubId : \(clubId)\n")
            }
        }
        //홈 ----------------------------------------------
        else if type == DefineKey.home {
            let tab = params[DefineKey.tab] ?? ""
            
            if tab.count > 0 {
                print("\n--- 홈(탭) 이동 -------------------\ntab : \(tab)\n")
            }
        }
        //웹뷰 ----------------------------------------------
        else if type == DefineKey.web {
            let url = params[DefineKey.url] ?? ""
            let view = params[DefineKey.view] ?? ""
            
            if url.count > 0, view.count > 0 {
                print("\n--- 웹뷰 이동 -------------------\nurl : \(url), view : \(view)\n")
            }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        //fb
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //line
        LoginManager.shared.setup(channelID: "1656688005", universalLinkURL: nil)
        
        //google
        FirebaseApp.configure()
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "Fantoo"
        
        //twitter
        
        //apple
        
        //push
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in
            guard granted else { return }
            
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("asdfadf")
        guard let scheme = url.scheme else { return true }
        
        if scheme.contains("kakao") {
            
        }
        else if scheme.contains("fb") {
            ApplicationDelegate.shared.application(app, open: url, options: options)
            //            ApplicationDelegate.shared.application( UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation]
            //                  )
            //            ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            //        )
        }
        else if scheme.contains("twitter") {
            //twitter
            
        }
        else if scheme.contains("line") {
            //            return ApplicationDelegate.shared.application(app, open: url, options: options)
            return LoginManager.shared.application(app, open: url, options: options)
            
        }
        else {
            return application(app, open: url,
                               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                               annotation: "")
        }
        
        return false
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        //UserDefaults.standard.setValue(deviceToken, forKey: "apns_token")
        
        Messaging.messaging().token { token, error in
            print("token : \(token ?? "")")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to get token, error: \(String(describing: error))")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            guard dynamicLink.url?.description != nil && dynamicLink.url != nil else {
                return false
            }
            
            print("dynamicLink.url : \(dynamicLink.url?.absoluteString ?? "")")
            
            if let scheme = url.scheme {
                if scheme == "Fantoo" {
                }
            }
            return true
        }
        
        guard let scheme = url.scheme else { return true }
        
        //        if scheme.contains("com.googleusercontent.apps") {
        //            return GIDSignIn.sharedInstance.handle(url, sourceApplication: sourceApplication, annotation: annotation)
        //        } else if scheme.contains("fb"){
        //          LoginManager.shared.application(application, open: url)
        //        }
        
        if scheme.contains("kakao") {
//            if KOSession.handleOpen(url) {
//                return true
//            }
        }
        else if scheme.contains("fb"){
            ApplicationDelegate.shared.application(application, open: url)
        }
        else if scheme.contains("fantoo") {
            let type = url.queryDictionary?["type"] ?? ""
            let code = url.queryDictionary?["code"] ?? ""
            let idx = url.queryDictionary?["_id"] ?? ""
            let url = url.queryDictionary?["url"] ?? ""
            
            if type == "share" {
                //LandingManager.shared.checkLanding(type: type, idx: url, code: url)
            }
            else {
                //LandingManager.shared.checkLanding(type: type, idx: idx, code: code)
            }
        }
        
        return false
    }
    
    
    //MARK: - Dynamic Link
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        // 다이나믹 링크 클릭해서 앱 진입 시
        guard let webpageURL = userActivity.webpageURL else {
            return false
        }
        
        print("userActivity link : \(webpageURL.absoluteString)")
        
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(webpageURL) { (dynamiclink, error) in
            print("AppDelegate DynamicLinks:: \(String(describing: dynamiclink))")
            
            if error != nil {
                return
            }
            
            //ex : http://211.110.165.193:3000/contents?type=post&code=GOT7_1_1578637852271&_id=5e29040c757ad13180480516
            guard let linkUrl = dynamiclink?.url else { return }
            
            //self.proccessLink(url: linkUrl)
            //self.proccessLink(url: URL(string: "http://116.124.133.225:3000/contents?type=artist_live&code=123&_id=6101ec0d763537319f196fef")!)
        }
        
        return handled
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        _ = LoginManager.shared.application(.shared, open: URLContexts.first?.url)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // [START_EXCLUDE]
        // Print message ID.
        //    if let messageID = userInfo[gcmMessageIDKey] {
        //      print("Message ID: \(messageID)")
        //    }
        // [END_EXCLUDE]
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        //앱내에서 푸시 올시 일로 온다
        completionHandler([[.sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // [START_EXCLUDE]
        // Print message ID.
        
        // [END_EXCLUDE]
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        print(userInfo)
        
        //푸시클릭시 여기로 들어온다
        
        completionHandler()
    }
    
    // Background에서 noti 수신 시 동작.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("didReceiveRemoteNotification")
        //proccessPush(userInfo: userInfo)
        completionHandler(.newData)
    }
}

