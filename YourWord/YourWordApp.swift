//
//  YourWordApp.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/12/23.
//

import SwiftUI
import SwiftData

@main
struct YourWordApp: App {
  @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

  var body: some Scene {
    WindowGroup {
      MemorizeView()
    }
    .modelContainer(sharedModelContainer)
  }
}
