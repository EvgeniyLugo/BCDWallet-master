//
//  TransactionModel.swift
//  Sodium_iOS
//
//  Created by Evgeniy Lugovoy on 13.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation

public struct TransactionModel {
    public var hash: String
    public var version: Int
    public var lockTime: Int
    public var txIns: [TxIn]
    public var txOuts: [TxOut]
    public var networkName: String
    
    public init() {
        hash = ""
        version = 1
        lockTime = 0
        txIns = [TxIn]()
        txOuts = [TxOut]()
        networkName = "Main"
    }
    
    public init(_ dict: NSDictionary) {
        self.init()
        
        if let valueFromDict = dict["hash"] as? String {
            hash = valueFromDict
        }
        if let valueFromDict = dict["version"] as? Int {
            version = valueFromDict
        }
        if let valueFromDict = dict["lock_time"] as? Int {
            lockTime = valueFromDict
        }
        if let txInsArray = dict["tx_in"] as? NSMutableArray {
            self.txIns = [TxIn]()
            for ins in txInsArray {
                self.txIns.append(TxIn(ins as! NSDictionary))
            }
        }
        if let txOutsArray = dict["tx_out"] as? NSMutableArray {
            self.txOuts = [TxOut]()
            for ons in txOutsArray {
                self.txOuts.append(TxOut(ons as! NSDictionary))
            }
        }
        if let valueFromDict = dict["network_name"] as? String {
            networkName = valueFromDict
        }
    }
    
    public func encodeToData() -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        
        dict.setValue(hash, forKey: "hash")
        dict.setValue(version, forKey: "version")
        dict.setValue(lockTime, forKey: "lock_time")
        let txInsArray = NSMutableArray()
        for txin in txIns {
            txInsArray.add(txin.encodeToData() as Any)
        }
        dict.setValue(txInsArray, forKey: "tx_in")
        let txOutsArray = NSMutableArray()
        for txout in txOuts {
            txOutsArray.add(txout.encodeToData() as Any)
        }
        dict.setValue(txOutsArray, forKey: "tx_out")
        dict.setValue(networkName, forKey: "network_name")

        return dict
    }
}

public struct PreviousOutput {
    public var index: Int
    public var hash: String
    public var value: UInt64
    
    public init() {
        self.index = 0
        self.hash = ""
        self.value = 0
    }

    public init(_ dict: NSDictionary) {
        self.init()
        
        if let valueFromDict = dict["hash"] as? String {
            hash = valueFromDict
        }
        if let valueFromDict = dict["value"] as? UInt64 {
            value = valueFromDict
        }
        if let valueFromDict = dict["index"] as? Int {
            index = valueFromDict
        }
    }
    
    public func encodeToData() -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        
        dict.setValue(index, forKey: "index")
        dict.setValue(hash, forKey: "hash")
        dict.setValue(value, forKey: "value")
        
        return dict
    }
}

public struct TxIn {
    public var sigScript: String
    public var publicKey: [UInt8]
    public var previousOutput: PreviousOutput
    public var sequence: Int
    
    public init() {
        self.sigScript = ""
        self.publicKey = [UInt8]()
        self.previousOutput = PreviousOutput()
        self.sequence = 0
    }

    public init(_ dict: NSDictionary) {
        self.init()
        
        if let valueFromDict = dict["signature_script"] as? String {
            sigScript = valueFromDict
        }
        if let valueFromDict = dict["public_key"] as? [UInt8] {
//            let pls = [UInt8](valueFromDict.utf8)
            publicKey = valueFromDict
        }
        if let valueFromDict = dict["previous_output"] as? NSDictionary {
            previousOutput = PreviousOutput(valueFromDict)
        }
        if let valueFromDict = dict["sequence"] as? Int {
            sequence = valueFromDict
        }
    }
    
    public init(_ sigScript: String, _ publicKey: [UInt8], _ previousOutput: PreviousOutput, _ sequnce: Int) {
        self.sigScript = sigScript
        self.publicKey = publicKey
        self.previousOutput = previousOutput
        self.sequence = sequnce
    }
    
    public func encodeToData() -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        
        dict.setValue(sigScript, forKey: "signature_script")
//        let pk = publicKey.toHex()
        dict.setValue(publicKey, forKey: "public_key")
//        dict.setValue("9uWG1dBRBlpYCWnRX0j4glHtJLnHdCJBC8OaDnJH5To=", forKey: "public_key")
        dict.setValue(previousOutput.encodeToData(), forKey: "previous_output")
        dict.setValue(sequence, forKey: "sequence")
        
        return dict
    }
}

public struct TxOut {
    public var publicKeyScript: String
    public var nodeId: String = "0000000000000000000000000000000000000000000000000000000000000000"
    public var payload: [UInt8]?
    public var value: UInt64
    public var index: Int
    
    public init() {
        self.index = 0
        self.publicKeyScript = ""
        self.value = 0
//        self.payload = [UInt8]()
        self.nodeId = "0000000000000000000000000000000000000000000000000000000000000000"
    }

    public init(_ dict: NSDictionary) {
        self.init()
        
        if let valueFromDict = dict["pk_script"] as? String {
            publicKeyScript = valueFromDict
        }
        if let valueFromDict = dict["node_id"] as? String {
            nodeId = valueFromDict
        }
        if let valueFromDict = dict["payload"] as? [UInt8] {
//            let pls = [UInt8](valueFromDict.utf8)
            payload = valueFromDict
        }
        if let valueFromDict = dict["value"] as? UInt64 {
            value = valueFromDict
        }
        if let valueFromDict = dict["index"] as? Int {
            index = valueFromDict
        }
    }
    
    public init(_ index: Int, _ publicKeyScript: String, _ value: UInt64) {
        self.index = index
        self.publicKeyScript = publicKeyScript
        self.value = value
//        self.payload = [UInt8]()
        self.nodeId = "0000000000000000000000000000000000000000000000000000000000000000"
    }
    
    public func encodeToData() -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(publicKeyScript, forKey: "pk_script")
        dict.setValue(nodeId, forKey: "node_id")
//        let pk = payload.toHexString()
        if let pl = payload {
            dict.setValue(pl, forKey: "payload")
        } else {
            dict.setValue(NSNull(), forKey: "payload")
        }
        dict.setValue(value, forKey: "value")
        dict.setValue(index, forKey: "index")
        
        return dict
    }
}
