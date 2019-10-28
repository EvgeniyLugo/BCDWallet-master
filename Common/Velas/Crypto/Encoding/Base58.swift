//
//  Base58.swift
//  Sodium_iOS
//
//  Created by Evgeniy Lugovoy on 12.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation

private struct _Base58: Encoding {
    static let baseAlphabets = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    static var zeroAlphabet: Character = "1"
    static var base: Int = 58

    static func sizeFromByte(size: Int) -> Int {
        return size * 138 / 100 + 1
    }
    static func sizeFromBase(size: Int) -> Int {
        return size * 733 / 1000 + 1
    }
}

public struct Base58 {
    public static func encode(_ bytes: Data) -> String {
        return _Base58.encode(bytes)
    }
    public static func decode(_ string: String) -> Data? {
        return _Base58.decode(string)
    }
    public static func decodeToBytes(_ string: String) -> [UInt8]? {
        return _Base58.decodeToBytes(string)
    }
}
