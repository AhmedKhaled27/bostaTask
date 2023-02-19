//
//  ImageModel.swift
//  bostaTask
//
//  Created by Ahmed Khaled on 19/02/2023.
//

import Foundation

struct ImageModel: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}
