//
//  CrossManager.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 29.10.2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

public class CrossManager: NSObject {
    private let defaultSession = URLSession(configuration: URLSessionConfiguration.default)

    public func getEthereum(completion: @escaping (String?) -> ()) -> Void {
        let urlString = "https://api.etherscan.io/api?module=stats&action=ethprice"
        let url = URL(string: urlString)
        let dataTask = defaultSession.dataTask(with: url!) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let dict = Utils.convertDataToDict(JSONData: data!), let arr = dict["result"] as? NSDictionary, let result = arr["ethusd"] as? String {
                        completion(result)
                    } else {
                        completion(nil)
                    }
                }
                else {
                    completion(nil)
                }
            }
        }
        dataTask.resume()
    }
}
