//
//  MainViewController.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 06/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var btcLabel: UILabel!
    @IBOutlet weak var ethLabel: UILabel!
    @IBOutlet weak var sonoLabel: UILabel!
    @IBOutlet weak var vlsLabel: UILabel!
    @IBOutlet weak var bgGraphImageView: UIImageView!
    @IBOutlet weak var downView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bitButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var coinButton: UIButton!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var othersView: UIView!

    @IBOutlet weak var nothingLabel: UILabel!

    var wallets = [WalletData]()
//    var needCheckBalance = false
    
    private var selectedWallets = [WalletData]()
    
    private var walletToShow: WalletData?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private enum State: Int {
        case none
        case privacy
        case send
    }
    
    private var state: State = .none
    
    private var dropDown: DropDown? = nil
    private var cointType: Coin = .Ethereum
    private let coinTypes = Coin.getNames
    private var dropdownSelected = false
    private var selectedCoin: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareViews()
//        if needCheckBalance {
//            appDelegate.coordinator.checkBalance()
//        }
        prepareWallet()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
}

extension MainViewController {
    private func prepareViews() {
        sendView.isHidden = true
        privacyView.isHidden = true
        othersView.isHidden = true
        closeButton.isHidden = true
        nothingLabel.isHidden = true
    }
}

extension MainViewController {
    func prepareWallet() {
        wallets = appDelegate.coordinator.wallets.wallets
        selectedWallets = wallets
        self.animateTableView()
//        var btc: Float = 0.0
//        var eth: Float = 0.0
//        var sono: Float = 0.0
//        var vls: Float = 0.0
//        for wallet in wallets {
//            if wallet.coinType == .BitCoin {
//                if wallet.amount != "" {
//                    btc += Float(wallet.amount)!
//                }
//            }
//            else if wallet.coinType == .Ethereum {
//                if wallet.amount != "" {
//                    eth += Float(wallet.amount)!
//                }
//            }
//            else if wallet.coinType == .Sono {
//                if wallet.amount != "" {
//                    sono += Float(wallet.amount)!
//                }
//            }
//            else if wallet.coinType == .Velas {
//                if wallet.amount != "" {
//                    vls += Float(wallet.amount)!
//                }
//            }
//        }
//        btcLabel.text =  "\(btc) BTC"
//        ethLabel.text =  "\(eth) ETH"
//        sonoLabel.text = "\(sono) SONO"
//        vlsLabel.text =  "\(vls) VLS"
    }
}

extension MainViewController {
    private func openSendView() {
        self.sendView.isHidden = false
        self.privacyView.isHidden = true
        self.bottomView.isHidden = false
        self.closeButton.isHidden = false
        self.closeButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
        self.sendView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.sendView.alpha = 0.0
        self.bottomView.alpha = 1.0
        self.closeButton.alpha = 0.0
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        self.sendView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.bottomView.transform = CGAffineTransform(scaleX: 0.1, y: 1.0)
                        self.closeButton.transform = CGAffineTransform(rotationAngle: 0)
                        self.bitButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
                        self.sendView.alpha = 1.0
                        self.bottomView.alpha = 0.0
                        self.closeButton.alpha = 1.0
        }) { (succeed) -> Void in
            self.bottomView.isHidden = true
        }
    }
    
    private func closeSendView() {
        self.sendView.isHidden = false
        self.privacyView.isHidden = true
        self.bottomView.isHidden = false
        self.closeButton.isHidden = false
        self.closeButton.transform = CGAffineTransform(rotationAngle: 0)
        self.bitButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
        self.sendView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.bottomView.transform = CGAffineTransform(scaleX: 0.1, y: 1.0)
        self.sendView.alpha = 1.0
        self.bottomView.alpha = 0.0
        self.closeButton.alpha = 1.0
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        self.sendView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        self.bottomView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.closeButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
                        self.bitButton.transform = CGAffineTransform(rotationAngle: 0)
                        self.sendView.alpha = 0.0
                        self.bottomView.alpha = 1.0
                        self.closeButton.alpha = 0.0
        }) { (succeed) -> Void in
            self.sendView.isHidden = true
            self.closeButton.isHidden = true
        }
    }
    
    private func openPrivacyView() {
        self.sendView.isHidden = true
        self.privacyView.isHidden = false
        self.bottomView.isHidden = false
        self.closeButton.isHidden = false
        self.bottomView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.closeButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
        self.privacyView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.privacyView.alpha = 0.0
        self.bottomView.alpha = 1.0
        self.closeButton.alpha = 0.0
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        self.privacyView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.bottomView.transform = CGAffineTransform(scaleX: 0.1, y: 1.0)
                        self.closeButton.transform = CGAffineTransform(rotationAngle: 0)
                        self.bitButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
                        self.privacyView.alpha = 1.0
                        self.bottomView.alpha = 0.0
                        self.closeButton.alpha = 1.0
        }) { (succeed) -> Void in
//            self.bottomView.isHidden = true
        }
    }
    
    private func closePrivacyView() {
        self.sendView.isHidden = true
        self.privacyView.isHidden = false
        self.bottomView.isHidden = false
        self.closeButton.isHidden = false
        self.closeButton.transform = CGAffineTransform(rotationAngle: 0)
        self.bottomView.transform = CGAffineTransform(scaleX: 0.1, y: 1.0)
        self.bitButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
        self.privacyView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.privacyView.alpha = 1.0
        self.bottomView.alpha = 0.0
        self.closeButton.alpha = 1.0
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        self.privacyView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        self.bottomView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.closeButton.transform = CGAffineTransform(rotationAngle: -90.0 / 180 * .pi)
                        self.bottomView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.bitButton.transform = CGAffineTransform(rotationAngle: 0)
                        self.privacyView.alpha = 0.0
                        self.bottomView.alpha = 1.0
                        self.closeButton.alpha = 0.0
        }) { (succeed) -> Void in
            self.privacyView.isHidden = true
            self.closeButton.isHidden = true
        }
    }
}

//Actions
extension MainViewController {
    @IBAction func bitClicked(_ sender: Any) {
//        appDelegate.coordinator.ethereumManager.sendEther(value: "0.05", from: wallets[4], to: wallets[2])
//        animateTableView()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        if state == .privacy {
            closePrivacyView()
        }
        else if state == .send {
            closeSendView()
        }
        state = .none
    }
    
    @IBAction func actionClicked(_ sender: Any) {
        state = .send
        openSendView()
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        state = .privacy
        openPrivacyView()
    }
    
    @IBAction func doAnyClicked(_ sender: UIButton) {
        let tag = sender.tag
        closeClicked(self)
        if tag == 0 {
            //Send
            let vc = SendMoneyViewController.instantiate(from: .Actions)
            vc.controller = self
            UIApplication.setRootView(vc)
        }
        else if tag == 1 {
            //Scan
        }
        else if tag == 2 {
            //Recieve
        }
        else if tag == 3 {
            //Profile
        }
        else if tag == 4 {
            //Privacy
        }
        else {
            //Security
        }
    }
    
    @IBAction func addClicked(_ sender: Any) {
        let vc = CreatePasswordViewController.instantiate(from: .Actions)
        vc.controller = self
        UIApplication.setRootView(vc)
    }
    
    @IBAction func coinClicked(_ sender: Any) {
        if (self.dropDown == nil) {
            self.resignFirstResponder()
            self.dropDown = DropDown(button: sender as! UIButton, array: coinTypes, downImg: downView)
            self.dropDown!.dropDownDelegate = self
            self.dropdownSelected = true
        }
        else {
            let duration: TimeInterval = 0.25
            self.dropDown!.hideDropDown(button: sender as! UIButton, duration: duration)
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.dropDown = nil
                self.dropdownSelected = false
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedWallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell", for: indexPath) as! MainTableViewCell
        let wallet = selectedWallets[indexPath.row]
        let cross = appDelegate.coordinator.crosses[wallet.coinType.getIndex]
        let oldCross = appDelegate.coordinator.oldCrosses[wallet.coinType.getIndex]
        cell.setParameters(wallet: wallet, cross: cross, grow: oldCross < cross)
        cell.progressView.isHidden = false
        print("Current before: \(indexPath.row), amount: \(wallet.amount)")
        appDelegate.coordinator.getBalance(wallet: wallet, completion: { (amount) in
            DispatchQueue.main.async {
                cell.progressView.isHidden = true
                wallet.amount = amount
                cell.refreshAmount(wallet: wallet, cross: cross)
                print("Current after: \(indexPath.row), amount: \(wallet.amount)")
            }
        })
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        walletToShow = selectedWallets[indexPath.row]
        let vc = DetailViewController.instantiate(from: .Main)
        vc.walletToShow = walletToShow!
        UIApplication.setRootView(vc)
    }

    ///Анимация таблицы
    func animateTableView() {
        self.tableView.reloadData()
        
        let cells = self.tableView.visibleCells
        let tableViewHeight: CGFloat = self.tableView.bounds.size.height
        
        for i in cells {
            let cell = i as! MainTableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell = a as! MainTableViewCell
            UIView.animate(withDuration: 1.5,
                           delay: 0.05 * Double(index),
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
}

extension MainViewController: DropDownDelegate {
    func dropdownSelected(_ sender: UIButton, selected: Int) {
        selectedCoin = selected
        cointType = Coin(rawValue: selectedCoin)!
        coinButton.setTitle(coinTypes[selectedCoin], for: .normal)
        selectWallets()
        
        let duration: TimeInterval = 0.25
        self.dropDown!.hideDropDown(button: sender, duration: duration)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.dropDown = nil
            self.dropdownSelected = false
        }
    }
    
    private func selectWallets() {
        if cointType == .All {
            selectedWallets = wallets
        }
        else {
            selectedWallets = wallets.filter( {$0.coinType == cointType} )
            nothingLabel.isHidden = selectedWallets.count > 0
        }
        animateTableView()
    }
}
