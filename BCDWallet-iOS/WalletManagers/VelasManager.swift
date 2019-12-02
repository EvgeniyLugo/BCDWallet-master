//
//  VelasManager.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 01.12.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

public class VelasManager: NSObject {
    private var client: Client!
    
    public convenience init(networkString: String) {
        self.init()
        
        client = Client(address: networkString)
    }
    
    public func createWallet(password: String, walletName: String) -> WalletData? {
        let keys = HD.buildKey()
        let wallet = keys.toWallet()

        return WalletData(address: keys.PrivateKey.toHex(), mnemonic: wallet.base58Address, walletName: walletName, password: password, coinType: .Velas)
    }
    
    public func restoreWallet(from privateKey: String, password: String, walletName: String) -> WalletData? {
        if let keys = HD.fromPrivateKey(privateKey) {
            let wallet = keys.toWallet()

            return WalletData(address: keys.PrivateKey.toHex(), mnemonic: wallet.base58Address, walletName: walletName, password: password, coinType: .Velas)
        }
        
        return nil
    }
    
    public func getBalance(base58Address: String, completion: @escaping (String, String?) -> ()) {
        var result = ""
        client.getBalance(address: base58Address, completion: { (data, errorString) -> Void in
            if let balance = data {
                result = String(balance.amount)
            }
            completion(result, errorString)
        })
    }
    
    public func sendVelas(privateKey: String, base58Address addressFrom: String, base58Address addressTo: String, amount: UInt64, completion: @escaping (String) -> ()) {
        var error = ""
        client.getUnspents(address: addressFrom, completion: { (data, errorString) -> Void in
            if let unspents = data, let keys = HD.fromPrivateKey(privateKey) {
                let comission: UInt64 = 100000
                let tx = Transaction(unspents, amount, keys, addressFrom, addressTo, comission)
                self.client.publish(tx: tx, completion: { (result, errorString) -> Void in
                    if !result {
                        error = errorString ?? "Unknown error"
                    }
                    completion(error)
                })
            }
        })
    }
}
