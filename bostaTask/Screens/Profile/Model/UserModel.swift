//
//  UserModel.swift
//  bostaTask
//
//  Created by Ahmed Khaled on 19/02/2023.
//

import Foundation

// MARK: - User
struct UserModel: Codable {
    let id: Int
    let name, username, email: String
    let address: AddressModel
    
}

// MARK: - Address
struct AddressModel: Codable {
    let street, suite, city, zipcode: String
}


