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
    
    public func postVerifyProductTemplate(watermark: String, image: UIImage, handler: @escaping ((POSTVerifyProductTemplate) -> Void)) {
        let path = "/verify-multipart/"
        let params = ["wm": watermark, "ext": "jpeg"]
        
        let requestData = getRequestDataForImageUpload(image: image)
        
        self.handler.request(
            path: path,
            params: params,
            extraHeaders: requestData?.headerData,
            method: .post,
            body: requestData?.bodyData
        ) { (data: Data?, response: HTTPURLResponse?, error: Error?) in
            
            switch response?.statusCode {
            case 200:
                if
                    let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let token = json["Token"] as? String {
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
    
    public func getRetrieveVerificationResult(token: String, handler: @escaping ((GETVerifyTokenResult) -> Void)) {
        let path = "/verify/" + token
        
        self.handler.request(path: path) { (data, response, error) in
            let error = try? JSONDecoder().decode(FiligradeErrorResponse.self, from: data ?? Data())
            
            if response?.statusCode == 200 {
                if  let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let token = json["Token"] as? String {
                    handler(.verificationIsInProgress(token: token))
                } else {
                    handler(.succes())
                    return
                }
            }
            switch response?.statusCode {
            case 400: handler(.genericError())
            case 404: handler(.unkownToken())
            case 500: error?.code == 91 ? handler(.failedToAlign()) : handler(.noReferenceImageIsAvailable())
            default: handler(.genericError())
            }
        }
    }
    
    private func getRequestDataForImageUpload(image: UIImage) -> (bodyData: Data, headerData: [String: String])? {
        guard let image_data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let boundary = generateBoundaryString()

        let body = NSMutableData()

        let fname = "image.jpeg"
        let mimetype = "image/jpeg"

        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)

        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        
        let header = ["multipart/form-data; boundary=\(boundary)": "Content-Type"]
        
        return (body as Data, header)
    }
    
    private func generateBoundaryString() -> String
    {
        return "Boundary-\(UUID().uuidString)"
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

public enum GETVerifyTokenResult {
    case succes(responseCode: Int = 200, filiCode: Int = 0)
    case genericError(responseCode: Int = 400)
    case unkownToken(responseCode: Int = 404)
    case failedToAlign(responseCode: Int = 500, filiCode: Int = 91)
    case noReferenceImageIsAvailable(responseCode: Int = 500, filiCode: Int = 93)
    case verificationIsInProgress(token: String, responseCode: Int = 200, filiCode: Int = 100)
}
