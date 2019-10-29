//
//  RoundedCornersButton.swift
//  YogaCraft
//
//  Created by Evgeniy Lugovoy on 18/08/2019.
//  Copyright © 2019 MeadowsPhone. All rights reserved.
//

import UIKit

@IBDesignable
public final class RoundedConersButton: UIButton {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
