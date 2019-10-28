//
//  ByteArrayExtension.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 09/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

//#if os(iOS)
//import UIKit
//#elseif os(OSX)
//import Cocoa
//#endif

import Foundation
import CryptoSwift

extension Array where Element == UInt8 {
    public func startWith(_ versionBytes: Array<UInt8>) -> Bool {
        if self.count < versionBytes.count {
            return false
        }
        
        var result = true
        
        for i in 0..<versionBytes.count {
            if Int(versionBytes[i]) != Int(self[i]) {
                result = false
                break
            }
        }
        return result
    }
    
    public func safeSubarray(_ offset: Int, _ count: Int) -> Array<UInt8> {

        if offset < 0 || offset > self.count {
            fatalError("Out of range: offset \(offset) is more than array count: \(self.count)")
        }
        if offset < 0 || offset + count > self.count {
            fatalError("Out of range: offset \(offset) + count \(count) is more than array count: \(self.count)")
        }
        if offset == 0 && self.count == count {
            return self
        }
        var numArray = Array<UInt8>()
        for i in offset..<offset + count {
            numArray.append(self[i])
        }
        
        return numArray
    }
    
    public func safeSubarray(_ offset: Int) -> Array<UInt8> {
        if offset < 0 || offset > self.count {
            fatalError("Out of range: offset \(offset) is more than array count: \(self.count)")
        }
        
        let count = self.count - offset
        var numArray = Array<UInt8>()
        for i in offset..<offset + count {
            numArray.append(self[i])
        }
        
        return numArray
    }

    public func concat(arrs: [Array<UInt8>]) -> Array<UInt8>{
        var numArray = Array<UInt8>()

        numArray.append(contentsOf: self)
        for ar in arrs {
            numArray.append(contentsOf: ar)
        }
        
        return numArray
    }
    
    public func toSha256() -> [UInt8] {
        return self.sha256()
    }
    
    public func toDoubleSha256() -> [UInt8] {
        return self.sha256().sha256()
    }
    
    public func encodeData(offset: Int, count: Int) -> String {
        if let result = String(bytes: self, encoding: String.Encoding.ascii) {
            let start = result.index(result.startIndex, offsetBy: offset)
            let end = result.index(start, offsetBy: count)
            let range = start..<end

            let substring = result[range]
            
            return String(substring).replacingOccurrences(of: "\0", with: "")
        }
        else {
            return ""
        }
    }

    public func encodeData() -> String {
        return encodeData(offset: 0, count: self.count)
    }
    
    public func toHex(prefix: Bool = false) -> String {
        let buffer = prefix ? "0x" : ""
        let data = Data(self)
        return buffer + data.reduce("") { $0 + String(format: "%02x", $1) }
    }
    
    public func toHexCompact() -> String {
        var res = toHex()
        if res.starts(with: "0") {
            return String(res.remove(at: res.index(res.startIndex, offsetBy: 0)))
        }
        
        return res
    }
    
}

extension String {
    ///Converts String to [UInt8]
//    var bytes: [UInt8] {
//        if self != "" {
//            return [UInt8](self.utf8)
//        }
//        else {
//            return [UInt8]()
//        }
//    }

    public func hexToByteArrayInternal() -> [UInt8]? {
        if self == "" {
            return [UInt8]()
        }
        else {
            var numArray: [UInt8]
            let length = self.count
            var index1 = self.starts(with: "0x") ? 2 : 0
            let num1 = index1
            var num2 = length - num1
            var flag = false
            if num2 % 2 != 0
            {
                flag = true
                num2 += 1
            }
            numArray = Array<UInt8>.init(repeating: UInt8(), count: num2 / 2)
            var num3 = 0
            if flag {
                let index = self.index(self.startIndex, offsetBy: index1)
                guard let idx = self.fromCharacterToByte(self[index], index1) else {
                    return nil
                }
                numArray[num3] = idx
                num3 += 1
                index1 += 1
            }
            
            for index2 in stride(from: index1, to: length - 1, by: 2) {
                let i4 = self.index(self.startIndex, offsetBy: index2)
                let i5 = self.index(self.startIndex, offsetBy: index2 + 1)
                guard let num4 = self.fromCharacterToByte(self[i4], index2, 4) else {
                    return nil
                }
                guard let num5 = self.fromCharacterToByte(self[i5], index2 + 1) else {
                    return nil
                }
                numArray[num3] = num4 | num5
                num3 += 1
            }
            
            return numArray
        }
    }
    
    public func hexToByteArray() throws -> [UInt8] {
        guard let val = self.hexToByteArrayInternal() else {
            throw NSError(domain: "String \'\(self)\' could not be converted to byte array (not hex?).", code: 0, userInfo: nil)
        }
        
        return val
    }
    
    private func fromCharacterToByte(_ character: Character, _ index: Int, _ shift: Int = 0) -> UInt8? {
        var byte: UInt8 = Array(String(character).utf8)[0]
        if 64 < byte && 71 > byte || 96 < byte && 103 > byte {
            if 64 == 64 & byte {
                if 32 != 32 & byte {
                    byte = UInt8((byte + 10 - 65) << shift)
                }
                else {
                    byte = UInt8((byte + 10 - 97) << shift)
                }
            }
        }
        else {
            if 41 >= byte || 64 <= byte {
                return nil
            }
            byte =  UInt8((byte - 48) << shift)
        }
        
        return byte
    }
    
    public func hasHexPrefix() -> Bool {
        if let result = self.first {
            return String(result) == "0x"
        }
        return false
    }
    
    public func removeHexPrefix() -> String {
        return self.replacingOccurrences(of: "\0", with: "")
    }
    
    public func isTheSameHex(_ second: String) -> Bool {
        let s1 = self.lowercased().ensureHasPrefix()
        let s2 = second.lowercased().ensureHasPrefix()
        
        return s1 == s2
    }
    
    public func ensureHasPrefix() -> String? {
        return !self.hasHexPrefix() ? "0x\(self)" : self
    }

}

///Converts UInt32, UInt64 to [UInt8]
extension FixedWidthInteger where Self: UnsignedInteger {
    ///Converts UInt32, UInt64 to [UInt8]
    var bytes: [UInt8] {
        var _endian = littleEndian
        let bytePtr = withUnsafePointer(to: &_endian) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<Self>.size) {
                UnsafeBufferPointer(start: $0, count: MemoryLayout<Self>.size)
            }
        }
        return [UInt8](bytePtr)
    }

}

extension UInt32 {
    public func reverseBytes() -> UInt32 {
        let left = (self & 0x000000FF) << 24 | (self & 0x0000FF00) << 8
        let right = (self & 0x00FF0000) >> 8 | (self & 0xFF000000) >> 24
        
        return left | right
    }
}

extension Int {
    var bytes: [UInt8] {
//        return withUnsafeBytes(of: self.littleEndian) { Array($0) }
        return UInt32(self).bytes
    }
}
