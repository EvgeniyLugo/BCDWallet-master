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
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var selectCoinButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createWalletButton: UIButton!
    @IBOutlet weak var downView: UIImageView!

    private var dropDown: DropDown? = nil
    private var cointType: Coin = .Ethereum

//    private let coinTypes = Coin.getCoinNames
    private let coinTypes = ["Ethereum", "Velas"]
    private var dropdownSelected = false
    private var selectedCoin: Int = 0
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    ///Controller to return
    var controller: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createWalletButton.isEnabled = false
        selectCoinButton.setTitle(coinTypes[0], for: .normal)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        confirmTextField.attributedPlaceholder = NSAttributedString(string: "Confirm password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Enter wallet name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }

}

//MARK: - Actions
extension CreatePasswordViewController {
    @IBAction func selectCoinClicked(_ sender: Any) {
        if (self.dropDown == nil) {
            self.view.endEditing(true)
            self.dropDown = DropDown(button: sender as! UIButton, array: coinTypes, downImg: downView)
            self.dropDown!.dropDownDelegate = self
            self.dropdownSelected = true
            createWalletButton.isEnabled = false
        }
        else {
            let duration: TimeInterval = 0.5
            self.dropDown!.hideDropDown(button: sender as! UIButton, duration: duration)
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.5) {
                self.dropDown = nil
                self.dropdownSelected = false
                self.checkCorrect()
            }
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        UIApplication.setRootView(controller)
    }
    
    @IBAction func createWalletClicked(_ sender: Any) {
        if cointType == .Ethereum {
            let alert = UIAlertController(title: "Warning!",
                                          message: "Ethereum coin is under construction.\nPlease select Velas.",
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)

            present(alert, animated: true, completion: nil)
            return
        }
        if let wallet = appDelegate.coordinator.createWallet(coinType: cointType, password: passwordTextField.text!, walletName: nameTextField.text!) {
            let alert = UIAlertController(title: "Success!",
                                          message: "Wallet for coin " + cointType.getName + " created!",
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .default, handler: { (action) -> Void in
                self.appDelegate.coordinator.wallets.wallets.append(wallet)
                self.appDelegate.coordinator.wallets.SaveWallets()
                //Go to the main page
                let mc = MainViewController.instantiate(from: .Main)
                UIApplication.setRootView(mc, completion: {() in
                    mc.tableView.reloadData()
                })
            })
            alert.addAction(ok)

            present(alert, animated: true, completion: nil)

        }
    }
    
    @IBAction func endEditingClicked(_ sender: Any) {
        self.view.endEditing(true)
    }

}

//MARK: - TextFiled Delegate -----------------------------------
extension CreatePasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        checkCorrect()
    }
    
    private func checkCorrect() {
        var isCorrect = false
        if passwordTextField.text != "" && confirmTextField.text == passwordTextField.text && nameTextField.text != "" {
            isCorrect = true
        }
        self.createWalletButton.isEnabled = isCorrect
    }
}

//MARK: - Dropdown
extension CreatePasswordViewController: DropDownDelegate {
    func dropdownSelected(_ sender: UIButton, selected: Int) {
        selectedCoin = selected
        cointType = Coin(rawValue: selectedCoin + 1)!
        let duration: TimeInterval = 0.5
        self.selectCoinButton.setTitle(self.coinTypes[selected], for: .normal)
        self.dropDown!.hideDropDown(button: sender, duration: duration)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.5) {
            self.dropDown = nil
            self.dropdownSelected = false
            self.checkCorrect()
        }
    }
}
