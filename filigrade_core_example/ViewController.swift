//
//  ViewController.swift
//  filigrade_core_example
//
//  Created by Guus Iwanow on 21/10/2019.
//  Copyright © 2019 filigrade. All rights reserved.
//

import UIKit
import filigrade_core

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orange
        
        let config = FiligradeApiConfig(
            baseURL: "https://prod.api.filigrade.com",
            appID: "00000002",
            secretKey: "aKr7313opolis"
        )
        let requestHandler = FiligradeRequestHandler(config: config)
        let productApi = FiligradeProductApi(handler: requestHandler)

        productApi.getProduct(watermark: "0001DDAC") { (response: GETProductResponse) in
            print(response)
            switch response {
            case .success(let product):
                print(product.title)
                print(product.brandIdentifier)
            default: print("error")
            }
        }
    }
}

