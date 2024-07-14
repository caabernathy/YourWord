/**
 * Copyright (c) Christine Abernathy.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import Network
import Observation

@Observable
class NetworkManager {
  static let shared = NetworkManager()
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "NetworkMonitor")
  var isConnected = false

  private init() {
    monitor.pathUpdateHandler = { [weak self] path in
      DispatchQueue.main.async {
        self?.isConnected = path.status == .satisfied
      }
    }
    monitor.start(queue: queue)
  }
}
