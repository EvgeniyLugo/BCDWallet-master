//
//  ImportViewController.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 08/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

class ImportViewController: UIViewController {
    
    ///Controller to return
    var controller: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelClicked(_ sender: Any) {
        UIApplication.setRootView(controller)
    }

    @IBAction func importWalletClicked(_ sender: Any) {
    }

}
