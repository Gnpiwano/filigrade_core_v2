//
//  FiligradeRequestHandler.swift
//  filigrade_core
//
//  Created by Guus Iwanow on 21/10/2019.
//  Copyright © 2019 filigrade. All rights reserved.
//
//https://medium.com/flawless-app-stories/create-your-own-cocoapods-library-da589d5cd270

import Foundation

open class FiligradeRequestHandler {
    
    private let config: FiligradeApiConfig
    private let headerFactory = FiligradeApiRequestHeaderFactory()
    
    public init(config: FiligradeApiConfig) {
        self.config = config
    }
    
    public func request(
        path: String,
        params: [String: String] = [:],
        extraHeaders: [String: String]? = nil,
        method: RequestMethod = .get,
        body: Any? = nil,
        handler: @escaping ((_ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void)
    ){
        guard let url = URL(string: (config.baseURL + path + getParamString(params: params))) else { handler(nil, nil, nil); return}
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headerFactory.create(path: path, config: config)
        extraHeaders?.forEach { request.setValue($0.key, forHTTPHeaderField: $0.value) }
        request.httpMethod = method.rawValue
        
        if method != .get {
            if let dictBody = body as? [String: Any] {
                request.httpBody = try? JSONSerialization.data(withJSONObject: dictBody, options: .prettyPrinted)
            } else if let dataBody = body as? Data {
                request.httpBody = dataBody
            }
        } else {
            request.httpBody = nil
        }
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            print(data, response as? HTTPURLResponse, error)
            
            DispatchQueue.main.async {
                handler(data, response as? HTTPURLResponse, error)
            }
        })
        
        task.resume()
    }
    
    private func getParamString(params: [String: String]) -> String {
        var paramString = ""
        params.forEach { (key, value) in
            if paramString.isEmpty {
                paramString.append("?\(key)=\(value)")
            } else {
                paramString.append("&\(key)=\(value)")
            }
        }
        return paramString
    }
}

public enum RequestMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
}
