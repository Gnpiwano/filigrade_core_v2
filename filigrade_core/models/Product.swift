//
//  Product.swift
//  filigrade_core
//
//  Created by Guus Iwanow on 22/10/2019.
//  Copyright © 2019 filigrade. All rights reserved.
//

import Foundation

public struct Product: Codable {
    public let title: String?
    public let subTitle: String?
    public let description: String?
    public let identifier: String?
    public let brandIdentifier: String?
    public let url: URL?
    public let payloadId: String?
    public let colorIds: [String]
    public let templateIds: [String]
    public var productNumbers: [String]
    public let decorType: String?
    public let woodgrainType: String?
    public let applicationType: String?
    public let designType: String?
    public let decorDimensions: String?
    public let decorEndlesslyAvailable: Bool
    public let watermarkId: String
    
    public init(
        title: String?,
        subTitle: String?,
        description: String?,
        identifier: String?,
        brandIdentifier: String?,
        url: URL?,
        payloadId: String?,
        colorIds: [String],
        templateIds: [String],
        productNumbers: [String],
        decorType: String?,
        woodgrainType: String?,
        applicationType: String?,
        designType: String?,
        decorDimensions: String?,
        decorEndlesslyAvailable: Bool,
        watermarkId: String
        ) {
        self.title = title
        self.subTitle = subTitle
        self.description = description
        self.identifier = identifier
        self.brandIdentifier = brandIdentifier
        self.url = url
        self.payloadId = payloadId
        self.colorIds = colorIds
        self.templateIds = templateIds
        self.productNumbers = productNumbers
        self.decorType = decorType
        self.woodgrainType = woodgrainType
        self.applicationType = applicationType
        self.designType = designType
        self.decorDimensions = decorDimensions
        self.decorEndlesslyAvailable = decorEndlesslyAvailable
        self.watermarkId = watermarkId
    }
    
    public init?(json dict: [String: Any]) {
        
        if let test = dict["Data"] {
            if let test2 = test as? [String: Any] {
                print(test2)
            }
        }
        
        guard let productDataDict = dict["Data"] as? [String: Any] else { return nil }
        
        print(productDataDict)
        self.title = productDataDict["title"] as? String
        self.subTitle = productDataDict["zzdeknr"] as? String
        self.description = productDataDict["zzdescr"] as? String
        self.identifier = productDataDict["zzdeknr"] as? String
        self.brandIdentifier = productDataDict[""] as? String
        let urlString = productDataDict["url"] as? String
        self.url = (urlString == nil) ? nil : URL(string:  urlString ?? "")
        self.payloadId = productDataDict["title"] as? String
        self.colorIds = productDataDict["zzmatnr"] as? [String] ?? []
        self.productNumbers = productDataDict["zzmatnr"] as? [String] ?? []
        self.decorType = productDataDict["wgbez"] as? String
        self.woodgrainType = productDataDict["zzsdtxt"] as? String
        self.applicationType = productDataDict["zzeatxt"] as? String
        self.designType = productDataDict["zzdttxt"] as? String
        self.decorDimensions = productDataDict["zzraprt"] as? String
        self.decorEndlesslyAvailable = productDataDict["title"] as? Bool ?? false
        
        if let meta = dict["Meta"] as? [String: Any] {
            self.templateIds = meta["Templates"] as? [String] ?? []
            self.watermarkId = meta["Watermark"] as? String ?? ""
        } else {
            self.templateIds = []
            self.watermarkId = ""
        }
    }
}

