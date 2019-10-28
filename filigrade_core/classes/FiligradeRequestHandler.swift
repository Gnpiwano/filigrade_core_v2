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
        method: RequestMethod = .get,
        body: [String: Any] = [:],
        handler: @escaping ((_ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void)
    ){
        guard let url = URL(string: (config.baseURL + path + getParamString(params: params))) else { handler(nil, nil, nil); return}
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headerFactory.create(path: path, config: config)
        
        if method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
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
