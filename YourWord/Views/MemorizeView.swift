//
//  MemorizeView.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/12/23.
//

import SwiftUI
import SwiftData

struct MemorizeView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var scriptures: [Scripture]

  let pageViewCount = 7
  let scriptureIndex = 1

  @State private var dragOffset: CGFloat = 0
  @State private var pageIndex = Calendar.current.component(.weekday, from: Date()) - 1

  var body: some View {
    let dayOfWeek = Calendar.current.component(.weekday, from: Date())
    let memoryTexts = Array(scriptures[scriptureIndex].maskedTexts.prefix(dayOfWeek))
    let memorySources = Array(scriptures[scriptureIndex].maskedSources.prefix(dayOfWeek))

    return
      GeometryReader { geometry in
        VStack {
          Spacer()

          // Content
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
              ForEach(0..<memoryTexts.count, id: \.self) { index in
                ScriptureView(text: memoryTexts[index], source: memorySources[index])
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
          HStack(spacing: 8) {
            ForEach(0..<memoryTexts.count, id: \.self) { index in
              ZStack {
                Circle()
                  .fill(pageIndex == index ? Color.blue : Color.gray)
                  .frame(width: 30, height: 30)
                Text(paginationLabel(for: index))
                  .foregroundColor(.white)
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
        //      let dayOfWeek = Calendar.current.component(.weekday, from: Date())
      })
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
