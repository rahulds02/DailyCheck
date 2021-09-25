//
//  Reachability.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 13/05/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Reachability {
    
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
         }
        }

       var flags = SCNetworkReachabilityFlags()

       if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
          return false
       }
       let isReachable = flags.contains(.reachable)
       let needsConnection = flags.contains(.connectionRequired)
       //   print(isReachable && !needsConnection)
       return (isReachable && !needsConnection)
    }
}
