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
    public var ethereumManager: EthereumManager!
    
    private let ethereumAddress = "https://ropsten.infura.io/v3/a88d5a2127824e50a9d5304ff71be9a4"

//    static public let shared = AppCoordinator()

    override public init() {
        wallets = Wallets.LoadWallets()
        self.ethereumManager = EthereumManager()
        self.ethereumManager.setAddress(address: self.ethereumAddress)
        
        super.init()
    }
}
