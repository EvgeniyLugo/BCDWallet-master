//
//  AllEnums.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation
///**
// * Extend all enums with a simple method to derive their names.
// */
//extension RawRepresentable where RawValue: Any {
//    /**
//     * The name of the enumeration (as written in case).
//     */
//    public var name: String {
//        get { return String(describing: self) }
//    }
//    
//    /**
//     * The full name of the enumeration
//     * (the name of the enum plus dot plus the name as written in case).
//     */
//    public var description: String {
//        get { return String(reflecting: self) }
//    }
//}

///Coin type
public enum Coin: Int, CaseIterable {
    case All
    case BitCoin
    case Ethereum
    case Sono
    case Velas
    
    public var getName: String {
        switch self {
        case .All:
            return "All"
        case .BitCoin:
            return "BitCoin"
        case .Ethereum:
            return "Ethereum"
        case .Sono:
            return "Sono"
        case .Velas:
            return "Velas"
        }
    }
    
    public var getIndex: Int {
        switch self {
        case .All:
            return 5
        case .BitCoin:
            return 0
        case .Ethereum:
            return 1
        case .Sono:
            return 2
        case .Velas:
            return 3
        }
    }
    
    public var getShortName: String {
        switch self {
        case .All:
            return "All"
        case .BitCoin:
            return "BTC"
        case .Ethereum:
            return "ETH"
        case .Sono:
            return "SONO"
        case .Velas:
            return "VLS"
        }
    }
        
    public static var getNames: [String] {
        let names = Coin.allCases.compactMap({ $0.getName })
        return names
    }
    
    public static var getCoinNames: [String] {
        var names = getNames
        if let index = names.firstIndex(of: "All") {
            names.remove(at: index)
        }
        
        return names
    }
}

extension String {
    public func getCoinByName() -> Coin {
        if self == "ALL" {
            return .All
        }
        else if self == "BitCoin" {
            return .BitCoin
        }
        else if self == "Ethereum" {
            return .Ethereum
        }
        else if self == "Sono" {
            return .Sono
        }
        else if self == "Velas" {
            return .Velas
        }
        else {
            return .Ethereum
        }
    }
}
