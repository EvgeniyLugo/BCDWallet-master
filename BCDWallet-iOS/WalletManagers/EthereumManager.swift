//
//  EthereumManager.swift
//  Sodium_iOS
//
//  Created by Evgeniy Lugovoy on 06/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit
import web3swift

public class EthereumManager: NSObject {
    private var web_3: web3?
    private var address = ""
    
    public func setAddress(address: String) {
        DispatchQueue.main.async {
            self.address = address
            self.web_3 = self.getWeb3()
        }
    }
    
    public func getBalance(address: String) -> String {
        let walletAddress = EthereumAddress(address)! // Address which balance we want to know
        let balanceResult = try! web_3!.eth.getBalance(address: walletAddress)
        let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 3)!

        return balanceString
    }
    
    public func createWallet(password: String, walletName: String) -> Void {
        let keystore = try! EthereumKeystoreV3(password: password)!
        let name = walletName
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
//        let wallet = Wallet(address: address, data: keyData, name: name, isHD: false)
//
//        return wallet
    }
    
    private func getWeb3() -> web3 {
        return web3(provider: Web3HttpProvider(URL(string: address)!)!)
    }
    
}
