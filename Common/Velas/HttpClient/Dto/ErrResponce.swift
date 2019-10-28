//
//  File.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 14.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation

///Error responce dto
public struct ErrResponce: Codable {
    ///user-level status message
    public var status: String
    ///app-specific error code
    public var code: Int
    //app-level error message for debug
    public var error: String
}
