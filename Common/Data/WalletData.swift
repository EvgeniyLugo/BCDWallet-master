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
    public var walletName: String
    public var address: String
    public var privateKey: String
    public var password: String
    public var encryptedJson: String
    public var amount: Decimal
    public var currency: Coin
    
    public override init() {
        walletName = ""
        address = ""
        privateKey = ""
        password = ""
        encryptedJson = ""
        amount = 0
        currency = .Ethereum
        
        super.init()
    }
    
    public func convertToDictionary() -> NSDictionary {
        let dictToReturn = NSMutableDictionary()
        
        dictToReturn.setValue(walletName, forKey: "wallet_name")
        dictToReturn.setValue(address, forKey: "address")
        dictToReturn.setValue(privateKey, forKey: "private_key")
        dictToReturn.setValue(password, forKey: "password")
        dictToReturn.setValue(encryptedJson, forKey: "encrypted")
        dictToReturn.setValue(amount, forKey: "amount")
        dictToReturn.setValue(currency.rawValue, forKey: "currency")

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
        if  let value = dictionary["private_key"] as? String {
            wd.privateKey = value
        }
        if  let value = dictionary["password"] as? String {
            wd.password = value
        }
        if  let value = dictionary["encrypted"] as? String {
            wd.encryptedJson = value
        }
        if  let value = dictionary["amount"] as? Decimal {
            wd.amount = value
        }
        if  let value = dictionary["currency"] as? Int {
            wd.currency = Coin(rawValue: value)!
        }

        return wd
    }

}
