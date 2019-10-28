//
//  Utils.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif

public class Utils: NSObject {
    static let documentsDirectory =
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    public static let downloadsFolder: String =
    {
        let directoryURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
        
        try! FileManager.default.createDirectory(at: directoryURL!, withIntermediateDirectories: true, attributes: nil)
        
        return directoryURL!.path
    }()
    
    public static func getPathRead(relative: String) -> String?
    {
        
        let path = "\(self.documentsDirectory)/\(relative)"
        
        if FileManager.default.fileExists(atPath: path)
        {
            return path
        }
        
        return Bundle.main.path(forResource: relative, ofType:nil)
    }
    
    public static func getPathWrite(relative: String) -> String
    {
        return "\(self.documentsDirectory)/\(relative)"
    }
    
    public static func convertDictToString(dictionary:NSDictionary) -> String? {
        let JSONData : Data!
        var JSONString: String?
        
        do {
            // Convert the dictionary into a JSON data object.
            JSONData = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            // Convert the JSON data into a string.
            JSONString = NSString(data: JSONData, encoding: String.Encoding.utf8.rawValue)! as String
        }
        catch let parseError as NSError {
            print("Error: \(parseError.domain)")
        }
        
        return JSONString
    }
        
    public static func convertStringToDict(dataString: String) -> NSDictionary? {
        let JSONData: Data! = (dataString as NSString).data(using: String.Encoding.utf8.rawValue) as Data?
        
        if (JSONData != nil) {
            let parsedObject: AnyObject?
            do {
                // Convert the returned data into a dictionary.
                parsedObject = try JSONSerialization.jsonObject(with: JSONData, options: JSONSerialization.ReadingOptions.mutableContainers) as Any as AnyObject
//                parsedObject = try JSONSerialization.jsonObject(with: JSONData) as Any as AnyObject
                if let returnedDict = parsedObject as? NSDictionary {
                    return returnedDict
                }
            }
            catch let parseError as NSError {
                print("Error: \(parseError.domain)")
                return nil
            }
        }
        else {
            //Надо сообщить, что все вообще плохо
            return nil
        }

        return nil
    }
    
    public static func convertDataToDict(JSONData: Data?) -> NSDictionary? {
        if (JSONData != nil) {
            let parsedObject: AnyObject?
            do {
                // Convert the returned data into a dictionary.
                parsedObject = try JSONSerialization.jsonObject(with: JSONData!, options: JSONSerialization.ReadingOptions.mutableContainers) as Any as AnyObject
                if let returnedDict = parsedObject as? NSDictionary {
                    return returnedDict
                }
            }
            catch let parseError as NSError {
                print("Error: \(parseError.domain)")
                return nil
            }
        }
        else {
            //Надо сообщить, что все вообще плохо
            return nil
        }
        
        return nil
    }
    
    #if os(iOS)
    /// Has safe area
    ///
    /// with notch: 44.0 on iPhone X, XS, XS Max, XR.
    ///
    /// without notch: 20.0 on iPhone 8 on iOS 12+.
    ///
    public static var hasiPhoneXSafeArea: Bool {
        guard #available(iOS 11.0, *), let leftPadding = UIApplication.shared.keyWindow?.safeAreaInsets.left, leftPadding > 24 else {
            return false
        }
        return true
    }
    
    public static func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    #endif

}
