//
//  NetworkManager.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

final class NetworkManager: NetworkMangerProtocol {
    
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    private var baseComponents: URLComponents
    
    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        
        baseComponents = URLComponents()
        baseComponents.scheme = "https"
        baseComponents.host = "api.unsplash.com"
    }
    
    func getListPhotos(page: Int, perPage: Int, completion: @escaping (Result<[PhotoDTO], Error>) -> Void) {
        
        guard page > 0 else {
            print("Invalid page number. It should be greater than 0.")
            return
        }
        
        guard (10...30).contains(perPage) else {
            print("Invalid perPage number. It should be between 10 and 30.")
            return
        }
        
        var urlComponents = baseComponents
        urlComponents.path = "/photos"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        guard let url = urlComponents.url else {
            print("Falied to create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        let apiKey = "Client-ID " + (Bundle.main.infoDictionary?["API_KEY"] as? String ?? "")
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            
            let result = NetworkManager.validateNetworkResponse(data: data, response: response, error: error)
            
            switch result {
            case .success(let data):
                do {
                    let photos = try JSONDecoder().decode([PhotoDTO].self, from: data)
                    completion(.success(photos))
                } catch {
                    completion(.failure(NetworkError.decodingFailed))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getImage(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            let result = NetworkManager.validateNetworkResponse(data: data, response: response, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    private static func validateNetworkResponse(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> Result<Data, Error> {
        if let error {
            return .failure(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(NetworkError.badResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return .failure(NetworkError.invalidStatusCode(httpResponse.statusCode))
        }
        
        guard let data else {
            return .failure(NetworkError.noData)
        }
        
        return .success(data)
    }
}
