//
//  SendMoneyViewController.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 08/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

class SendMoneyViewController: UIViewController {
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var coinTypeLabel: UILabel!
    
    ///Controller to return
    var controller: UIViewController!
    var walletFrom: WalletData?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    private var amountString = ""
    private var addressTo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        amountTF.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        addressTF.attributedPlaceholder = NSAttributedString(string: "Insert address \"TO\"", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        coinTypeLabel.text = (walletFrom != nil) ? walletFrom!.coinType.getName : ""
        okButton.isEnabled = false
    }
}

extension SendMoneyViewController {
    @IBAction func digitPressed(sender: UIButton) {
        let tag = sender.tag
        amountString += String(tag)
        amountTF.text = amountString
    }
    
    @IBAction func backPressed(sender: UIButton) {
        if amountString.count > 0 {
            amountString = String(amountString.dropLast())
        }
        amountTF.text = amountString
    }
        
    @IBAction func dotPressed(sender: UIButton) {
            amountString += "."
        amountTF.text = amountString
    }
        
    @IBAction func pastePressed(sender: UIButton) {
        if let paste = UIPasteboard.general.string {
            qrScannerFinished(paste)
        }
    }
            
    @IBAction func scanPressed(sender: UIButton) {
        DispatchQueue.main.async() {
            let qrVC: QRScannerViewController = UIStoryboard(name: "Utils", bundle: nil).instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
            
            self.addChild(qrVC)
            qrVC.view.frame = self.view.frame
            self.view.addSubview(qrVC.view)
            
            qrVC.didMove(toParent: self)
        }
    }
        
    @IBAction func okPressed(sender: UIButton) {
        progressView.isHidden = false
        appDelegate.coordinator.sendMoney(amount: amountTF.text!, walletFrom: walletFrom!, addressTo: addressTo, completion: { (answer) in
            DispatchQueue.main.async {
                self.progressView.isHidden = true
                let message = answer == "" ? "Transfer completed." : answer
                let title = answer == "" ? "Success" : "Error"
                let alert = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
                let ok = UIAlertAction(title:"OK", style: .default, handler: { (action) -> Void in
                    if answer == "" {
                        //Go to the main page
                        let mc = MainViewController.instantiate(from: .Main)
                        UIApplication.setRootView(mc, completion: {() in
                            mc.prepareWallet()
                        })
                    }
                })
                alert.addAction(ok)

                self.present(alert, animated: true, completion: nil)
            }
        })
    }
        
    @IBAction func closePressed(sender: UIButton) {
        UIApplication.setRootView(controller)
    }
        
    @IBAction func settingsPressed(sender: UIButton) {
    }
}

extension SendMoneyViewController: QRScannerDelegate {
    func qrScannerFinished(_ result: String) {
        addressTo = UIPasteboard.general.string!
        DispatchQueue.main.async() {
            self.addressTF.text = self.addressTo
        }
        okButton.isEnabled = addressTo != "" && walletFrom != nil
    }
    
}
