//
//  DetailViewController.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 01.12.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var walletAmountLabel: UILabel!
    @IBOutlet weak var walletAddressLabel: UILabel!
    
    var walletToShow: WalletData?
    private var nonTransformedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let coinText = walletToShow!.coinType.getShortName
        let imgName = walletToShow!.coinType.getName.lowercased() + "_logo"
        coinImage.image = UIImage(named: imgName)
        walletNameLabel.text = walletToShow!.walletName
        let amount = walletToShow!.amount == "" ? "0" : walletToShow!.amount
        walletAmountLabel.text = "\(amount) \(coinText)"
        if let img = generateQRCode(from: walletToShow!.mnemonic) {
            qrCodeImage.image = img
        }
        walletAddressLabel.text = walletToShow!.mnemonic
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    @IBAction func sendButtonClciked(_ sender: Any) {
        //Send
        let vc = SendMoneyViewController.instantiate(from: .Actions)
        let mc = MainViewController.instantiate(from: .Main)
        vc.controller = mc
        vc.walletFrom = walletToShow!
        UIApplication.setRootView(vc)
    }
    
    @IBAction func copyButtonClciked(_ sender: Any) {
        UIPasteboard.general.string = walletToShow!.mnemonic
    }

    @IBAction func cancelButtonClicked(_ sender: Any) {
        UIApplication.setRootView(MainViewController.instantiate(from: .Main))
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [nonTransformedImage!, walletToShow!.address], applicationActivities: [])
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        present(activityViewController, animated: true)
    }
}

extension DetailViewController {
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel") //L, M, Q, H, where each value matches to some error resilience (7%, 15%, 25%, 30% respectively). The higher that value, the larger the output QR code image.
            
            if let output = filter.outputImage {
                let scale = qrCodeImage.frame.width / output.extent.width
                let highScale = 1024 / output.extent.width
                let transform = CGAffineTransform(scaleX: scale, y: scale)
                nonTransformedImage = UIImage(ciImage: output.transformed(by: CGAffineTransform(scaleX: highScale, y: highScale)))
                return UIImage(ciImage: output.transformed(by: transform))
            }
        }

        return nil
    }

}
