//
//  UIViewController.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiate(from: AppStoryboard) -> Self {
        return from.viewController(viewControllerClass: self)
    }
}
