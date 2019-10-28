//
//  NodeInfo.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 14.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation

///Node information object
public struct NodeInfo: Codable {
    ///Info about node p2p
    public var p2pInfo: P2PPeer
    ///list of p2p peers
    public var p2pPeers: [P2PPeer]
    ///info about blockchain
    public var blockchainInfo: BlockchainInfo
    
    enum CodingKeys: String, CodingKey {
        case p2pInfo = "p2p_info"
        case p2pPeers = "p2p_peers"
        case blockchainInfo = "blockchain"
    }
    
    public init() {
        p2pInfo = P2PPeer()
        p2pPeers = [P2PPeer]()
        blockchainInfo = BlockchainInfo()
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        p2pInfo = try values.decode(P2PPeer.self, forKey: .p2pInfo)
        p2pPeers = try values.decode([P2PPeer].self, forKey: .p2pPeers)
        blockchainInfo = try values.decode(BlockchainInfo.self, forKey: .blockchainInfo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(p2pInfo, forKey: .p2pInfo)
        try container.encode(p2pPeers, forKey: .p2pPeers)
        try container.encode(blockchainInfo, forKey: .blockchainInfo)
    }

}

///Blockchain info object
public struct BlockchainInfo: Codable {
    ///hash of blockchain
    public var height: Int
    ///height of last block
    public var currentCash: String
    ///hash of last epoch block
    public var currentEpoch: String
    
    public init() {
        height = 0
        currentCash = ""
        currentEpoch = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case height
        case currentCash = "current_hash"
        case currentEpoch = "current_epoch"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        height = try values.decode(Int.self, forKey: .height)
        currentCash = try values.decode(String.self, forKey: .currentCash)
        currentEpoch = try values.decode(String.self, forKey: .currentEpoch)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(height, forKey: .height)
        try container.encode(currentCash, forKey: .currentCash)
        try container.encode(currentEpoch, forKey: .currentEpoch)
    }
}

///p2p peer object
public struct P2PPeer: Codable {
    ///id of peer
    public var id: String
    ///name of peer
    public var name: String
    ///address of peer
    public var addr: String
    
    public init() {
        id = ""
        name = ""
        addr = ""
    }
}
