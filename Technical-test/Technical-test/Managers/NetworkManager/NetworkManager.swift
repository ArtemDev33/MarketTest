//
//  NetworkManager.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation

final class NetworkManager {
    
    private static let path = "https://www.swissquote.ch/mobile/iphone/Quote.action?formattedList&formatNumbers=true&listType=SMI&addServices=true&updateCounter=true&&s=smi&s=$smi&lastTime=0&&api=2&framework=6.1.1&format=json&locale=en&mobile=iphone&language=en&version=80200.0&formatNumbers=true&mid=5862297638228606086&wl=sq"
    
    func fetchQuotes(completionHandler: @escaping (([Quote]?, Error?) -> Void)) {
        guard let url = URL(string: NetworkManager.path) else {
            completionHandler(nil, Error.invalidURL)
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionHandler(nil, Error.unknown(reason: error?.localizedDescription))
                return
            }
            guard let data = data else {
                completionHandler(nil, Error.badResponse)
                return
            }
            guard let quotes = try? JSONDecoder().decode([Quote].self, from: data) else {
                completionHandler(nil, Error.invalidReponseFormat)
                return
            }
            completionHandler(quotes, nil)
        }.resume()
    }
}

// MARK: - Errors

extension NetworkManager {
    
    enum Error: LocalizedError {

        case invalidURL
        case unknown(reason: String?)
        case badResponse
        case invalidReponseFormat

        var errorDescription: String? {
            switch self {
            case .unknown(let reason):
                return "Something went wrong. \(reason ?? "")"
            case .invalidURL:
                return "Invalid url"
            case .badResponse:
                return "Bad response"
            case .invalidReponseFormat:
                return "Invalid response format"
            }
        }
    }
}
