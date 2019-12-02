//
//  Wallet.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 13.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation
import CryptoSwift

public struct VelasWallet {
    private let _version: [UInt8] = [15, 244]
    private let addressCheckSumLen: Int = 4
    
    private var _base58Address: String
    public var base58Address: String {
        get { return _base58Address }
    }
    
    init(publickKey: [UInt8]) {
        var payload = [UInt8]()
        
        payload.append(contentsOf: _version)
        
        let pub256Key = publickKey.sha256()
        let ripmd160 = RIPEMD160.hash(message: Data(pub256Key))
        payload.append(contentsOf: ripmd160)
        
        let firstSha256 = payload.sha256()
        let secondSha256 = firstSha256.sha256()
        var checkSum = Array<UInt8>()
        for i in 0..<addressCheckSumLen {
            checkSum.append(secondSha256[i])
        }
        payload.append(contentsOf: checkSum)
        
        _base58Address = Base58.encode(Data(payload))
    }
}
