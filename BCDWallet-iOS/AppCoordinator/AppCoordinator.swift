//
//  AppCoordinator.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

public class AppCoordinator: NSObject {
    public var wallets: Wallets
    public var oldCrosses: [Float] = [0.0, 0.0, 0.0, 0.0]
    public var crosses: [Float] = [186.26, 0.023746, 0.0, 0.0]

    public var ethereumManager: EthereumManager!
    public var velasManager: VelasManager!
    
//    private let ethereumAddress = "https://ropsten.infura.io/v3/a88d5a2127824e50a9d5304ff71be9a4"
    private let velasAddress = "https://testnet.velas.website"
    private let crossManager = CrossManager()

    override public init() {
        wallets = Wallets.LoadWallets()
        self.ethereumManager = EthereumManager(infura: .ropsten, accessToken: "a88d5a2127824e50a9d5304ff71be9a4")
        self.velasManager = VelasManager(networkString: velasAddress)
        
        super.init()
        
        self.getCrosses()
    }
}

//MARK: Wallets
extension AppCoordinator {
    func createWallet(coinType: Coin, password: String, walletName: String) -> WalletData? {
        if coinType == .Ethereum {
            return ethereumManager.createWallet(password: password, walletName: walletName)
        }
        else if coinType == .Velas {
            return velasManager.createWallet(password: password, walletName: walletName)
        }

        return nil
    }
    
    func sendMoney(amount: String, walletFrom: WalletData, addressTo: String, completion: @escaping (String) -> ()) {
        if walletFrom.coinType == .Velas {
            if let uintAmount = UInt64(amount) {
                velasManager.sendVelas(privateKey: walletFrom.address, base58Address: walletFrom.mnemonic, base58Address: addressTo, amount: uintAmount, completion: { (result) in
                    completion(result)
                })
            }
            else {
                completion("Incorrect amount")
            }
        }
    }
}

//MARK: - Exchanges
extension AppCoordinator {
    private func getCrosses() {
        oldCrosses = crosses
        crossManager.getEthereum(completion: {(result) -> Void in
            if result != nil {
                self.crosses[0] = Float(result!)!
            }
        })
    }
    
    func getBalance(wallet: WalletData, completion: @escaping (String) -> ()) {
        if wallet.coinType == .Ethereum {
            ethereumManager.getBalance(address: wallet.address, completion: { (data, error) in
                if error == "" {
                    completion(data)
                }
                else {
                    completion("0")
                }
            })
        }
        else if wallet.coinType == .Velas {
            velasManager.getBalance(base58Address: wallet.mnemonic, completion: { (data, error) in
                if error == nil {
                    completion(data)
                }
                else {
                    completion("0")
                }
            })
        }
    }
}
