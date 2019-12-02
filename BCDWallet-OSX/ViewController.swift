//
//  ViewController.swift
//  BCDWallet-OSX
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var amount: NSTextField!
    
    let pk_crypto = "d4e3d9ee7c9f57dc35db5dd2360f6ee8b5085a9a14878e234b38f154e18b449bd352b77fd8c136ecb42a0909f9496bbaf3229ba243190488bd1fbf9fa62a7ec5"
    let seed = "76c3ee8e5b078b89970d01d8818dd898db34af9758ec780e7f4fffb00e09581c06b0dbe51bc0f430df0cf59cb1de60b9ae8223da8278fcbd3dc514142e425993"
    let pk = "89d5bd2d31889df63cb1c895e4c6f16772e7b06a8c71228bb59d4c9a0c434fc1f6e586d5d051065a580969d15f48f88251ed24b9c77422410bc39a0e7247e53a"
    let myPk = "e02f4f6f4f8c649481de075aa7d15ecd40403b240aa5824d868d0a0025e64882b928945774d812fe08d412125eb037c7e3aa71238939091a8f41c6dec2d82627"
    let sePk = "1403ca30b6cd6a852c4149954bae0422ca28f32d6ecd67a79c1ff9fdee52d3b5e7f371ff8a634e9ab89019dcf8807533d8d4101bc3253f0041519130ff908123"
    let wlBase58 = "VLa1hi77ZXD2BSWDD9wQe8vAhejXyS7vBM4"
    let myBase58 = "VLhkdYXiUSYxRq6W33tqAiYQtbF8R1g6kV8"
    let seBase58 = "VLW44gnSP6DbraGmBnhMYde1izikvoiXQxr"

    let client = Client(address: "https://testnet.velas.website")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //        //0. Create wallet
        //        createWallet()
        //        // 1. Wallet from private address
        //        createWallet(pk: myPk)
        //        // 2. Wallet from seed
//                createWalletFromSeed(seed: seed, deriveIndex: 0)
//                createWalletFromBase58(base58: myBase58)
                
//                // Insert code here to initialize your application
//                let keys = HD.fromPrivateKey(pk)
//                let wallet = keys?.toWallet()
//                let myKeys = HD.fromPrivateKey(myPk)
//                let myWallet = myKeys?.toWallet()
//                let seKeys = HD.fromPrivateKey(sePk)
//                let seWallet = seKeys?.toWallet()

        //        // 3. Get info
//                getInfo()

//                // 4. Get balance
//                getWalletBalance(seWallet!)
        //
        //        //5. Get unspents balance
        //        getUnspents(wallet!)
        //
        //        //6. Get hashes by wallet address
        //        getHashesByWalletAddress(wallet!)
        //
        //        //7. Get Txs by height
        //        getTxsByHeight(1500)
        //
        //        //8. Get Txs by hashes
        //        getTxsByHashes(["ca4161d7743a93d4a1c5c4ba8462435dc1a23219941fea5cebc26ff93d2bcec6"])
        //
        //        //9. Get block
        //        getBlock("9dd4130008f179331a1a59854dbc96ba3b1781d54f6d4946681478c86146a415")
        //
        //        //10. Validate Tx
        //        validateTx(wallet!, keys!, myBase58)
        //
                //11. Send
//                sendTx(wallet!, keys!, seBase58)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func checkBalance(_ sender: Any) {
        let seKeys = HD.fromPrivateKey(sePk)
        let seWallet = seKeys?.toWallet()
        getWalletBalance(seWallet!)
    }
    
}

//Tests Crypto
extension ViewController {
    private func createWallet() {
        let keys = HD.buildKey()
        let wallet = keys.toWallet()
        print("0. Random base address: \(wallet.base58Address),\nprivate key: \(keys.PrivateKey.toHex())")
    }
    
    private func createWallet(pk: String) {
        let keys = HD.fromPrivateKey(pk)
        let wallet = keys!.toWallet()
//        let success = wallet.base58Address == "VLcN1dBy1VPc9bijr8rzeGbC78MCQ8DjwvS"
        let success = wallet.base58Address == "VLhkdYXiUSYxRq6W33tqAiYQtbF8R1g6kV8"
        print("1. Base address from private key: \(wallet.base58Address), success = \(success),\n public key: \(keys!.PublicKey.toHex())")
    }
    
    private func createWalletFromSeed(seed: String, deriveIndex: Int) {
        let keys = HD(seed: seed, index: deriveIndex)
        let wallet = keys.toWallet()
        let success = wallet.base58Address == "VLcPPgYWpsVXnncCysUwVRkaBCKgPof7Y8W"
        print("2. Base address from seed: \(wallet.base58Address), success = \(success)")
    }

    private func createWalletFromBase58(base58: String) {
        let keys = HD.importBase58Wif(base58)
        print("Wallet from base58: \(String(describing: keys?.PrivateKey.toHex()))")
    }
}


//Test Client
extension ViewController {
    private func getInfo() {
        client.getInfo(completion: { (data, errorString) -> Void in
            if let ni = data {
                print("3. Get info, height = \(ni.blockchainInfo.height)")
            }
        })
    }
    
    private func getWalletBalance(_ wallet: VelasWallet) {
        client.getBalance(address: wallet.base58Address, completion: { (data, errorString) -> Void in
            if let balance = data {
                print("4. Get balance, amount = \(balance.amount)")
                DispatchQueue.main.async {
                    self.amount.stringValue = String(balance.amount)
                }
            }
        })
    }
    
    private func getUnspents(_ wallet: VelasWallet) {
        client.getUnspents(address: wallet.base58Address, completion: { (data, errorString) -> Void in
            if let unspents = data {
                print("5. Get unspents, hash: \(unspents[0].hash),\nbalance = \(unspents[0].value), \nindex: \(unspents[0].index)")
            }
        })
    }
    
    private func getHashesByWalletAddress(_ wallet: VelasWallet) {
        client.getHashListByAddress(address: wallet.base58Address, completion: { (data, errorString) -> Void in
            if let hashes = data {
                print("6. Get hashes by address, hash: \(hashes[0])")
            }
        })
    }
    
    private func getTxsByHeight(_ height: Int) {
        client.getHashListByHeight(height: height, completion: { (data, errorString) -> Void in
            if let hashes = data {
                print("7. Get hashes by height, hash: \(hashes[0]),\nlength = \(hashes.count)")
            }
        })
    }
    
    private func getTxsByHashes(_ hashes: [String]) {
        client.getByHashList(hashes: hashes, completion: { (data, errorString) -> Void in
            if let txs = data {
                print("8. Get hashes by list, block: \(txs[0].block)")
            }
        })
    }
    
    private func getBlock(_ block: String) {
        client.getByHash(hash: block, completion: { (data, errorString) -> Void in
//            1563535015
            if let block = data {
                print("9. Get block, timestamp: \(block.header.timeStamp)")
            }
        })
    }
    
    private func validateTx(_ wallet: VelasWallet, _ keys: HD, _ addressTo: String) {
        client.getUnspents(address: wallet.base58Address, completion: { (data, errorString) -> Void in
            if let unspents = data {
                let tx = Transaction(unspents, 1000, keys, wallet.base58Address, addressTo, 1000000)
                self.client.validate(tx: tx, completion: { (result, errorString) -> Void in
                    print(result)
                })
            }
        })
    }
    
    private func sendTx(_ wallet: VelasWallet, _ keys: HD, _ addressTo: String) {
        client.getUnspents(address: wallet.base58Address, completion: { (data, errorString) -> Void in
            if let unspents = data {
                let tx = Transaction(unspents, 10000, keys, wallet.base58Address, addressTo, 1000000)
                self.client.publish(tx: tx, completion: { (result, errorString) -> Void in
                    print(result)
                })
            }
        })
    }
}
