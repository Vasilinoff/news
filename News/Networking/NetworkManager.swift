//
//  NetworkManager.swift
//  News
//
//  Created by Ponomarev Vasiliy on 16/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import CoreData
import Foundation

class NetworkManager<API: ConfigurationType> {

    private let router = Router<API>()

    enum Result<String> {
        case success
        case failure(String)
    }

    enum NetworkResponse: String {
        case success
        case authError = "Not authorized"
        case badRequest = "Bad request"
        case failed = "Failed"
        case noData = "Response returned with no data to decode"
        case unableToDecode = "Could not decode the response"
    }

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(NetworkResponse.authError.rawValue)
        case 501...600:
            return .failure(NetworkResponse.badRequest.rawValue)
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }

    func request<MapType: Decodable>(_ dump: MapType.Type,
                                     requestType: API,
                                     completion: @escaping ((_ mapType: MapType?, _ error: String?) -> ()) ) {
        
        router.request(requestType) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, "Check connection")
                }
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)

                switch result {
                case .success:
                    guard let responseData = data else {
                        DispatchQueue.main.async {
                            completion(nil, NetworkResponse.noData.rawValue)
                        }
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(MapType.self, from: responseData)

                        DispatchQueue.main.async {
                            completion(apiResponse, nil)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    }
                case .failure(let networkFailure):
                    DispatchQueue.main.async {
                        completion(nil, networkFailure)
                    }
                }
            }

        }
    }
    
}
