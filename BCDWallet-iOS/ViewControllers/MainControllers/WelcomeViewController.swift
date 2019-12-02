//
//  WelcomeViewController.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 06/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var importButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        openCircle()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }

    private func openCircle() {
        self.circleView.isHidden = false
        self.bottomView.isHidden = false
        self.cancelButton.isHidden = false
        self.cancelButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
        self.bitButton.transform = CGAffineTransform(rotationAngle: 0)
        self.circleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.circleView.alpha = 0.0
        self.bottomView.alpha = 1.0
        self.cancelButton.alpha = 0.0
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.cancelButton.transform = CGAffineTransform(rotationAngle: 0)
                        self.bitButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
                        self.circleView.alpha = 1.0
                        self.bottomView.alpha = 0.0
                        self.cancelButton.alpha = 1.0
        }) { (succeed) -> Void in
            self.restoreButton.transform = CGAffineTransform(rotationAngle: 0)
            self.createButton.transform = CGAffineTransform(rotationAngle: 0)
            self.importButton.transform = CGAffineTransform(rotationAngle: 0)
            self.animateButtons(times: 2)
            self.bottomView.isHidden = true
        }
    }
    
    private func closeCircle() {
        self.circleView.isHidden = false
        self.bottomView.isHidden = false
        self.cancelButton.isHidden = false
        self.cancelButton.transform = CGAffineTransform(rotationAngle: 0)
        self.bitButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
        self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.circleView.alpha = 1.0
        self.bottomView.alpha = 0.0
        self.cancelButton.alpha = 1.0
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        self.circleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        self.cancelButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
                        self.bitButton.transform = CGAffineTransform(rotationAngle: 0)
                        self.circleView.alpha = 0.0
                        self.bottomView.alpha = 1.0
                        self.cancelButton.alpha = 0.0
        }) { (succeed) -> Void in
            self.circleView.isHidden = true
            self.cancelButton.isHidden = true
        }
    }
    
    private func animateButtons(times: Int) {
        var current = times
        UIView.animate(withDuration: 0.1,
                       animations: { () -> Void in
                        self.restoreButton.transform = CGAffineTransform(rotationAngle: -5.0 / 180 * .pi)
                        self.createButton.transform = CGAffineTransform(rotationAngle: -5.0 / 180 * .pi)
                        self.importButton.transform = CGAffineTransform(rotationAngle: -5.0 / 180 * .pi)
        }) { (succeed) -> Void in
            UIView.animate(withDuration: 0.1,
                           animations: { () -> Void in
                            self.restoreButton.transform = CGAffineTransform(rotationAngle: 5.0 / 180 * .pi)
                            self.createButton.transform = CGAffineTransform(rotationAngle: 5.0 / 180 * .pi)
                            self.importButton.transform = CGAffineTransform(rotationAngle: 5.0 / 180 * .pi)
            }) { (succeed) -> Void in
                current -= 1
                if current == 0 {
                    UIView.animate(withDuration: 0.05,
                                   animations: { () -> Void in
                                    self.restoreButton.transform = CGAffineTransform(rotationAngle: 0)
                                    self.createButton.transform = CGAffineTransform(rotationAngle: 0)
                                    self.importButton.transform = CGAffineTransform(rotationAngle: 0)
                    })
                }
                else {
                    self.animateButtons(times: current)
                }
            }
        }
    }
}

extension WelcomeViewController {
    @IBAction func bitPressed(sender: UIButton) {
        openCircle()
    }
    
    @IBAction func cancelPressed(sender: UIButton) {
        closeCircle()
    }
    
    @IBAction func restorePressed(sender: UIButton) {
        let vc = RestoreViewController.instantiate(from: .Actions)
        vc.controller = self
        UIApplication.setRootView(vc)
    }
    
    @IBAction func createPressed(sender: UIButton) {
        let vc = CreatePasswordViewController.instantiate(from: .Actions)
        vc.controller = self
        UIApplication.setRootView(vc)
    }
    
    @IBAction func importPressed(sender: UIButton) {
        let vc = ImportViewController.instantiate(from: .Actions)
        vc.controller = self
        UIApplication.setRootView(vc)
    }

}
