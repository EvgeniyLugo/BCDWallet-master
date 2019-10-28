//
//  UIApplication.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static var standardAnimation: UIView.AnimationOptions = .transitionCrossDissolve
    static var curlDownAnimation: UIView.AnimationOptions = .transitionCurlDown
    static var curlUpAnimation: UIView.AnimationOptions = .transitionCurlUp

    public static func setRootView(_ viewController: UIViewController,
                                   options: UIView.AnimationOptions = .transitionCrossDissolve,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.5,
                                   completion: (() -> Void)? = nil) {
        guard animated else {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            return
        }
        
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            UIApplication.shared.keyWindow?.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }

}
