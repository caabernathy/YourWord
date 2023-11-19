//
//  YourWordApp.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/12/23.
//

import SwiftUI

@main
struct YourWordApp: App {
  @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
  let viewModel = ScriptureViewModel(scriptures: ScriptureManager.shared.scriptures, at: 0)

  var body: some Scene {
    WindowGroup {
      MemorizeView(viewModel: viewModel) {
        Task {
          ScriptureManager.shared.saveScriptures()
        }
      }
      .onAppear {
        appDelegate.scriptureViewModel = viewModel
        viewModel.refreshDayOfWeek()
      }
    }
  }
}
