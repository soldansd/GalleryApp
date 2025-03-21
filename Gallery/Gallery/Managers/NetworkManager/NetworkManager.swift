//
//  NetworkManager.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: Properties
    
    private let session: URLSession
    
    private var baseComponents: URLComponents
    
    // MARK: - Init
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        
        baseComponents = URLComponents()
        baseComponents.scheme = "https"
        baseComponents.host = "api.unsplash.com"
    }
    
    // MARK: - Methods
    
    func getListPhotos(page: Int, perPage: Int, completion: @escaping (Result<[PhotoDTO], Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        makeNetworkRequest(path: "/photos", queryItems: queryItems, completion: completion)
    }
    
    func getPhoto(id: String, completion: @escaping (Result<PhotoDTO, Error>) -> Void) {
        makeNetworkRequest(path: "/photos/\(id)", completion: completion)
    }
    
    func getData(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
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
    
    private func makeNetworkRequest<T: Decodable>(
        path: String,
        method: String = "GET",
        queryItems: [URLQueryItem]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var urlComponents = baseComponents
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        let apiKey = "Client-ID " + (Bundle.main.infoDictionary?["API_KEY"] as? String ?? "")
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            let result = NetworkManager.validateNetworkResponse(data: data, response: response, error: error)
            
            switch result {
            case .success(let data):
                completion(Result { try JSONDecoder().decode(T.self, from: data) })
                
            case .failure(let error):
                completion(.failure(error))
            }
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
