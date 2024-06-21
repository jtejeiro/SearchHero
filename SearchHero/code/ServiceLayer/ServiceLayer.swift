//
//  ServiceLayer.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//


import Foundation

final class ServiceLayer: ObservableObject {
    
    static func callService<T: Decodable>(_ requestModel: RequestModel, _ modelType: T.Type) async throws -> T{
        
        // Generate Marvel auth parameters
        let authParams = requestModel.parametersConection
        
        // Merge query parameters with auth parameters
        var combinedParams = requestModel.queryItems ?? [:]
        combinedParams.merge(dict: authParams)
        
        //Get query parameters
        var serviceUrl = URLComponents(string: requestModel.getURL())
        serviceUrl?.queryItems =  buildQueryItems(params: combinedParams)
        
        //Unwrap URL
        guard let componentURL = serviceUrl?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: componentURL)
        
        if (requestModel.httpMethod.rawValue == "POST") {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let parameters = buildParamItems(params: requestModel.paramItems ?? [:])
            debugPrint(parameters)
            request.httpBody = parameters.data(using: .utf8)
        }
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            debugPrint(data)
            debugPrint(response)
            
            guard let httpResponse = response as? HTTPURLResponse else{
                throw NetworkError.httpResponseError
            }
            
            if (httpResponse.statusCode > 299){
                throw NetworkError.statusCodeError
            }
            debugPrint(httpResponse.statusCode)
            
            let decoder = JSONDecoder()
            do{
                let decodeData = try decoder.decode(T.self, from: data)
                return decodeData
            }catch{
                print(error)
                throw NetworkError.couldNotDecodeData
            }
            
        }catch{
            throw NetworkError.generic
        }
    }
 
    static func buildQueryItems(params: [String:String]) -> [URLQueryItem]{
        let items = params.map({URLQueryItem(name: $0, value: $1)})
        return items
    }
    
    static func buildParamItems(params: [String:String]) -> String{
        let queryString = params.map { key, value in
            "\(key)=\(value)"
        }.joined(separator: "&")
        return queryString
    }
    
}
