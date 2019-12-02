//
//  BaseClient.swift
//  BCDWallet-master
//
//  Created by Evgeniy Lugovoy on 14.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import Foundation

public class Client: NSObject {
    private let defaultSession = URLSession(configuration: URLSessionConfiguration.default)

    private var baseUrl = ""

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    convenience public init(address: String) {
        self.init()
        
        baseUrl = address
    }
}

//MARK: - Client
extension Client {
    public func getInfo(completion: @escaping (NodeInfo?, String?) -> ()) -> Void {
        let urlString = "\(baseUrl)/api/v1/info"
        let url = URL(string: urlString)
        let dataTask = defaultSession.dataTask(with: url!) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let body = try self.decoder.decode(NodeInfo.self, from: data!)
                        completion(body, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, error.localizedDescription)
                    }
                }
                else {
                    var errStr: String?
                    if let err = String(bytes: data!, encoding: .utf8) {
                        errStr = err
                    }
                    completion(nil, errStr)
                }
            }
        }
        dataTask.resume()
    }
}

//MARK: - Block
extension Client {
    public func getByHash(hash: String, completion: @escaping (BlockDto?, String?) -> ()) -> Void {
        let urlString = "\(baseUrl)/api/v1/blocks/\(hash)"
        let url = URL(string: urlString)
        let dataTask = defaultSession.dataTask(with: url!) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let dict = Utils.convertDataToDict(JSONData: data!) {
                        let body = BlockDto(dict)
                        completion(body, nil)
                    } else {
                        completion(nil, "Error while decoding data")
                    }
                }
                else {
                    var errStr: String?
                    if let err = String(bytes: data!, encoding: .utf8) {
                        errStr = err
                    }
                    completion(nil, errStr)
                }
            }
        }
        dataTask.resume()
    }
}

//MARK: - Wallet
extension Client {
    public func getBalance(address: String, completion: @escaping (Balance?, String?) -> ()) -> Void {
        let urlString = "\(baseUrl)/api/v1/wallet/balance/\(address)"
        let url = URL(string: urlString)
        let dataTask = defaultSession.dataTask(with: url!) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let body = try self.decoder.decode(Balance.self, from: data!)
                        completion(body, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, error.localizedDescription)
                    }
                }
                else {
                    var errStr: String?
                    if let err = String(bytes: data!, encoding: .utf8) {
                        errStr = err
                    }
                    completion(nil, errStr)
                }
            }
        }
        dataTask.resume()
    }
    
    public func getUnspents(address: String, completion: @escaping ([PreviousOutput]?, String?) -> ()) -> Void {
        let urlString = "\(baseUrl)/api/v1/wallet/unspent/\(address)"
        let url = URL(string: urlString)
        let dataTask = defaultSession.dataTask(with: url!) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let parsedObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        var pos = [PreviousOutput]()
                        for po in parsedObject {
                            pos.append(PreviousOutput(po as! NSDictionary))
                        }
                        completion(pos, nil)
                    }
                    else {
                        completion(nil, "Error while parsing object")
                    }
                }
                else {
                    var errStr: String?
                    if let err = String(bytes: data!, encoding: .utf8) {
                        errStr = err
                    }
                    completion(nil, errStr)
                }
            }
        }
        dataTask.resume()
    }
}

//MARK: - Tx
extension Client {
    public func getHashListByAddress(address: String, completion: @escaping ([String]?, String?) -> ()) -> Void {
        let urlString = "\(baseUrl)/api/v1/wallet/txs/\(address)"
        let url = URL(string: urlString)
        let dataTask = defaultSession.dataTask(with: url!) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let body = try self.decoder.decode([String].self, from: data!)
                        completion(body, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, error.localizedDescription)
                    }
                }
                else {
                    var errStr: String?
                    if let err = String(bytes: data!, encoding: .utf8) {
                        errStr = err
                    }
                    completion(nil, errStr)
                }
            }
        }
        dataTask.resume()
    }
    
    public func getHashListByHeight(height: Int, completion: @escaping ([String]?, String?) -> ()) -> Void {
        let urlString = "\(baseUrl)/api/v1/txs/height/\(height)"
        let url = URL(string: urlString)
        let dataTask = defaultSession.dataTask(with: url!) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let body = try self.decoder.decode([String].self, from: data!)
                        completion(body, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, error.localizedDescription)
                    }
                }
                else {
                    var errStr: String?
                    if let err = String(bytes: data!, encoding: .utf8) {
                        errStr = err
                    }
                    completion(nil, errStr)
                }
            }
        }
        dataTask.resume()
    }
    
    public func getByHashList(hashes: [String], completion: @escaping ([TxInfo]?, String?) -> ()) -> Void {
        let urlString = "\(baseUrl)/api/v1/txs"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let dict: [String: [String]] = ["hashes": hashes]
        let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        request.httpBody = data
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let dataTask = self.defaultSession.dataTask(with: request as URLRequest) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let body = try self.decoder.decode([TxInfo].self, from: data!)
                        completion(body, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, error.localizedDescription)
                    }
                }
                else {
                    var errStr: String?
                    if let err = String(bytes: data!, encoding: .utf8) {
                        errStr = err
                    }
                    completion(nil, errStr)
                }
            }
        }
        dataTask.resume()
    }
    
    public func validate(tx: TransactionModel, completion: @escaping (Bool, String?) -> ()) -> Void {
        let urlString = "\(baseUrl)/api/v1/txs/validate"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        request.httpMethod = "POST"
        let dict = tx.encodeToData()
        let data = try! JSONSerialization.data(withJSONObject: dict, options: [])
        request.httpBody = data
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let dataTask = self.defaultSession.dataTask(with: request as URLRequest) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false, error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200, let res = String(bytes: data!, encoding: .utf8) {
                    if let dict = Utils.convertStringToDict(dataString: res), let answer = dict["result"] as? String {
                        if answer == "ok" {
                            completion(true, nil)
                        } else {
                            completion(false, "Result is incorrect")
                        }
                    } else {
                        completion(false, "Result is incorrect")
                    }
                }
                else {
                    var errStr: String?
                    if let err = String(bytes: data!, encoding: .utf8) {
                        errStr = err
                        print(err)
                    }
                    completion(false, errStr)
                }
            }
        }
        dataTask.resume()
    }
    
    public func publish(tx: TransactionModel, completion: @escaping (Bool, String?) -> ()) -> Void {
        let urlString = "\(baseUrl)/api/v1/txs/publish"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        request.httpMethod = "POST"
        let dict = tx.encodeToData()
        let data = try! JSONSerialization.data(withJSONObject: dict, options: [])
        request.httpBody = data
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let dataTask = self.defaultSession.dataTask(with: request as URLRequest) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false, error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200, let res = String(bytes: data!, encoding: .utf8) {
                    if let dict = Utils.convertStringToDict(dataString: res), let answer = dict["result"] as? String {
                        if answer == "ok" {
                            completion(true, nil)
                        } else {
                            completion(false, "Result is incorrect")
                        }
                    } else {
                        completion(false, "Result is incorrect")
                    }
                }
                else {
                    var errStr: String?
                    if let err = String(bytes: data!, encoding: .utf8) {
                        errStr = err
                        print(err)
                    }
                    completion(false, errStr)
                }
            }
        }
        dataTask.resume()
    }

}
