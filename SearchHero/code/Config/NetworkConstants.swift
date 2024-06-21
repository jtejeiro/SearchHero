//
//  NetworkConstants.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//
import UIKit
import Foundation

final class NetworkConstants {
    
    // MARK: - Constant
    
    private let typeFileNetworkConstants = "plist"
    private let nameFileNetworkConstants = "Config"
    
    // MARK: - Shared Instance
    
    static let shared = NetworkConstants()
    
    
    // MARK: - Properties
    
    private var plistNetworkConstants : Dictionary<String, Any>?
    
    
    // MARK: - Init
    init() {
        if let path = Bundle.main.path(forResource: nameFileNetworkConstants, ofType: typeFileNetworkConstants) {
            plistNetworkConstants = NSDictionary(contentsOfFile: path) as? [String: AnyObject]
        }
    }
    
    var baseURL: String {
        guard let baseURL = plistNetworkConstants?["baseURL"] as? String else {
            return ""
        }
        return baseURL
    }
    
    var versionApi: String {
        guard let versionApi = plistNetworkConstants?["versionApi"] as? String else {
            return ""
        }
        return versionApi
    }
    
    var apikey: String {
        guard let apikey = plistNetworkConstants?["PublicKey"] as? String else {
            return ""
        }
        return apikey
    }
    
    var publicKey: String {
        guard let publicKey = plistNetworkConstants?["PublicKey"] as? String else {
            return ""
        }
        return publicKey
    }
    
    
    var privateKey: String {
        guard let privateKey = plistNetworkConstants?["PrivateKey"] as? String else {
            return ""
        }
        return privateKey
    }
    
    var routeApi: String {
        guard let routeApi = plistNetworkConstants?["RouterApi"] as? String else {
            return ""
        }
        return routeApi
    }
    
    var baseURLApi: String {
        return baseURL + "/" + versionApi + "/" + routeApi
    }
    
    
    
}
