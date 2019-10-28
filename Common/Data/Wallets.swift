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
    //        #if DEBUG
            try? walletsString!.write(toFile: Utils.getPathWrite(relative: "bcdcache.txt"), atomically: true, encoding: String.Encoding.utf8)
    //        let sodium = Sodium()
    ////        let secretkey = sodium.secretStream.xchacha20poly1305.key()
    //        let stream_enc = sodium.secretStream.xchacha20poly1305.initPush(secretKey: secretkey)!
    //        let header = stream_enc.header()
    ////        [173, 21, 4, 87, 154, 220, 249, 216, 102, 52, 162, 177, 112, 93, 56, 188, 68, 75, 63, 175, 46, 64, 181, 157]
    //        let userData = userString!.bytes
    //        let encrypted = stream_enc.push(message: userData)!
    //        let data = Data(encrypted) as NSData
    //        let data = Data(userString!.bytes) as NSData
    //        print(data)
    //        data.write(toFile: Utils.getPathWrite(relative: "user2.txt"), atomically: true)
    //
    //
    //        #endif
        }

}
