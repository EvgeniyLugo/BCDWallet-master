//
//  ValidateResponse.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 14.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation

///Response of transaction (validate or send) request
public struct ValidateResponse: Codable {
    ///result of transaction
    public var result: String
}
