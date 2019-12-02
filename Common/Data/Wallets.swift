//
//  Wallets.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 07/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

public class Wallets: NSObject {
    public var name = "Wallets"
    public var wallets = [WalletData]()
    
    
    public func convertToDictionary() -> NSDictionary {
        let dictToReturn = NSMutableDictionary()
        
        dictToReturn.setValue(name, forKey: "name")
        
        let walletsDict = NSMutableArray()
        for w in wallets {
            walletsDict.add(w.convertToDictionary() as Any)
        }
        dictToReturn.setValue(walletsDict, forKey: "wallets")

        return dictToReturn
    }
    
    public static func convertToDescription(_ dictionary: NSDictionary) -> Wallets {
        let ws = Wallets()
        
        if  let value = dictionary["name"] as? String {
            ws.name = value
        }
        
        if let walletsDict = dictionary["wallets"] as? NSMutableArray {
            var tmpList = [WalletData]()
            let wd = WalletData()
            for w in walletsDict {
                tmpList.append(wd.convertToDescription(w as! NSDictionary))
            }
            ws.wallets = tmpList
        }

        return ws
    }

    public static func LoadWallets() -> Wallets {
        var ws = Wallets()
        if let dataFilePath = Utils.getPathRead(relative: "bcdcache.txt") as String? {
            print(dataFilePath)
            do {
                let data = try String(contentsOfFile: dataFilePath, encoding: .utf8)
                let dict = Utils.convertStringToDict(dataString: data)!
                
                ws = convertToDescription(dict)
                return ws
            }
            catch {
                return ws
            }
        }
        
        return ws
    }
        
    public func SaveWallets() -> Void {
        let walletsString = Utils.convertDictToString(dictionary: self.convertToDictionary())
        try? walletsString!.write(toFile: Utils.getPathWrite(relative: "bcdcache.txt"), atomically: true, encoding: String.Encoding.utf8)
    }

    ///Check for exisitng name
    /// - Parameter walletName: name for check
    public func nameExist(walletName: String) -> Bool {
        for wallet in wallets {
            if wallet.walletName == walletName {
                return true
            }
        }
        
        return false
    }
}
