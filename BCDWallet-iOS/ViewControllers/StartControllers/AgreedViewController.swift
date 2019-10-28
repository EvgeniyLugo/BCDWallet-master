//
//  AgreedViewController.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

class AgreedViewController: UIViewController {
    @IBOutlet weak var agreedButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        agreedButton.isHidden = true
        forwardButton.isHidden = true
        if UserDefaults.standard.bool(forKey: "agreed") {
            animateButtons(correct: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    private func animateButtons(correct: Bool) {
        UserDefaults.standard.set(correct, forKey: "agreed")
        self.agreedButton.isHidden = false
        self.agreedButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
        self.forwardButton.isHidden = false
        self.forwardButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
        if correct {
            self.agreedButton.alpha = 0
            self.forwardButton.alpha = 0
            UIView.animate(withDuration: 0.5,
                           animations: { () -> Void in
                            self.agreedButton.transform = CGAffineTransform(rotationAngle: 0)
                            self.agreedButton.alpha = 1
                            self.forwardButton.transform = CGAffineTransform(rotationAngle: 0)
                            self.forwardButton.alpha = 1
            })
        }
        else {
            self.agreedButton.alpha = 1
            self.agreedButton.transform = CGAffineTransform(rotationAngle: 0)
            self.forwardButton.alpha = 1
            self.forwardButton.transform = CGAffineTransform(rotationAngle: 0)
            UIView.animate(withDuration: 0.5,
                           animations: { () -> Void in
                            self.agreedButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
                            self.agreedButton.alpha = 0.0
                            self.forwardButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
                            self.forwardButton.alpha = 0.0
            }) { (succeed) -> Void in
                self.agreedButton.isHidden = true
                self.forwardButton.isHidden = true
            }
        }
    }
}

extension AgreedViewController {
    @IBAction func agreedPressed(sender: UIButton) {
        animateButtons(correct: false)
    }

    @IBAction func disagreedPressed(sender: UIButton) {
        animateButtons(correct: true)
    }
    
    @IBAction func backPressed(sender: UIButton) {
        UIApplication.setRootView(StartViewController.instantiate(from: .Start), options: UIApplication.curlDownAnimation)
    }
    
    @IBAction func forwardPressed(sender: UIButton) {
        UIApplication.setRootView(LoginViewController.instantiate(from: .Main))
    }

}
