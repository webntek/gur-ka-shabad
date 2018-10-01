//
//  NetworkManager.swift
//  NoLimitFantasySport
//
//  Created by Admin on 10/05/18.
//  Copyright © 2018 ok. All rights reserved.
//

import UIKit

class NetworkManager {
    static var SharedInstance:NetworkManager!
    let reachability = Reachability()!
    var isReachable:Bool = true
    
    class func shared() -> NetworkManager {
        if (SharedInstance == nil) {
            SharedInstance = NetworkManager()
        }
        return SharedInstance
    }
    
    func initialize() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        
        reachability.whenReachable = { reachability in
            self.isReachable = true
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            self.isReachable = false
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
        
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            isReachable = true
            print("Reachable via WiFi")
        case .cellular:
            isReachable = true
            print("Reachable via Cellular")
        case .none:
            isReachable = false
            //AppDelegate.showWarningMessage(title: "NO INTERNET", subtitle: "Internet is not available, please check internet!")
            print("Network not reachable")
        }
    }
}
