//
//  FiligradeApiRequestHeaderFactory.swift
//  filigrade_core
//
//  Created by Guus Iwanow on 21/10/2019.
//  Copyright © 2019 filigrade. All rights reserved.
//

import Foundation
import CommonCrypto

public class FiligradeApiRequestHeaderFactory {
   
   public func create(path: String, config: FiligradeApiConfig) -> [String: String] {
       let timeStamp = getTimeStamp()
       let authToken = getAuthToken(appID: config.appID, timeStamp: timeStamp, path: path, secretKey: config.secretKey)
       
       return [
           "Content-Type": "application/json",
           "Accept-Language": config.acceptLanguage ?? getLanguageCode(),
           "X_AUTH_APPID": config.appID,
           "X_AUTH_STAMP": timeStamp,
           "X_AUTH_HASH": authToken,
           "X_DEVID": getUUID()
       ]
   }
   
   private func getLanguageCode() -> String {
       return Locale.current.languageCode ?? "en-US"
   }
   
   private func getTimeStamp() -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyyMMddHHmmss"
       return dateFormatter.string(from: Date())
   }
   
   private func getAuthToken(appID: String, timeStamp: String, path: String, secretKey: String) -> String {
       let authString = appID + "_" + timeStamp + "_" + path + "_" + secretKey
        return sha1(text: authString)
   }
   
   private func getUUID() -> String {
       return UUID().uuidString
   }
    
    func sha1(text: String) -> String {
        let data = Data(text.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return Data(digest).base64EncodedString()
    }
}
