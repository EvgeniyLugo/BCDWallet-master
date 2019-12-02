//
//  ViewController.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

struct KeychainConfiguration {
  static let serviceName = "BCDWallet"
  static let accessGroup: String? = nil
}

class LoginViewController: UIViewController {
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var touchIDButton: UIButton!
    @IBOutlet var ovalImages: [UIImageView]!
    
    private let touchMe = BiometricIDAuth()
    private var passwordString = ""
    private var checkedPassword = ""
    private var checked = false
    private var isCorrect = false
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: "WalletAccount",
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            checkedPassword = keychainPassword
        }
        catch {
          checkedPassword = ""
        }
        touchIDButton.isHidden = !touchMe.canEvaluatePolicy() || checkedPassword == ""// || touchMe.biometricType() == .faceID
        
        self.okButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if checkedPassword != "" {
            let touchBool = touchMe.canEvaluatePolicy()
            if touchBool {
                self.isCorrect = true
                self.touchIdPressed(sender: self)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }

    private func openWallet(_ deadLine: TimeInterval = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + deadLine) {
            if self.appDelegate.coordinator.wallets.wallets.count > 0 {
                let mc = MainViewController.instantiate(from: .Main)
//                mc.needCheckBalance = true
                UIApplication.setRootView(mc)
            }
            else {
                UIApplication.setRootView(WelcomeViewController.instantiate(from: .Main))
            }
        }
    }
}

extension LoginViewController {
    private func checkOvals() {
        for i in 0..<ovalImages.count {
            if i > passwordString.count - 1 {
                ovalImages[i].image = UIImage(named: "oval_grey")
            }
            else {
                ovalImages[i].image = UIImage(named: "oval_blue")
            }
        }
        if passwordString.count == 6 && !checked {
            checked = true
            touchIDLoginAction(correct: true)
        }
    }
    
    private func touchIDLoginAction(correct: Bool, delay: TimeInterval = 0.0) {
        self.okButton.isHidden = false
        self.okButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
        if correct {
            self.okButton.alpha = 0
            UIView.animate(withDuration: 0.5,
                           delay: delay,
                           animations: { () -> Void in
                            self.okButton.transform = CGAffineTransform(rotationAngle: 0)
                            self.okButton.alpha = 1
            })
        }
        else {
            self.okButton.alpha = 1
            self.okButton.transform = CGAffineTransform(rotationAngle: 0)
            UIView.animate(withDuration: 0.5,
                           delay: delay,
                           animations: { () -> Void in
                            self.okButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
                            self.okButton.alpha = 0.0
            }) { (succeed) -> Void in
                self.okButton.isHidden = true
            }
        }
    }
}

extension LoginViewController {
    @IBAction func digitPressed(sender: UIButton) {
        let tag = sender.tag
        if passwordString.count < 6 {
            passwordString += String(tag)
            checkOvals()
        }
    }
    
    @IBAction func backPressed(sender: UIButton) {
        if passwordString.count > 0 {
            passwordString = String(passwordString.dropLast())
            checkOvals()
        }
        if passwordString.count == 5 {
            checked = false
            touchIDLoginAction(correct: false)
        }
    }
    
    @IBAction func touchIdPressed(sender: Any) {
        touchMe.authenticateUser() { [weak self] message in
          if let message = message {
            DispatchQueue.main.async {
                            // if the completion is not nil show an alert
                let alertView = UIAlertController(title: "Error",
                                                  message: message,
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertView.addAction(okAction)
                self?.present(alertView, animated: true)
            }
          }
          else {
            self?.openWallet(0.5)
          }
        }
    }
    
    @IBAction func dotPressed(sender: UIButton) {
        passwordString += "."
        checkOvals()
    }
    
    @IBAction func okPressed(sender: UIButton) {
        //First time
        if checkedPassword == "" {
            do {
                // This is a new account, create a new keychain item with the account name.
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: "WalletAccount",
                                                        accessGroup: KeychainConfiguration.accessGroup)
              
                // Save the password for the new item.
                try passwordItem.savePassword(passwordString)
            } catch {
                fatalError("Error updating keychain - \(error)")
            }
            openWallet()
        }
        //User exist already
        else {
            if passwordString == checkedPassword || isCorrect {
                openWallet()
            }
            else {
                let alertView = UIAlertController(title: "Error",
                                                  message: "Wrong password!!!",
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertView.addAction(okAction)
                self.present(alertView, animated: true)
            }
        }
    }
    
    @IBAction func exitPressed(sender: UIButton) {
        UIApplication.setRootView(AgreedViewController.instantiate(from: .Start), options: UIApplication.curlUpAnimation)
    }
}
