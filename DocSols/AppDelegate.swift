//
//  AppDelegate.swift
//  DocSols
//
//  Created by Jene Kirishima on 20/04/2018.
//  Copyright © 2018 Jene Kirishima. All rights reserved.
//

import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        MSAppCenter.start("3ec3e765-d147-40d3-81ed-f0250a76a5ff", withServices:[
            MSAnalytics.self,
            MSCrashes.self
            ])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}

