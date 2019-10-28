//
//  Balance.swift
//  Sodium_iOS
//
//  Created by Evgeniy Lugovoy on 14.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation

///Balance of wallet Dto
public struct Balance: Codable {
    ///Amount of wallet
    public var amount: UInt64
}
