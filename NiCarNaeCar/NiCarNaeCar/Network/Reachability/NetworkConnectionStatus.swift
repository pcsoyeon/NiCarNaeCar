//
//  NetworkStatus.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/21.
//

import Foundation
import Network

enum ConnectionType {
    case wifi
    case cellular
    case ethernet
    case unknown
}

final class NetworkConnectionStatus {
    
    static let shared = NetworkConnectionStatus()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    typealias completionHanlder = (Bool) -> Void

    // monotior 초기화
    private init() {
        monitor = NWPathMonitor()
    }

    // Network Monitoring 시작
    func startMonitoring(completionHandler: @escaping completionHanlder) {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in

            self.isConnected = path.status == .satisfied
            self.getConnectionType(path)

            completionHandler(self.isConnected)
        }
    }

    // Network Monitoring 종료
    func stopMonitoring() {
        monitor.cancel()
    }

    // Network 연결 타입
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
