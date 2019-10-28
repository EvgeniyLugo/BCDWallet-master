//
//  User.swift
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

//User description
public class User: NSObject {
    public var password: String
    public var agreed: Bool
//    private let secretkey: Bytes = [165, 206, 210, 217, 244, 111, 102, 126, 135, 183, 230, 221, 198, 171, 198, 93, 73, 22, 117, 163, 145, 191, 20, 166, 170, 96, 156, 42, 246, 128, 141, 241]

    override public init() {
        password = ""
        agreed = false
        
        super.init()
    }

    public static func LoadUser() -> User {
        var ud = User()
        if let dataFilePath = Utils.getPathRead(relative: "user.txt") as String? {
            print(dataFilePath)
            do {
                let data = try String(contentsOfFile: dataFilePath, encoding: .utf8)
                let dict = Utils.convertStringToDict(dataString: data)!
                
                ud = convertToDescription(dict)
                return ud
            }
            catch {
                return ud
            }
        }
        
        return ud
    }
    
    public func SaveUser() -> Void {
        let userString = Utils.convertDictToString(dictionary: self.convertToDictionary())
//        #if DEBUG
        try? userString!.write(toFile: Utils.getPathWrite(relative: "user.txt"), atomically: true, encoding: String.Encoding.utf8)
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

    private func convertToDictionary() -> NSDictionary {
        let dictToReturn = NSMutableDictionary()
        
        dictToReturn.setValue(password, forKey: "password")
        dictToReturn.setValue(agreed, forKey: "agreed")

        return dictToReturn
    }
    
    private static func convertToDescription(_ dictionary: NSDictionary) -> User {
        let ud = User()
        
        if  let pass = dictionary["password"] as? String {
            ud.password = pass
        }
        
        if let agreed = dictionary["agreed"] as? Bool {
            ud.agreed = agreed
        }

        return ud
    }
}
