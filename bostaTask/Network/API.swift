//
//  NetworkService.swift
//  bostaTask
//
//  Created by Ahmed Khaled on 19/02/2023.
//

import Foundation
import Moya

enum API {
    
    case users
    case albums(userId:String)
    case Photos(albumId:String)
    
}

extension API : TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com") else {fatalError()}
        return url
    }
    
    var path: String {
        switch self {
        case .users:
            return "/users"
        case .albums:
            return "/albums"
        case .Photos:
            return "/photos"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .users:
            return .requestPlain
        case .albums(let userId):
            let parameters = ["userId":userId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .Photos(let albumId):
            let parameters = ["albumId":albumId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }

}
