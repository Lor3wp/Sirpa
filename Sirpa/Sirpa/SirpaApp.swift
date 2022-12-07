//
//  SirpaApp.swift
//  Sirpa
//
//  Created by iosdev on 9.11.2022.
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
struct SirpaApp: App {
    let persistenceController = PersistenceController.shared

  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
        ProfileView()
              .environment(\.managedObjectContext, persistenceController.container.viewContext)
      }
    }
  }
}
