//
//  Transaction.swift
//  Sodium_iOS
//
//  Created by Evgeniy Lugovoy on 13.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation
import Sodium

typealias Transaction = TransactionModel

extension TransactionModel {
    public init(_ unspents: [PreviousOutput], _ amount: UInt64, _ key: HD, _ fromAddress: String, _ to: String, _ comission: UInt64) {
        self.init()
        let sodium = Sodium()
        var totalIn: UInt64 = 0
        for previousOutput in unspents {
            totalIn += previousOutput.value
        }
        
        var index: Int = 0
        //comission
        txOuts.append(TxOut(index, "", comission))
        index += 1
        
        //Dest address
        txOuts.append(TxOut(index, Base58.decode(to)?.toHexString() ?? "", amount))
        index += 1
        let change = totalIn - amount - comission
        if change > 0 {
            //My address
            txOuts.append(TxOut(index, Base58.decode(fromAddress)?.toHexString() ?? "", change))
        }

        for previousOutput in unspents {
            let sigMsg = msgForSign(previousOutput.hash, previousOutput.index)
            let sig = sodium.sign.signDetached(message: sigMsg, key: key.PrivateKey)
            txIns.append(TxIn(sig!.toHex(), key.PublicKey, previousOutput, 1))
        }
        hash = generateHash().toHexString()
    }
    
    public func msgForSign(_ hsh: String, _ idx: Int) -> [UInt8] {
        var payload = [UInt8]()
        let h = try! hsh.hexToByteArray()
        payload.append(contentsOf: h)
        payload.append(contentsOf: idx.bytes)
        payload.append(contentsOf: version.bytes)
        payload.append(contentsOf: lockTime.bytes)
        for txOut in txOuts {
            //4.1. add tx index (4 bytes)
            payload.append(contentsOf: txOut.index.bytes)
            //4.2. add tx value (8 bytes)
            payload.append(contentsOf: txOut.value.bytes)
            //4.3. add tx public script key
            let pk = try! txOut.publicKeyScript.hexToByteArray()
            payload.append(contentsOf: pk)
            //4.4. add node id if not empty
            if txOut.nodeId != "" && txOut.nodeId != "0000000000000000000000000000000000000000000000000000000000000000" {
                let nid = try! txOut.nodeId.hexToByteArray()
                payload.append(contentsOf: nid)
            }
        }

        return payload
    }
    
    private func generateHash() -> [UInt8] {
        var payload = [UInt8]()
        //1. add Version
        payload.append(contentsOf: version.bytes)
        //2. add lockTime
        payload.append(contentsOf: lockTime.bytes)
        //3. add TxIns
        for txIn in txIns {
            
            //3.1. add previous output
            //3.1.1. add hash
            let hs = try! txIn.previousOutput.hash.hexToByteArray()
            payload.append(contentsOf: hs)
            //3.1.2. add tx index (4 bytes)
            payload.append(contentsOf: txIn.previousOutput.index.bytes)
            //3.1.3. add tx value (8 bytes)
            payload.append(contentsOf: txIn.previousOutput.value.bytes)
            
            //3.2. add tx sequence (4 bytes)
            payload.append(contentsOf: txIn.sequence.bytes)
            //3.3. add tx public key
            payload.append(contentsOf: txIn.publicKey)
            //3.4. add tx sig script (txIn.sigscript.count bytes)
            let ss = try! txIn.sigScript.hexToByteArray()
            payload.append(contentsOf: ss)
        }
        //4. add TxOuts
        for txOut in txOuts {
            //4.1. add tx index (4 bytes)
            payload.append(contentsOf: txOut.index.bytes)
            //4.2. add tx value (8 bytes)
            payload.append(contentsOf: txOut.value.bytes)
            //4.3. add tx public script key
            let pk = try! txOut.publicKeyScript.hexToByteArray()
            payload.append(contentsOf: pk)
            //4.4. add node id if not empty
            if txOut.nodeId != "" && txOut.nodeId != "0000000000000000000000000000000000000000000000000000000000000000" {
                let nid = try! txOut.nodeId.hexToByteArray()
                payload.append(contentsOf: nid)
            }
        }
        
        return payload.toDoubleSha256()
    }
}

extension TxIn {
    public func forBlkHash() -> [UInt8] {
        var payload = [UInt8]()
        payload.append(contentsOf: toBytes())
        payload.append(contentsOf: sequence.bytes)
        payload.append(contentsOf: publicKey)
        let ss = try! sigScript.hexToByteArray()
        payload.append(contentsOf: ss)
        
        return payload
    }
    
    private func toBytes() -> [UInt8] {
        var payload = [UInt8]()
        let hs = try! previousOutput.hash.hexToByteArray()
        payload.append(contentsOf: hs)
        payload.append(contentsOf: previousOutput.index.bytes)
        payload.append(contentsOf: previousOutput.value.bytes)

        return payload
    }
}

extension TxOut {
    public func forBlkHash() -> [UInt8] {
        var payload = [UInt8]()
        
        payload.append(contentsOf: index.bytes)
        payload.append(contentsOf: value.bytes)
        let pk = try! publicKeyScript.hexToByteArray()
        payload.append(contentsOf: pk)
        if nodeId != "" {
            let nid = try! nodeId.hexToByteArray()
            payload.append(contentsOf: nid)
        }

        return payload
    }

    private func toBytes() -> [UInt8] {
        var payload = [UInt8]()
        let pk = try! publicKeyScript.hexToByteArray()
        payload.append(contentsOf: pk)
        payload.append(contentsOf: index.bytes)
        payload.append(contentsOf: value.bytes)

        return payload
    }
}
