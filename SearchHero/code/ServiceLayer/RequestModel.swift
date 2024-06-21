//
//  RequestModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//

import Foundation
import CryptoSwift

struct RequestModel  {
    let endpoint : Endpoints
    var endpointsAtribute : EndpointsAtribute = .empty
    var queryItems : [String:String]?
    var paramItems : [String:String]?
    var jsonBody : [String:Any]?
    var httpMethod : HttpMethod = .GET
    var baseUrl : URLBase = .urlBase
    var queryparam : String?
    
    private let KtimestampKey: String = "ts"
    private let KtimestampValue: String = "1234"
    private let KhashKey: String = "hash"
    private let Kapikey: String = "apikey"
    private let apiKeyValue: String = NetworkConstants.shared.publicKey
    private let privateKeyValue: String = NetworkConstants.shared.privateKey
    
    private var hashKeyValue : String {
        return (KtimestampValue + privateKeyValue + apiKeyValue).md5()
    }
    
    var parametersConection:[ String : Any] {
        return [KtimestampKey:KtimestampValue,Kapikey:apiKeyValue,KhashKey:hashKeyValue]
    }
    
    
    func getURL() -> String{
        var endpointString = endpoint.rawValue
        var endpointsAtribute = endpointsAtribute.rawValue
        
        if let param = queryparam {
            endpointString = endpointString.replacingOccurrences(of: "%@", with: param)
        }else {
            endpointString = endpointString.replacingOccurrences(of: "/%@", with: "")
        }
        
        
        return baseUrl.rawValue + endpointString + endpointsAtribute
    }
    
    enum HttpMethod : String{
        case GET
        case POST
    }

    enum Endpoints : String   {
        case characters = "/characters/%@"
        case comics = "/comics/%@"
        case creators = "/creators/%@"
        case events = "/events/%@"
        case series = "/series/%@"
        case stories = "/stories/%@"
        case empty = ""
    }
    
    enum EndpointsAtribute : String   {
        case characters = "/characters"
        case comics = "/comics"
        case events = "/events"
        case series = "/series"
        case stories = "/stories"
        case empty = ""
    }

    enum URLBase {
        case urlBase

        var rawValue: String {
            switch self {
            case .urlBase:
                return NetworkConstants.shared.baseURLApi
            }
        }
    }
    
   
}
