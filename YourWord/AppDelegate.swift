//
//  AppDelegate.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/12/23.
//

import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject {

  var notificationData: Int?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    return true
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    if let day = response.notification.request.content.userInfo["day"] as? Int {
      notificationData = day
    }
    completionHandler()
  }
}

