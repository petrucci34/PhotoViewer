//
//  AppDelegate.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/17/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import UIKit

import MobileCenter
import MobileCenterAnalytics
import MobileCenterCrashes
import NVActivityIndicatorView
import SwiftyBeaver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SwiftyBeaver.addDestination(ConsoleDestination())
        NVActivityIndicatorView.configure()

        MSMobileCenter.start("c5439355-2f8a-4dbc-95a1-2ff740f0c01f",
                             withServices: [MSAnalytics.self, MSCrashes.self])

        return true
    }
}

