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
    public var crosses: [Float] = [0.0, 186.26, 0.0, 0.023746]

    public var ethereumManager: EthereumManager!
    
    private let ethereumAddress = "https://ropsten.infura.io/v3/a88d5a2127824e50a9d5304ff71be9a4"
    private let velasAddress = "https://testnet.velas.website"
    private let crossManager = CrossManager()


    override public init() {
        wallets = Wallets.LoadWallets()
        self.ethereumManager = EthereumManager()
        self.ethereumManager.setAddress(address: self.ethereumAddress)
        
        super.init()
        
        self.getCrosses()
    }
}

//MARK: - Exchanges
extension AppCoordinator {
    private func getCrosses() {
        oldCrosses = crosses
        crossManager.getEthereum(completion: {(result) -> Void in
            if result != nil {
                self.crosses[1] = Float(result!)!
            }
        })
    }
}
