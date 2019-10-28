//
//  BlockDto.swift
//  Sodium_iOS
//
//  Created by Evgeniy Lugovoy on 14.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation

///Block dto
public struct BlockDto {
    ///Block header
    public var header: HeaderDto
    ///Transaction array in block
    public var txns: [TransactionModel]
    
    public init() {
        self.header = HeaderDto()
        self.txns = [TransactionModel]()
    }
    
    public init(_ dict: NSDictionary) {
         self.init()
         
         if let valueFromDict = dict["header"] as? NSDictionary {
             header = HeaderDto(valueFromDict)
         }
         if let tms = dict["txns"] as? NSMutableArray {
             self.txns = [TransactionModel]()
             for tm in tms {
                 self.txns.append(TransactionModel(tm as! NSDictionary))
             }
         }
     }

}

///Block header
public struct HeaderDto: Codable {
    public var adviceCount: Int
    public var bits: Int
    public var hash: String
    public var height: Int
    public var merkleRoot: String
    public var nonce: Int
    public var prevBlock: String
    public var script: String
    public var seed: String
    public var size: Int
    public var timeStamp: Int
    public var txnCount: Int
    public var type: Int
    public var version: Int = 1
    
    public init() {
        adviceCount = 0
        bits = 0
        hash = ""
        height = 0
        merkleRoot = ""
        nonce = 0
        prevBlock = ""
        script = ""
        seed = ""
        size = 0
        timeStamp = 0
        txnCount = 0
        type = 0
        version = 1
    }
    
    public init(_ dict: NSDictionary) {
        self.init()
        
        if let valueFromDict = dict["advice_count"] as? Int {
            adviceCount = valueFromDict
        }
        if let valueFromDict = dict["bits"] as? Int {
            bits = valueFromDict
        }
        if let valueFromDict = dict["hash"] as? String {
            hash = valueFromDict
        }
        if let valueFromDict = dict["height"] as? Int {
            height = valueFromDict
        }
        if let valueFromDict = dict["merkle_root"] as? String {
            merkleRoot = valueFromDict
        }
        if let valueFromDict = dict["nonce"] as? Int {
            nonce = valueFromDict
        }
        if let valueFromDict = dict["prev_block"] as? String {
            prevBlock = valueFromDict
        }
        if let valueFromDict = dict["script"] as? String {
            script = valueFromDict
        }
        if let valueFromDict = dict["seed"] as? String {
            seed = valueFromDict
        }
        if let valueFromDict = dict["size"] as? Int {
            size = valueFromDict
        }
        if let valueFromDict = dict["timestamp"] as? Int {
            timeStamp = valueFromDict
        }
        if let valueFromDict = dict["txn_count"] as? Int {
            txnCount = valueFromDict
        }
        if let valueFromDict = dict["type"] as? Int {
            type = valueFromDict
        }
        if let valueFromDict = dict["version"] as? Int {
            version = valueFromDict
        }
    }

}
