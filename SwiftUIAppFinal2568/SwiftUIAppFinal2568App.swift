//
//  AppFinal2568App.swift
//  AppFinal2568
//
//  Created by Tharin Saeung on 30/4/2568 BE.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct SwiftUIAppFinal2568App: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        let mainView = MainView().environmentObject(UserAuth())
        WindowGroup {
            mainView
        }
    }
}
