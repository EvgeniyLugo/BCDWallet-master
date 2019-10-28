//
//  CreatePasswordViewController.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 08/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

class CreatePasswordViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet weak var selectCoinButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createWalletButton: UIButton!
    @IBOutlet weak var downView: UIImageView!

    private var dropDown: DropDown? = nil
    private var cointType: Coin = .Ethereum

    private let coinTypes = ["Ethereum", "Velas"]
    private var dropdownSelected = false
    private var selectedCoin: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectCoinClicked(_ sender: Any) {
        if (self.dropDown == nil) {
            self.resignFirstResponder()
            self.dropDown = DropDown(button: sender as! UIButton, height: 200, array: coinTypes, downImg: downView)
            self.dropDown!.dropDownDelegate = self
            self.dropdownSelected = true
        }
        else {
            let duration: TimeInterval = 0.5
            self.dropDown!.hideDropDown(button: sender as! UIButton, duration: duration)
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.5) {                self.dropDown = nil
                self.dropdownSelected = false
            }
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
    }

    @IBAction func createWalletClicked(_ sender: Any) {
    }
}

extension CreatePasswordViewController: DropDownDelegate {
    func dropdownSelected(_ sender: UIButton, selected: Int) {
        selectedCoin = selected
        cointType = Coin(rawValue: selectedCoin)!
        let duration: TimeInterval = 0.5
        self.dropDown!.hideDropDown(button: sender, duration: duration)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.5) {                self.dropDown = nil
            self.dropdownSelected = false
        }
    }
    
    
}
