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
    case Ethereum
    case Velas
    case Sono
    case BitCoin

    public var getName: String {
        switch self {
        case .All:
            return "All"
        case .Ethereum:
            return "Ethereum"
        case .Velas:
            return "Velas"
        case .Sono:
            return "Sono"
        case .BitCoin:
            return "BitCoin"
        }
    }
    
    public var getIndex: Int {
        switch self {
        case .All:
            return 5
        case .Ethereum:
            return 0
        case .Velas:
            return 1
        case .Sono:
            return 2
        case .BitCoin:
            return 3
        }
    }
    
    public var getShortName: String {
        switch self {
        case .All:
            return "All"
        case .Ethereum:
            return "ETH"
        case .Velas:
            return "VLS"
        case .Sono:
            return "SONO"
        case .BitCoin:
            return "BTC"
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
