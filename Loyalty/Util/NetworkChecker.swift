//
//  NetworkChecker.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/12/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

/**
    utility class to check whether the network is available prior in performing network operations
 */

import Foundation
import Network
import Connectivity

class NetworkChecker {
    //singleton instane
    static let instance = NetworkChecker()
    
    var delegate: NetworkListener?
    var connectivity = Connectivity()
    var isReachable: Bool { connectivity.isConnected }
    /*
    //use to check network accesibility
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    //computed property to check network availability
    var isReachable: Bool { status == .satisfied || status == .requiresConnection }
    var isReachableOnCellular: Bool = true
    
    fileprivate init() {}
    
    //start monitoring network events
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                print("We're connected!")
                // post connected notification
                self?.delegate?.onNetworkChanged(connected: true, onMobileData: self?.isReachableOnCellular ?? false)
            } else if path.status == .requiresConnection {
                print("Connection enabled. Trying to connect")
                self?.delegate?.onNetworkChanged(connected: true, onMobileData: self?.isReachableOnCellular ?? false)
            } else {
                print("No connection.")
                // post disconnected notification
                self?.delegate?.onNetworkChanged(connected: false, onMobileData: self?.isReachableOnCellular ?? false)
            }
            print("Is Connected through mobile : \(path.isExpensive)")
        }

        //asyncronus operation without blocking main thread using DispatchQueue
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    //stop network event monitoring
    func stopMonitoring() {
        monitor.cancel()
    }
 
 */
    
    //New implementation using Connectivity module
    
    func startMonitoring() {
        connectivity.isPollingEnabled = true
        connectivity.startNotifier()
        connectivity.whenConnected = { connectivity in
            self.delegate?.onNetworkChanged(connected: true, onMobileData: connectivity.isConnectedViaCellular)
        }
        connectivity.whenDisconnected = { connectivity in
            self.delegate?.onNetworkChanged(connected: false, onMobileData: connectivity.isConnectedViaCellular)
        }
    }
    
    func stopMonitoring() {
        connectivity.stopNotifier()
    }
    
}

//MARK: - Protocol to listern to network change events

protocol NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool)
}

//MARK: - Extension for protocol methods

extension NetworkListener {
    func onNetworkChanged(connected: Bool, onMobileData: Bool) {}
}
