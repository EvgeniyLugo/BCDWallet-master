//
//  BIP39SeedGenerator.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 28.11.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation
//import CryptoSwift
//
//public final class Mnemonic: NSObject {
//    
//    public static func create(entropy: Data, language: WordList = .english) -> String {
//        let entropybits = String(entropy.flatMap { ("00000000" + String($0, radix: 2)).suffix(8) })
//        let hashBits = String(entropy.sha256().flatMap { ("00000000" + String($0, radix: 2)).suffix(8) })
//        let checkSum = String(hashBits.prefix((entropy.count * 8) / 32))
//        
//        let words = language.words
//        let concatenatedBits = entropybits + checkSum
//        
//        var mnemonic: [String] = []
//        for index in 0..<(concatenatedBits.count / 11) {
//            let startIndex = concatenatedBits.index(concatenatedBits.startIndex, offsetBy: index * 11)
//            let endIndex = concatenatedBits.index(startIndex, offsetBy: 11)
//            let wordIndex = Int(strtoul(String(concatenatedBits[startIndex..<endIndex]), nil, 2))
//            mnemonic.append(String(words[wordIndex]))
//        }
//        
//        return mnemonic.joined(separator: " ")
//    }
//    
//    public static func createSeed(mnemonic: String, withPassphrase passphrase: String = "") -> Data {
//        guard let password = mnemonic.decomposedStringWithCompatibilityMapping.data(using: .utf8) else {
//            fatalError("Normalizing password failed in \(self)")
//        }
//
//        guard let salt = ("mnemonic" + passphrase).decomposedStringWithCompatibilityMapping.data(using: .utf8) else {
//            fatalError("Normalizing salt failed in \(self)")
//        }
////        let password = mnemonic.joined(separator: " ").data(using: .utf8)
////        let salt = ("mnemonic" + passphrase).toData()
//
//        let output: [UInt8]
//        do {
//            output = try PKCS5.PBKDF2(password: password.bytes, salt: salt.bytes, iterations: 2048, variant: .sha512).calculate()
//        } catch let error {
//            fatalError("PKCS5.PBKDF2 faild: \(error.localizedDescription)")
//        }
//        
//        return Data(output)
//    }
//}
