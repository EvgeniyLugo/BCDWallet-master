//
//  HD.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 09/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation
import Sodium
import CryptoSwift

public struct HD {
    private let KEY = "Velas seed"
    private let HARDENED_OFFSET: UInt32 = 0x80000000
    
    private var publicKey: [UInt8]!
    public var PublicKey: [UInt8] {
        get { return publicKey}
    }
    
    private var privateKey: [UInt8]!
    public var PrivateKey: [UInt8] {
        get { return privateKey}
    }
    
    private var keyPair: Sign.KeyPair!
    public var KeyPair: Sign.KeyPair {
        get { return keyPair}
    }
    
    public init(publicKey: Bytes, privateKey: Bytes) {
        let sodium = Sodium()
        var pk = publicKey
        var sk = privateKey
        keyPair = sodium.sign.keyPair(pk: &pk, sk: &sk)
        self.publicKey = pk
        self.privateKey = sk
    }
    
    public init(keyPair: Sign.KeyPair) {
        self.keyPair = keyPair
        self.publicKey = keyPair.publicKey
        self.privateKey = keyPair.secretKey
    }
    
    public init(seed: String, index: Int) {
        let sodium = Sodium()
        let secret = [UInt8](KEY.utf8)
        let seedBytes = seed.hexToByteArrayInternal()
        let array = try? HMAC(key: secret, variant: .sha512).authenticate(seedBytes!)
        let key = array?.safeSubarray(0, 32)
        let chainCode = array?.safeSubarray(32, 32)
        
        var derivePath = UInt32(index) + HARDENED_OFFSET
        derivePath = derivePath.reverseBytes()
        let dbBytes = derivePath.bytes
        let data = Array<UInt8>.init(repeating: UInt8(), count: 1).concat(arrs: [key!, dbBytes])
        let array2 = try? HMAC(key: chainCode!, variant: .sha512).authenticate(data)
        let key2 = array2?.safeSubarray(0, 32)
        let keyPair = sodium.sign.keyPair(seed: key2!)
        self.publicKey = keyPair?.publicKey
        self.privateKey = keyPair?.secretKey
    }
    
    public mutating func importPublicKey(_ publicKey: Bytes) -> HD {
        var numArray = Array<UInt8>()
        numArray.append(contentsOf: publicKey)
        self.publicKey = numArray
        
        return self
    }
    
    public mutating func importPrivateKey(_ privateKey: Bytes) -> HD {
        var numArray = Array<UInt8>()
        numArray.append(contentsOf: privateKey)
        self.privateKey = numArray
        
        return self
    }
    
    public mutating func importPublicHexKey(_ publicKey: String) -> HD? {
        guard let pk = try? publicKey.hexToByteArray() else {
            return nil
        }
        self.publicKey = pk
        
        return self
    }
    
    public mutating func importPrivateHexKey(_ privateKey: String) -> HD? {
        guard let sk = try? privateKey.hexToByteArray() else {
            return nil
        }
        self.privateKey = sk
        
        return self
    }
    
    public func getHexWif(_ compact: Bool = false) -> String {
        return compact ? privateKey.toHexCompact() : privateKey.toHex()
    }
    
    public func getBaseWif() -> String {
        return Base58.encode(Data(privateKey))
    }
}

extension HD {
    public static func buildKey() -> HD {
        let sodium = Sodium()
        let keyPair = sodium.sign.keyPair()
        
        return HD(keyPair: keyPair!)
    }

    public static func fromPrivateKey(_ wif: String) -> HD? {
        let sodium = Sodium()
        guard let private_key = try? wif.hexToByteArray() else {
            return nil
        }
        guard let public_key = sodium.sign.extractEd25519PublicKeyFromEd25519SecretKey(ed25519SecretKey: private_key) else {
            return nil
        }
        
        return HD(publicKey: public_key, privateKey: private_key)
    }
    
    public static func importBase58Wif(_ wif: String) -> HD? {
        let sodium = Sodium()
        guard let private_key = Base58.decodeToBytes(wif) else {
            return nil
        }
        guard let public_key = sodium.sign.extractEd25519PublicKeyFromEd25519SecretKey(ed25519SecretKey: private_key) else {
            return nil
        }
        
        return HD(publicKey: public_key, privateKey: private_key)
    }
    
    public func toWallet() -> Wallet {
        return Wallet(publickKey: publicKey)
    }
}
