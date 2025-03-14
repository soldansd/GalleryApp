//
//  NetworkManager.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    private var baseComponents: URLComponents
    
    private var lock = NSLock()
    
    private var activeTasks: [String: URLSessionDownloadTask] = [:]
    
    private init() {
        let config = URLSessionConfiguration.default
        let delegateQueue = OperationQueue()
        delegateQueue.qualityOfService = .utility
        session = URLSession(configuration: config, delegate: nil, delegateQueue: delegateQueue)
        
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
        lock.lock()
        guard activeTasks[urlString] == nil else {
            lock.unlock()
            return
        }
        lock.unlock()
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = session.downloadTask(with: url) { [weak self] localURL, response, error in
            guard let self, let localURL, let data = try? Data(contentsOf: localURL) else { return }
            lock.lock()
            activeTasks.removeValue(forKey: urlString)
            lock.unlock()
            let result = NetworkManager.validateNetworkResponse(data: data, response: response, error: error)
            completion(result)
        }
        
        lock.lock()
        activeTasks[urlString] = task
        lock.unlock()
        
        task.resume()
    }
    
    func cancelTask(for urlString: String) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            lock.lock()
            if let task = activeTasks[urlString] {
                task.cancel()
                activeTasks.removeValue(forKey: urlString)
            }
            lock.unlock()
        }
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
