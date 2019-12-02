//
//  EthereumManager.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 06/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation
import web3swift

public class EthereumManager: NSObject {
    private var keystoreManager: KeystoreManager!
    private let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    private var web3Network: Web3?
    
    public convenience init(infura networkId: NetworkId, accessToken: String?) {
        self.init()
        
        keystoreManager = KeystoreManager.managerForPath(userDir + "/bip32_keystore")
        if let token = accessToken {
            web3Network = Web3(infura: networkId, accessToken: token)
        }
        else {
            web3Network = Web3(infura: networkId)
        }
        
//        let mnemonics = Mnemonics()
//        print(mnemonics.string)
        //knife calm local make logic praise cage crouch salute fruit horror kiwi track amateur thunder sadness movie twist future call wire income battle round
//        var ks: EthereumKeystoreV3?
//        if (keystoreManager.addresses.count == 0) {
//            ks = try! EthereumKeystoreV3(password: "BANKEXFOUNDATION")
//            let keydata = try! JSONEncoder().encode(ks!.keystoreParams)
//            FileManager.default.createFile(atPath: userDir + "/keystore"+"/key.json", contents: keydata, attributes: nil)
//        } else {
//            ks = try! EthereumKeystoreV3(password: "NEXT")
//            keystoreManager.append(ks!)
//            let keydata = try! JSONEncoder().encode(ks!.keystoreParams)
//            FileManager.default.createFile(atPath: userDir + "/keystore"+"/next.json", contents: keydata, attributes: nil)
//
//            ks = keystoreManager.walletForAddress((keystoreManager.addresses[0])) as? EthereumKeystoreV3
//        }
//        guard let sender = ks?.addresses.first else { return }
//        print(sender)
    }
//    private var web_3: web3?
//    private var address = ""
//    
//    public func setAddress(address: String) {
//        DispatchQueue.main.async {
//            self.address = address
//            self.web_3 = self.getWeb3()
//        }
//    }
    
    public func getBalance(address: String, completion: @escaping (String, String?) -> ()) {
        let walletAddress = EthereumAddress(address) // Address which balance we want to know
        do {
            let balanceResult = try web3Network?.eth.getBalance(address: walletAddress)
            let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult ?? 0, toUnits: .eth, decimals: 3)
            completion(balanceString, nil)
        } catch {
            completion("", "Unknown error")
        }
    }
    
    public func createWallet(password: String, walletName: String) -> WalletData? {
        let mnemonics = Mnemonics()
        let bip32ks = try! BIP32Keystore(mnemonics: mnemonics, password: password)
        let keydata = try! JSONEncoder().encode(bip32ks.keystoreParams)
        FileManager.default.createFile(atPath: userDir + "/bip32_keystore/" + walletName + ".json", contents: keydata, attributes: nil)
        guard let address = bip32ks.addresses.first else { return nil }

        return WalletData(address: address.address, mnemonic: mnemonics.string, walletName: walletName, password: password, coinType: .Ethereum)
    }
//    
//    public func sendEther(value: String, from: WalletData, to: WalletData) {
//        do {
//            let walletAddress = EthereumAddress(from.address)! // Your wallet address
//            let toAddress = EthereumAddress(to.address)!
//            let contract = web_3!.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
//            let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
//            var options = TransactionOptions.defaultOptions
//            options.value = amount
//            options.from = walletAddress
//            options.gasPrice = .automatic
//            options.gasLimit = .automatic
//            let tx = contract.write(
//                "fallback",
//                parameters: [AnyObject](),
//                extraData: Data(),
//                transactionOptions: options)!
////            let writeTX = contract.write("fallback")!
////            writeTX.transactionOptions.from = walletAddress
////            writeTX.transactionOptions.value = amount
//
////            let tmp = try writeTX.send(password: "BCDWallet", transactionOptions: options)
//            let tmp = try tx.send(password: "BCDWallet")
//            print("Success: \(tmp)")
//        } catch Web3Error.nodeError(let descr) {
//            print("Web error: \(descr)")
//        } catch {
//            print("Err: \(error)")
//        }
//    }
//    
//    private func getWeb3() -> web3 {
//        return web3(provider: Web3HttpProvider(URL(string: address)!)!)
//    }
    
}
