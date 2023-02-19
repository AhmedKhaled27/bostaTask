//
//  NetworkManager.swift
//  bostaTask
//
//  Created by Ahmed Khaled on 19/02/2023.
//

import Foundation
import Moya


protocol Networkable {
    
    var provider :MoyaProvider<API> {get}
    
    func getUsers(completion: @escaping (Result<[UserModel], Error>) -> ())
    func getUserAlbums(userId:String ,completion: @escaping (Result<[AlbumModel], Error>) -> ())
    func getAlbumImages(albumId:String ,completion: @escaping (Result<[ImageModel], Error>) -> ())
}

class NetworkManager : Networkable {

    var provider = Moya.MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    func getUsers(completion: @escaping (Result<[UserModel], Error>) -> ()) {
        request(target: .users, completion: completion)
    }
    
    func getUserAlbums(userId: String, completion: @escaping (Result<[AlbumModel], Error>) -> ()) {
        request(target: .albums(userId: userId), completion: completion)
    }
    
    func getAlbumImages(albumId: String, completion: @escaping (Result<[ImageModel], Error>) -> ()) {
        request(target: .Photos(albumId: albumId), completion: completion)
    }

}

private extension NetworkManager {
    
    private func request<T: Decodable>(target: API, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
