//
//  WalletData.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif

public class WalletData: NSObject {
    ///Name of wallet
    public var walletName: String
    ///Public address
    public var address: String
    ///Mnemonic string / seed
    public var mnemonic: String
    ///Password
    public var password: String
    ///Balance
    public var amount: String
    ///Type of coin
    public var coinType: Coin
    
    public override init() {
        walletName = ""
        address = ""
        mnemonic = ""
        password = ""
        amount = ""
        coinType = .Ethereum
        
        super.init()
    }
    
    public convenience init(address: String, mnemonic: String, walletName: String, password: String, coinType: Coin) {
        self.init()
        
        self.address = address
        self.mnemonic = mnemonic
        self.walletName = walletName
        self.password = password
        self.coinType = coinType
        self.amount = ""
    }
    
    public func convertToDictionary() -> NSDictionary {
        let dictToReturn = NSMutableDictionary()
        
        dictToReturn.setValue(walletName, forKey: "wallet_name")
        dictToReturn.setValue(address, forKey: "address")
        dictToReturn.setValue(mnemonic, forKey: "mnemonic")
        dictToReturn.setValue(password, forKey: "password")
        dictToReturn.setValue(amount, forKey: "amount")
        let currValaue = coinType.getName
        dictToReturn.setValue(currValaue, forKey: "coinType")

        return dictToReturn
    }
    
    public func convertToDescription(_ dictionary: NSDictionary) -> WalletData {
        let wd = WalletData()
        
        if  let value = dictionary["wallet_name"] as? String {
            wd.walletName = value
        }
        if  let value = dictionary["address"] as? String {
            wd.address = value
        }
        if  let value = dictionary["mnemonic"] as? String {
            wd.mnemonic = value
        }
        if  let value = dictionary["password"] as? String {
            wd.password = value
        }
        if  let value = dictionary["amount"] as? String {
            wd.amount = value
        }
        if  let value = dictionary["coinType"] as? String {
            wd.coinType = value.getCoinByName()
        }

        return wd
    }

}
