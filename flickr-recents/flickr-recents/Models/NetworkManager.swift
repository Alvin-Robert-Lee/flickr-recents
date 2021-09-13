//
//  NetworkManager.swift
//  flickr-recents
//
//  Created by Alvin Lee on 9/13/21.
//

import Foundation

enum NetworkingError: String, Error {
    case urlFailure
    case invalidResponse
    case invalidData
    case unableToComplete
}

struct Photo: Decodable {
    let id: String
    let server: String
    let secret: String
    var title: String
    
    var thumbURL: String {
        get {
            return "\(imageServerURL)\(server)/\(id)_\(secret)_q.jpg"
        }
    }
 
    var largeImageURL: String {
        get {
            return "\(imageServerURL)\(server)/\(id)_\(secret)_b.jpg"
        }
    }
}

struct PhotosResponse: Decodable {
    let page: Int
    let pages: Int
    let photo: [Photo]
}

struct FlickrResponse: Decodable {
    let photos: PhotosResponse
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private let apiKey = "fee10de350d1f31d5fec0eaf330d2dba"
    private let flickrURL = "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent"
    
    //https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=fee10de350d1f31d5fec0eaf330d2dba&per_page=5&page=1&format=json&nojsoncallback=1
    func fetchImages(page: Int, perPage: Int = 20, completion: @escaping (Result<FlickrResponse, NetworkingError>) -> ()) {
        let urlString = "\(flickrURL)&api_key=\(apiKey)&per_page=\(perPage)&page=\(page)&format=json&nojsoncallback=1"
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlFailure))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let flickrResponse = try JSONDecoder().decode(FlickrResponse.self, from: data)
                completion(.success(flickrResponse))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}
