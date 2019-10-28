//
//  TxInfo.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 14.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation

///Transaction status object
public struct TxInfo: Codable {
    public var block: String
    public var confirmed: Int
    public var confirmedTimestamp: Int
    public var size: Int
    public var total: Int
    
    enum CodingKeys: String, CodingKey {
        case block
        case confirmed
        case confirmedTimestamp = "confirmed_timestamp"
        case size
        case total
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        block = try values.decode(String.self, forKey: .block)
        confirmed = try values.decode(Int.self, forKey: .confirmed)
        confirmedTimestamp = try values.decode(Int.self, forKey: .confirmedTimestamp)
        size = try values.decode(Int.self, forKey: .size)
        total = try values.decode(Int.self, forKey: .total)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(block, forKey: .block)
        try container.encode(confirmed, forKey: .confirmed)
        try container.encode(confirmedTimestamp, forKey: .confirmedTimestamp)
        try container.encode(size, forKey: .size)
        try container.encode(total, forKey: .total)
    }

}
