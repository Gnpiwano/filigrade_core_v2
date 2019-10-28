//
//  FiligradeProductApi.swift
//  filigrade_core
//
//  Created by Guus Iwanow on 21/10/2019.
//  Copyright © 2019 filigrade. All rights reserved.
//

import Foundation
import UIKit

open class FiligradeProductApi {
    
    let handler: FiligradeRequestHandler
    
    public init(handler: FiligradeRequestHandler) {
        self.handler = handler
    }
    
    public func getProduct(watermark: String, with handler: @escaping ((GETProductResponse) -> Void)) {
        let path = "/data/" + watermark
        self.handler.request(path: path) { (data: Data?, response: HTTPURLResponse?, error: Error?) in
            switch response?.statusCode {
            case 200:
                if  let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let product = Product(json: json) {
                    handler(.success(product))
                } else {
                    handler(.unableToParseJson);
                    return
                }
                
            case 400: handler(.unknownApplicationResponse())
            case 404: handler(.dataNotFound())
            default: handler(.genericErrorResponse())
            }
        }
    }
    
    public func getProductImage(watermark: String, colorId: String, with handler: @escaping ((GETProductImage) -> Void)) {
        let path = "/image/" + watermark
        let params = ["color": colorId]
        self.handler.request(path: path, params: params) { (data: Data?, response: HTTPURLResponse?, error: Error?) in
            
            switch response?.statusCode {
            case 200:
                if let data = data, let image = UIImage(data: data ) {
                    handler(.success(image, payload: watermark, colorId: colorId))
                } else {
                    handler(.unableToParseImage);
                    return
                }
            case 400: handler(.unknownApplicationResponse())
            case 404: handler(.dataNotFound())
            default: handler(.genericErrorResponse())
            }
        }
    }
    
    public func getProductTemplate(watermark: String, templateId: String, with handler: @escaping ((GETProductTemplate) -> Void)) {
        let path = "/template/" + watermark
        let params = ["template": templateId]
        self.handler.request(path: path, params: params) { (data: Data?, response: HTTPURLResponse?, error: Error?) in
            guard let data = data, let image = UIImage(data: data ) else { handler(.unableToParseImage); return }
            
            switch response?.statusCode {
            case 200: handler(.success(image))
            case 400: handler(.unknownApplicationResponse())
            case 404: handler(.dataNotFound())
            default: handler(.genericErrorResponse())
            }
        }
    }
    
    public func postVerifyProductTemplate(watermark: String, handler: @escaping ((POSTVerifyProductTemplate) -> Void)) {
        let path = "/verify/"
        let params = ["wm": watermark, "ext": "jpg"]
        self.handler.request(path: path, params: params, method: .post) { (data: Data?, response: HTTPURLResponse?, error: Error?) in
            
            switch response?.statusCode {
            case 200:
                if let dict = data as? [String: Any], let token = dict["Token"] as? String {
                    handler(.successWithToken(token))
                } else {
                    handler(.unableToParseToken)
                    return
                }
            case 400: handler(.unknownApplicationResponse())
            case 404: handler(.dataNotFound())
            default: handler(.genericErrorResponse())
            }
        }
    }
    
    public func getRetrieveVerificationResult(token: String) {
        let path = "/verify/" + token
        
        self.handler.request(path: path) { (data, restponse, error) in
            
        }
    }
}

public enum GETProductResponse {
    case success(Product)
    case dataNotFound(responseCode: Int = 404)
    case unknownApplicationResponse(responseCode: Int = 400)
    case unableToParseJson
    case genericErrorResponse(responseCode: Int = 500)
}

public enum GETProductImage {
    case success(UIImage, payload: String, colorId: String)
    case dataNotFound(responseCode: Int = 404)
    case unknownApplicationResponse(responseCode: Int = 400)
    case unableToParseImage
    case genericErrorResponse(responseCode: Int = 500)
}

public enum GETProductTemplate {
    case success(UIImage)
    case dataNotFound(responseCode: Int = 404)
    case unknownApplicationResponse(responseCode: Int = 400)
    case unableToParseImage
    case genericErrorResponse(responseCode: Int = 500)
}

public enum POSTVerifyProductTemplate {
    case successWithToken(String)
    case dataNotFound(responseCode: Int = 404)
    case unknownApplicationResponse(responseCode: Int = 400)
    case unableToParseToken
    case genericErrorResponse(responseCode: Int = 500)
}

public enum GETRetrieveVerificationResult {
    case successWithToken(String)
    case dataNotFound(responseCode: Int = 404)
    case unknownApplicationResponse(responseCode: Int = 400)
    case unableToParseToken
    case genericErrorResponse(responseCode: Int = 500)
}
