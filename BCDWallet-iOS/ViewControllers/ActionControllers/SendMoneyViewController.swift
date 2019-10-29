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

    private var amountString = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        amountTF.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        addressTF.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
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
    }
        
    @IBAction func closePressed(sender: UIButton) {
    }
        
    @IBAction func settingsPressed(sender: UIButton) {
    }

    
}
