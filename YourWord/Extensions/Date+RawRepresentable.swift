//
//  Date+RawRepresentable.swift
//  YourWord
//
//  Created by Christine Abernathy on 11/26/23.
//

import Foundation

extension Date: RawRepresentable {
  public var rawValue: String {
    self.timeIntervalSinceReferenceDate.description
  }

  public init?(rawValue: String) {
    self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
  }
}
