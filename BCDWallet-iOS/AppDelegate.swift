//
//  AppDelegate.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var coordinator = AppCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var mainStoryboard: UIStoryboard
        if UserDefaults.standard.bool(forKey: "agreed") {
            mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        }
        else {
            mainStoryboard = UIStoryboard(name: "Start", bundle: nil)
        }
        let viewController = mainStoryboard.instantiateInitialViewController()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.clear
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        
//        let entropy = Data(hex: "89d5bd2d31889df63cb1c895e4c6f16772e7b06a8c71228bb59d4c9a0c434fc1f6e586d5d051065a580969d15f48f88251ed24b9c77422410bc39a0e7247e53a")
//        let entropy = Data(hex: "0x680fd12caec503a89ea916e00eb1ec2c679071c01165f56b86f03c1cab3a9dc0")
    //"edbc44805d96af3fddb96313bcf2fa5ed20233076995bef454a9fb4a3f721a40db90c5f2465d41aa42143befd29c0ae643329fc54515074793ff9cf9aca4cd20"
//        let mnemonic = Mnemonic.create(entropy: entropy)
//        print(mnemonic)
//        let mnemonic = "mean pupil ensure glide mean wild version decorate nominee change rough solve common subway pretty mixed card frozen guard odor patch canvas disease disagree tortoise cute inject pear grant clown certain demand gap elephant calm phrase spoil friend build lounge donate fun track brother caught verb tube cool"
//        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
//        print(seed.toHexString())
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
