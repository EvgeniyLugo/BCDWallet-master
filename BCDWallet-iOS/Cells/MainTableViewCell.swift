//
//  MainTableViewCell.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 07/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var growImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setParameters(wallet: WalletData, cross: CGFloat = 0, grow: Bool = true) {
        var coin = "ETH"
        switch wallet.currency {
        case .BitCoin:
            coinLabel.text = "BitCoin"
            coinImage.image = UIImage(named: "bitcoin_logo")
            coin = "BTC"
        case .Ethereum:
            coinLabel.text = "Ethereum"
            coinImage.image = UIImage(named: "ethereum_logo")
        case .Sono:
            coinLabel.text = "Sono"
            coinImage.image = UIImage(named: "sono_logo")
            coin = "SONO"
        case .Velas:
            coinLabel.text = "Velas"
            coinImage.image = UIImage(named: "velas_logo")
            coin = "VLS"
        default:
            coinLabel.text = "Ethereum"
            coinImage.image = UIImage(named: "ethereum_logo")
        }
        addressLabel.text = wallet.address
        totalAmountLabel.text = "\(wallet.amount) \(coin)"
        amountLabel.text = ""
        growImage.image = grow ? UIImage(named: "path_up") : UIImage(named: "path_down")
    }
}
