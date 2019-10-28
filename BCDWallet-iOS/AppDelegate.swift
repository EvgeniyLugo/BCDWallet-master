//
//  AppDelegate.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit
//import Velas_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var coordinator = AppCoordinator()
    let pk_crypto = "d4e3d9ee7c9f57dc35db5dd2360f6ee8b5085a9a14878e234b38f154e18b449bd352b77fd8c136ecb42a0909f9496bbaf3229ba243190488bd1fbf9fa62a7ec5"
    let seed = "76c3ee8e5b078b89970d01d8818dd898db34af9758ec780e7f4fffb00e09581c06b0dbe51bc0f430df0cf59cb1de60b9ae8223da8278fcbd3dc514142e425993"
    let pk = "89d5bd2d31889df63cb1c895e4c6f16772e7b06a8c71228bb59d4c9a0c434fc1f6e586d5d051065a580969d15f48f88251ed24b9c77422410bc39a0e7247e53a"
    let myPk = "e02f4f6f4f8c649481de075aa7d15ecd40403b240aa5824d868d0a0025e64882b928945774d812fe08d412125eb037c7e3aa71238939091a8f41c6dec2d82627"
    let sePk = "1403ca30b6cd6a852c4149954bae0422ca28f32d6ecd67a79c1ff9fdee52d3b5e7f371ff8a634e9ab89019dcf8807533d8d4101bc3253f0041519130ff908123"
    let wlBase58 = "VLa1hi77ZXD2BSWDD9wQe8vAhejXyS7vBM4"
    let myBase58 = "VLhkdYXiUSYxRq6W33tqAiYQtbF8R1g6kV8"
    let seBase58 = "VLW44gnSP6DbraGmBnhMYde1izikvoiXQxr"

    let client = Client(address: "https://testnet.velas.website")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//                let keys = HD.init(seed: "76c3ee8e5b078b89970d01d8818dd898db34af9758ec780e7f4fffb00e09581c06b0dbe51bc0f430df0cf59cb1de60b9ae8223da8278fcbd3dc514142e425993", index: 0)
//                print("Public: \(keys.PublicKey.toHexString())")
//                print("Private: \(keys.PrivateKey.toHexString())")
//                let wallet: Wallet = keys.toWallet()
//        //        VLR5ZA1FRb7Z6xdMoeRNUbtaCLq2t3aPVT5
//                print(wallet.base58Address)
//                print("Cha-cha-cha")
//
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


//Tests Crypto
extension AppDelegate {
    private func createWallet() {
        let keys = HD.buildKey()
        let wallet = keys.toWallet()
        print("0. Random base address: \(wallet.base58Address),\nprivate key: \(keys.PrivateKey.toHex())")
    }
    
    private func createWallet(pk: String) {
        let keys = HD.fromPrivateKey(pk)
        let wallet = keys!.toWallet()
//        let success = wallet.base58Address == "VLcN1dBy1VPc9bijr8rzeGbC78MCQ8DjwvS"
        let success = wallet.base58Address == "VLhkdYXiUSYxRq6W33tqAiYQtbF8R1g6kV8"
        print("1. Base address from private key: \(wallet.base58Address), success = \(success),\n public key: \(keys!.PublicKey.toHex())")
    }
    
    private func createWalletFromSeed(seed: String, deriveIndex: Int) {
        let keys = HD(seed: seed, index: deriveIndex)
        let wallet = keys.toWallet()
        let success = wallet.base58Address == "VLcPPgYWpsVXnncCysUwVRkaBCKgPof7Y8W"
        print("2. Base address from seed: \(wallet.base58Address), success = \(success)")
    }

}

//Test Client
extension AppDelegate {
    private func getInfo() {
        client.getInfo(completion: { (data, errorString) -> Void in
            if let ni = data {
                print("3. Get info, height = \(ni.blockchainInfo.height)")
            }
        })
    }
    
    private func getWalletBalance(_ wallet: Wallet) {
        client.getBalance(address: wallet.base58Address, completion: { (data, errorString) -> Void in
            if let balance = data {
                print("4. Get balance, amount = \(balance.amount)")
            }
        })
    }
    
    private func getUnspents(_ wallet: Wallet) {
        client.getUnspents(address: wallet.base58Address, completion: { (data, errorString) -> Void in
            if let unspents = data {
                print("5. Get unspents, hash: \(unspents[0].hash),\nbalance = \(unspents[0].value), \nindex: \(unspents[0].index)")
            }
        })
    }
    
    private func getHashesByWalletAddress(_ wallet: Wallet) {
        client.getHashListByAddress(address: wallet.base58Address, completion: { (data, errorString) -> Void in
            if let hashes = data {
                print("6. Get hashes by address, hash: \(hashes[0])")
            }
        })
    }
    
    private func getTxsByHeight(_ height: Int) {
        client.getHashListByHeight(height: height, completion: { (data, errorString) -> Void in
            if let hashes = data {
                print("7. Get hashes by height, hash: \(hashes[0]),\nlength = \(hashes.count)")
            }
        })
    }
    
    private func getTxsByHashes(_ hashes: [String]) {
        client.getByHashList(hashes: hashes, completion: { (data, errorString) -> Void in
            if let txs = data {
                print("8. Get hashes by list, block: \(txs[0].block)")
            }
        })
    }
    
    private func getBlock(_ block: String) {
        client.getByHash(hash: block, completion: { (data, errorString) -> Void in
//            1563535015
            if let block = data {
                print("9. Get block, timestamp: \(block.header.timeStamp)")
            }
        })
    }
    
    private func validateTx(_ wallet: Wallet, _ keys: HD, _ addressTo: String) {
        client.getUnspents(address: wallet.base58Address, completion: { (data, errorString) -> Void in
            if let unspents = data {
                let tx = Transaction(unspents, 1000, keys, wallet.base58Address, addressTo, 1000000)
                self.client.validate(tx: tx, completion: { (result, errorString) -> Void in
                    print(result)
                })
            }
        })
    }
    
    private func sendTx(_ wallet: Wallet, _ keys: HD, _ addressTo: String) {
        client.getUnspents(address: wallet.base58Address, completion: { (data, errorString) -> Void in
            if let unspents = data {
                let tx = Transaction(unspents, 1000, keys, wallet.base58Address, addressTo, 1000000)
                self.client.publish(tx: tx, completion: { (result, errorString) -> Void in
                    print(result)
                })
            }
        })
    }
}
