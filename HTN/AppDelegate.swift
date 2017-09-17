//
//  AppDelegate.swift
//  HTN
//
//  Created by Ziyin Wang on 2017-09-15.
//  Copyright © 2017 ziyincody. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTableViewController")
        let vc1 = CameraViewController()
        let vc2 = PagerViewController()
        let navVC = UINavigationController(rootViewController: vc1)
        navVC.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = navVC
        
        return true
    }
}

