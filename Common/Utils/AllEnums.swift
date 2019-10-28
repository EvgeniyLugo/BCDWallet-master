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
public enum Coin: Int {
    case All
    case BitCoin
    case Ethereum
    case Sono
    case Velas
}
