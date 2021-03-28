//
//  NetworkReachability.swift
//  StockDemo
//
//  Created by Rahul Dange on 28/03/21.
//

import Network

// -- shared instance
private let _sharedInstance = NetworkReachability.init()

class NetworkReachability {
    
    var pathMonitor: NWPathMonitor!
    var path: NWPath?
    var pathUpdateHandler: ((NWPath) -> Void) = { path in
        NetworkReachability.sharedInstance.path = path
    }
    
    class var sharedInstance: NetworkReachability {
        return _sharedInstance
    }
    
    let backgroudQueue = DispatchQueue.global(qos: .background)
    
    func initialize() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = pathUpdateHandler
        pathMonitor.start(queue: backgroudQueue)
    }
    
    func isNetworkAvailable() -> Bool {
        if let path = NetworkReachability.sharedInstance.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
        return false
    }
}
