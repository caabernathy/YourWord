//
//  MemorizeView.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/12/23.
//

import SwiftUI
import SwiftData

struct MemorizeView: View {
  var scripture: Scripture
  var isDailyReveal: Bool

  let pageViewCount = 7
  let bibleTranslation = SettingsManager.shared.preferredBibleTranslation ?? BibleTranslation.NIV

  @EnvironmentObject var appDelegate: AppDelegate
  @State private var dragOffset: CGFloat = 0
  @State private var pageIndex = 0
  @State private var memoryTexts: [String] = []
  @State private var memorySources: [String] = []

  var body: some View {
    GeometryReader { geometry in
      VStack {

        // Content
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 0) {
            ForEach(0..<memoryTexts.count, id: \.self) { index in
              ScriptureView(text: memoryTexts[index], source: "\(memorySources[index]) \(bibleTranslation.rawValue)")
                .padding()
                .frame(width: geometry.size.width)
            }
          }
        }
        .content.offset(x: (CGFloat(pageIndex) * -geometry.size.width) + dragOffset)
        .frame(width: geometry.size.width, alignment: .leading)
        .gesture(
          DragGesture().onChanged { value in
            dragOffset = value.translation.width
          }
            .onEnded { value in
              withAnimation(.smooth) {
                let offset = value.translation.width
                let newIndex = (CGFloat(pageIndex) - (offset / geometry.size.width)).rounded()
                pageIndex = min(max(Int(newIndex), 0), memoryTexts.count - 1)
                dragOffset = 0
              }
            }
        )
        .animation(.spring(), value: dragOffset)

        // Pagination
        HStack(spacing: 15) {
          ForEach(0..<memoryTexts.count, id: \.self) { index in
            Button(action: { self.pageChangeAction(newIndex: index) }) {
              ZStack {
                Circle()
                  .fill(pageIndex == index ? Color.blue : Color.gray)
                  .frame(width: 30, height: 30)
                Text(paginationLabel(for: index))
                  .foregroundColor(.white)
              }
            }
          }
          ForEach(memoryTexts.count..<pageViewCount, id: \.self) { index in
            ZStack {
              Circle()
                .fill(Color.white.opacity(0))
                .frame(width: 30, height: 30)
              Text(paginationLabel(for: index))
            }
          }
        }
        .padding(.top, 10)

        Spacer()
      }
    }
    .onAppear(perform: {
      loadMemorizeData()
    })
  }

  private func pageChangeAction(newIndex: Int) {
    withAnimation(.smooth) {
      pageIndex = newIndex
    }
  }

  private func loadMemorizeData() {
    guard 
      let scriptureText = scripture.translation(for: bibleTranslation) else { return }
    let maskedTexts = ScriptureManager.shared.maskScriptureText(scriptureText)
    let maskedSources = ScriptureManager.shared.maskSriptureReference(scripture.passage)
    let dayOfWeek = isDailyReveal ? Calendar.current.component(.weekday, from: Date()) : pageViewCount
    // Set up the starting point based on...
    // Is it the daily memorization view?
    if isDailyReveal {
      // notification not nil && data <= dayOfWeek
      // Was this opened due to a notification event?
      if let notificationData = appDelegate.notificationData {
        pageIndex = (notificationData > dayOfWeek) ? dayOfWeek - 1 : notificationData - 1
        // Reset notification data
        appDelegate.notificationData = nil
      } else {
        // Start at the day of the week
        pageIndex = dayOfWeek - 1
      }
    } else {
      // If part of the saved verses view, start at 0
      pageIndex = 0
    }
    memoryTexts = Array(maskedTexts.prefix(dayOfWeek))
    memorySources = Array(maskedSources.prefix(dayOfWeek))

  }

  private func paginationLabel(for index: Int) -> String {
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
