//
//  ScriptureViewModel.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/12/23.
//

import Foundation

@Observable class ScriptureViewModel {
  var memoryTexts: [String] = []
  var memorySources: [String] = []
  var isDailyReveal = true
  var scriptures: [Scripture]
  var scriptureIndex: Int

  var currentIndex = 0
  var pageViewCount = ScriptureManager.shared.memorizeCount

  private var dayOfWeek = 1 {
    didSet {
      updateMemoryTexts()
      updateMemorySources()
    }
  }

  private var allVersions: [String] = [] {
    didSet {
      updateMemoryTexts()
    }
  }

  private var allSources: [String] = [] {
    didSet {
      updateMemorySources()
    }
  }

  init(scriptures: [Scripture], at index: Int = 0) {
    self.scriptures = scriptures
    self.scriptureIndex = index
    setupMemorizations()
  }

  private func setupMemorizations() {

    guard ScriptureManager.shared.scriptures.count > scriptureIndex else { return }

    // All potential modifications
    (allVersions, allSources) = ScriptureManager.shared.mask(scripture: scriptures[scriptureIndex])

    if isDailyReveal {
      dayOfWeek = Calendar.current.component(.weekday, from: Date())
      currentIndex = dayOfWeek - 1
    } else {
      dayOfWeek = 7
      currentIndex = 0
    }
  }

  private func updateMemoryTexts() {
    memoryTexts = Array(allVersions.prefix(dayOfWeek))
  }

  private func updateMemorySources() {
    memorySources = Array(allSources.prefix(dayOfWeek))
  }

  func updateDayOfWeek(with day: Int) {
    DispatchQueue.main.async {
      self.dayOfWeek = Calendar.current.component(.weekday, from: Date())
      self.currentIndex = day - 1
    }
  }

  func refreshDayOfWeek() {
    dayOfWeek = Calendar.current.component(.weekday, from: Date())
  }

  func updateView(index: Int) {
    currentIndex = index
  }

  func paginationLabel(for index: Int) -> String {
    switch index {
    case 0:
      return "S" // Sunday
    case 1:
      return "M" // Monday
    case 2:
      return "T" // Tuesday
    case 3:
      return "W" // Wednesday
    case 4:
      return "T" // Thursday
    case 5:
      return "F" // Friday
    case 6:
      return "S" // Saturday
    default:
      return "X" // For indices not between 0 and 6
    }
  }
}

