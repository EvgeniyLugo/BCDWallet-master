//
//  MainTableViewCell.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 07/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var growImage: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setParameters(wallet: WalletData, cross: Float = 0, grow: Bool = true) {
        let coinText = wallet.coinType.getShortName
        let imgName = wallet.coinType.getName.lowercased() + "_logo"
        coinImage.image = UIImage(named: imgName)
        addressLabel.text = wallet.walletName
        growImage.image = grow ? UIImage(named: "path_up") : UIImage(named: "path_down")

        let amount = wallet.amount == "" ? "0" : wallet.amount
        amountLabel.text = "\(amount) \(coinText)"
        let usd = Float(amount)! * cross
        totalAmountLabel.text = "$ \(usd)"
    }
    
    func refreshAmount(wallet: WalletData, cross: Float = 0) {
        let amount = wallet.amount == "" ? "0" : wallet.amount
        amountLabel.text = "\(amount) \(wallet.coinType.getShortName)"
        let usd = Float(amount)! * cross
        totalAmountLabel.text = "$ \(usd)"
    }
}
